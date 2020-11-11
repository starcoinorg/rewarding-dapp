const create_coco = require("../../contracts/target/create_coco.mv");
const stake = require("../../contracts/target/stake.mv");
const withdraw_rewards = require("../../contracts/target/withdraw_rewards.mv");
const exit_pool = require("../../contracts/target/exit_pool.mv");
const create_coco_and_pool = require("../../contracts/target/create_coco_and_pool.mv");
const CoCo = require("../../contracts/target/modules/Coco.mv");
const RewardPool = require("../../contracts/target/modules/RewardPool.mv");
export default {
    create_coco,
    stake,
    withdraw_rewards,
    exit_pool,
    create_coco_and_pool,
    CoCo,
    RewardPool
};
