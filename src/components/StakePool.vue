<template>
  <a-row>
    <a-col :span="10" :offset="7">
      <div>
        <a-card title="Pool Info" :style="cardStyle">
          <p>
            Total Staked: <strong>{{ poolInfo.totalStake }}</strong> STC
          </p>
          <p>Reward Duration: {{ poolInfo.duration }} blocks</p>
          <div v-if="connectedAddress">
            <a-card title="My Balance">
              <div>
                STC balance: <strong>{{ userInfo.stcBalance }}</strong> STC
              </div>
              <div>
                CoCo balance: <strong>{{ userInfo.cocoBalance }}</strong> CoCo
              </div>
              <p>
                Staked STC: <strong>{{ userInfo.stakedSTC }}</strong> STC
              </p>
              <p>
                Earned CoCo: <strong>{{ userInfo.myEarned }}</strong> CoCo
              </p>

              <a-form layout="inline" :model="stakeForm" @submit="stake">
                <a-form-item>
                  <a-input v-model:value="stakeForm.toStake" placeholder="">
                  </a-input>
                </a-form-item>
                <a-form-item>
                  <a-button type="primary" html-type="submit" block="true">
                    Stake
                  </a-button>
                </a-form-item>
              </a-form>
              <a-row :gutter="[16, 16]">
                <a-col span="12">
                  <a-button type="primary" @click="clarmRewards" block="true"
                    >GetRewards</a-button
                  >
                </a-col>
                <a-col span="12">
                  <a-button type="danger" block="true" @click="exitPool"
                    >Exit</a-button
                  >
                </a-col>
              </a-row>
            </a-card>
          </div>
          <div v-else>
            <a-input-search
              v-model:value="addressForm.address"
              placeholder="Enter a valid starcoin address"
              enter-button="Let's Go"
              size="large"
              @search="onConnectWallet"
            />
          </div>
        </a-card>
      </div>
    </a-col>
  </a-row>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { NODE_URL, STDLIB_ADDRESS } from "@/config";
import { HTTPProvider, starcoin, types } from "starcoin-typescript-sdk";
import { encode_tx_payload } from "starcoin-typescript-sdk/build/main/utils/tx";
// import stake_mv from "url-loader!../../contracts/target/stake.mv";
// console.log(stake_mv);
import code from "../code";
import { str } from "starcoin-typescript-sdk/build/main/lib/runtime/serde/types";
import {
  MoveStruct,
  MoveValue
} from "starcoin-typescript-sdk/build/main/types";
console.log(code);

const stcProvider = new HTTPProvider(NODE_URL);

export default defineComponent({
  name: "StakePool",
  props: {
    poolModuleName: {
      type: String,
      required: true
    },
    poolAddress: {
      type: String,
      required: true
    },
    poolStakeToken: {
      type: String,
      required: true
    },
    poolRewardToken: {
      type: String,
      required: true
    }
  },
  data() {
    const existedAddress = sessionStorage.getItem("connectedAddress") || "";
    return {
      poolInfo: {
        totalStake: 0,
        duration: 0
      },
      connectedAddress: existedAddress,
      addressForm: {
        address: ""
      },

      userInfo: {
        myBalance: 0,
        myEarned: 0,
        stakedSTC: 0,
        stcBalance: 0,
        cocoBalance: 0
      },
      stakeForm: {
        toStake: 0
      }
    };
  },
  methods: {
    cardStyle() {
      return {
        width: "300px"
      };
    },
    sendPayload(payload: string) {
      const relocate = `stc://wallet.starcoin.org/${payload}`;
      window.location.replace(relocate);
    },
    async stake() {
      const toStake = this.stakeForm.toStake;
      console.log(toStake);
      console.log(code.stake);
      const blob = await fetch(code.stake)
        .then(res => res.blob())
        .then(b => b.arrayBuffer());
      const stake_code = new Uint8Array(blob);
      console.log(stake_code);
      const payload = encode_tx_payload(
        stake_code,
        [this.stakeTokenTypeTag, this.rewardTokenTypeTag],
        [{ Address: this.poolAddress }, { U128: toStake }]
      );
      this.sendPayload(payload);
    },

    async clarmRewards() {
      const blob = await fetch(code.withdraw_rewards)
        .then(res => res.blob())
        .then(b => b.arrayBuffer());
      const payload = encode_tx_payload(
        new Uint8Array(blob),
        [this.stakeTokenTypeTag, this.rewardTokenTypeTag],
        [{ Address: this.connectedAddress }]
      );
      this.sendPayload(payload);
    },

    async exitPool() {
      const blob = await fetch(code.exit_pool)
        .then(res => res.blob())
        .then(b => b.arrayBuffer());
      const payload = encode_tx_payload(
        new Uint8Array(blob),
        [this.stakeTokenTypeTag, this.rewardTokenTypeTag],
        [{ Address: this.connectedAddress }]
      );
      this.sendPayload(payload);
    },
    onConnectWallet(value: string) {
      console.log(value);
      if (value && value.startsWith("0x")) {
        this.connectedAddress = value;
        sessionStorage.setItem("connectedAddress", value);
      }
    },
    async isAcceptRewardToken(user: types.AccountAddress) {
      const data = await starcoin.dev.call_contract.execute(stcProvider, {
        module_address: STDLIB_ADDRESS,
        module_name: "Account",
        func: "is_accepts_token",
        type_args: [this.rewardTokenTypeTag],
        args: [{ Address: user }]
      });
      console.log("is accept coco: ", JSON.stringify(data));
      return data[0] as boolean;
    },
    async isAcceptStakeToken(user: types.AccountAddress) {
      const data = await starcoin.dev.call_contract.execute(stcProvider, {
        module_address: STDLIB_ADDRESS,
        module_name: "Account",
        func: "is_accepts_token",
        type_args: [this.stakeTokenTypeTag],
        args: [{ Address: user }]
      });
      return data[0] as boolean;
    },
    async balanceOfRewardToken(user: types.AccountAddress) {
      const data = await starcoin.dev.call_contract.execute(stcProvider, {
        module_address: STDLIB_ADDRESS,
        module_name: "Account",
        func: "balance",
        type_args: [this.rewardTokenTypeTag],
        args: [{ Address: user }]
      });
      console.log("reward token balance: " + JSON.stringify(data));
      return data[0] as number;
    },
    async balanceOfStakeToken(user: types.AccountAddress) {
      const data = await starcoin.dev.call_contract.execute(stcProvider, {
        module_address: STDLIB_ADDRESS,
        module_name: "Account",
        func: "balance",
        type_args: [this.stakeTokenTypeTag],
        args: [{ Address: user }]
      });
      return data[0] as number;
    },
    async stakedOfUser(user: types.AccountAddress) {
      const data = await starcoin.dev.call_contract.execute(stcProvider, {
        module_address: this.poolModule.module_address,
        module_name: this.poolModule.module_name,
        func: "staked_share",
        type_args: [this.stakeTokenTypeTag, this.rewardTokenTypeTag],
        args: [{ Address: user }, { Address: this.poolAddress }]
      });
      console.log("stakeOfUser: " + JSON.stringify(data));
      const ret = data[0] as MoveStruct;
      const elems = ret.vec as MoveValue[];
      if (elems.length == 0) {
        return 0;
      } else {
        return elems[0] as number;
      }
    },
    async userEarned(user: types.AccountAddress) {
      const data = await starcoin.dev.call_contract.execute(stcProvider, {
        module_address: this.poolModule.module_address,
        module_name: this.poolModule.module_name,
        func: "earned",
        type_args: [this.stakeTokenTypeTag, this.rewardTokenTypeTag],
        args: [{ Address: user }, { Address: this.poolAddress }]
      });
      console.log("earnedOfUser: " + data);
      return data[0] as number;
    },
    async fetchUserData() {
      if (!this.connectedAddress) {
        return;
      }

      this.userInfo.stcBalance = await this.balanceOfStakeToken(
        this.connectedAddress
      );
      const acceptRewardToken = await this.isAcceptRewardToken(
        this.connectedAddress
      );
      if (acceptRewardToken) {
        this.userInfo.cocoBalance = await this.balanceOfRewardToken(
          this.connectedAddress
        );
      }
      this.userInfo.stakedSTC = await this.stakedOfUser(this.connectedAddress);
      if (this.userInfo.stakedSTC != 0) {
        this.userInfo.myEarned = await this.userEarned(this.connectedAddress);
      }
    },
    async fetchPoolData() {
      {
        const data = await starcoin.dev.call_contract.execute(stcProvider, {
          module_address: this.poolModule.module_address,
          module_name: this.poolModule.module_name,
          func: "total_staked_shares",
          type_args: [this.stakeTokenTypeTag, this.rewardTokenTypeTag],
          args: [{ Address: this.poolAddress }]
        });
        this.poolInfo.totalStake = data[0] as number;
      }
      {
        const data = await starcoin.dev.call_contract.execute(stcProvider, {
          module_address: this.poolModule.module_address,
          module_name: this.poolModule.module_name,
          func: "duration",
          type_args: [this.stakeTokenTypeTag, this.rewardTokenTypeTag],
          args: [{ Address: this.poolAddress }]
        });
        this.poolInfo.duration = data[0] as number;
      }
    }
  },
  // eslint-disable-next-line @typescript-eslint/no-empty-function
  async created() {
    await this.fetchPoolData();
    await this.fetchUserData();
  },
  computed: {
    poolModule() {
      const parts: string[] = this.poolModuleName.split("::", 2);
      return {
        module_address: parts[0],
        module_name: parts[1]
      };
    },
    stakeTokenTypeTag(): types.TypeTag {
      const stakeTokenInfo = this.poolStakeToken.split("::", 3);
      return {
        Struct: {
          address: stakeTokenInfo[0],
          module: stakeTokenInfo[1],
          name: stakeTokenInfo[2],
          type_params: []
        }
      };
    },
    rewardTokenTypeTag(): types.TypeTag {
      const rewardTokenInfo = this.poolRewardToken.split("::", 3);
      return {
        Struct: {
          address: rewardTokenInfo[0],
          module: rewardTokenInfo[1],
          name: rewardTokenInfo[2],
          type_params: []
        }
      };
    }
  }
});
</script>
