script {
    use {{sender}}::RewardPool;
    use 0x1::Account;

    fun create_pool<StakeToken, RewardToken>(signer: &signer, initial_reward: u128, duration: u64) {
        let rewards = Account::withdraw<RewardToken>(signer, initial_reward);
        RewardPool::initialize<StakeToken, RewardToken>(signer, rewards, duration);
    }
}