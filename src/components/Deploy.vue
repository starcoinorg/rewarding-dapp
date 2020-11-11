<template>
  <a-row>
    <a-col span="10" offset="7">
      <div>
        <a-button type="primary" @click="deployCoCoAndPool">Deploy</a-button>
      </div>
    </a-col>
  </a-row>
</template>
<script lang="ts">
import { defineComponent } from "vue";
import code from "../code";
import { utils } from "starcoin-typescript-sdk";
import { Deployer, stakeTokenTypeTag } from "@/config";
import { sendPayload } from "@/helpers/wallet";
export default defineComponent({
  name: "Deploy",
  data() {
    return {
      deployer: Deployer
    };
  },
  methods: {
    async deployCoCoAndPool() {
      const poolCode = await fetch(code.RewardPool)
        .then(res => res.blob())
        .then(b => b.arrayBuffer());
      const rewardTokenCode = await fetch(code.CoCo)
        .then(res => res.blob())
        .then(b => b.arrayBuffer());
      const initScriptCode = await fetch(code.create_coco_and_pool)
        .then(res => res.blob())
        .then(b => b.arrayBuffer());
      const payload = utils.tx.encodeDeployModulesPayload(
        this.deployer,
        [new Uint8Array(rewardTokenCode), new Uint8Array(poolCode)],
        {
          code: new Uint8Array(initScriptCode),
          ty_args: [stakeTokenTypeTag()],
          args: [{ U128: 10_000_000 }, { U64: 3600 }]
        }
      );
      sendPayload(payload);
    }
  }
});
</script>
