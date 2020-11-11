script {
    use {{sender}}::RewardPool;
    use 0x1::Account;

    fun stake<StakeToken, RewardToken>(signer: &signer, pool: address, stake: u128) {
        let to_stake = Account::withdraw<StakeToken>(signer, stake);
        RewardPool::stake<StakeToken, RewardToken>(signer, pool, to_stake);
    }
}