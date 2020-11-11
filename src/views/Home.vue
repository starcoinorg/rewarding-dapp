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

import StakePool from "@/components/StakePool.vue"; // @ is an alias to /src

export default defineComponent({
  name: "Home",
  components: {
    StakePool
  },

  computed: {
    poolInfo() {
      return {
        poolAddress: "2291c747b396303a6475db8468a910d0",
        poolModuleName: "2291c747b396303a6475db8468a910d0::RewardPool",
        poolStakeToken: "00000000000000000000000000000001::STC::STC",
        poolRewardToken: "2291c747b396303a6475db8468a910d0::CoCo::CoCo"
      };
    }
  }
});
</script>
