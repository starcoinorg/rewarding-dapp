script {
    use {{sender}}::RewardPool;
    use 0x1::Account;
    use 0x1::Signer;
    use 0x1::Token;

    fun withdraw_rewards<StakeToken, RewardToken>(signer: &signer, pool: address) {
        let rewards = RewardPool::withdraw_rewards<StakeToken, RewardToken>(signer, pool);
        if (!Account::is_accepts_token<RewardToken>(Signer::address_of(signer))) {
            Account::accept_token<RewardToken>(signer);
        };
        if (Token::value<RewardToken>(&rewards) > 0) {
            Account::deposit<RewardToken>(Signer::address_of(signer), rewards);
        } else {
            Token::destroy_zero<RewardToken>(rewards);
        };
    }
}