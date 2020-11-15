export const NODE_URL = "http://localhost:9850";
export const STDLIB_ADDRESS = "0x00000000000000000000000000000001";
// replace this with your deployer address.
export const Deployer = "0x2291c747b396303a6475db8468a910d0";
export const poolAddress = Deployer;
export const poolModuleName = `${Deployer}::RewardPool`;
export const poolStakeToken = `${STDLIB_ADDRESS}::STC::STC`;
export const poolRewardToken = `${Deployer}::CoCo::CoCo`;

import { types } from "starcoin-typescript-sdk";

export function stakeTokenTypeTag(): types.TypeTag {
  const stakeTokenInfo = poolStakeToken.split("::", 3);
  return {
    Struct: {
      address: stakeTokenInfo[0],
      module: stakeTokenInfo[1],
      name: stakeTokenInfo[2],
      type_params: [],
    },
  };
}

export function rewardTokenTypeTag(): types.TypeTag {
  const rewardTokenInfo = poolRewardToken.split("::", 3);
  return {
    Struct: {
      address: rewardTokenInfo[0],
      module: rewardTokenInfo[1],
      name: rewardTokenInfo[2],
      type_params: [],
    },
  };
}
