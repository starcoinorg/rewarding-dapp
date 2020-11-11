<template>
  <div class="home">
    <StakePool
      :pool-address="poolInfo.poolAddress"
      :pool-module-name="poolInfo.poolModuleName"
      :pool-reward-token="poolInfo.poolRewardToken"
      :pool-stake-token="poolInfo.poolStakeToken"
    >
    </StakePool>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";

import StakePool from "@/components/StakePool.vue";
import {
  poolAddress,
  poolModuleName,
  poolRewardToken,
  poolStakeToken
} from "@/config"; // @ is an alias to /src

export default defineComponent({
  name: "Home",
  components: {
    StakePool
  },

  computed: {
    poolInfo() {
      return {
        poolAddress: poolAddress,
        poolModuleName: poolModuleName,
        poolStakeToken: poolStakeToken,
        poolRewardToken: poolRewardToken
      };
    }
  }
});
</script>
