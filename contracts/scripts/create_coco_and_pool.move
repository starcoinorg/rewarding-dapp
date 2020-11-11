script {
    use {{sender}}::CoCo;
    use {{sender}}::RewardPool;
    use 0x1::Account;

    fun create_coco_and_pool<StakeToken>(signer: &signer, initial_supply: u128, duration: u64) {
        CoCo::initialize(signer, initial_supply);
        let rewards = Account::withdraw<CoCo::CoCo>(signer, initial_supply);
        RewardPool::initialize<StakeToken, CoCo::CoCo>(signer, rewards, duration);
    }
}
