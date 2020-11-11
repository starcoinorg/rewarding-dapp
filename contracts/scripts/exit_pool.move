script {
    use {{sender}}::RewardPool;
    use 0x1::Account;
    use 0x1::Signer;
    use 0x1::Token;
    fun exit_pool<StakeToken, RewardToken>(signer: &signer, pool: address) {
        let (staked, earned) = RewardPool::exit<StakeToken, RewardToken>(signer, pool);
        Account::deposit<StakeToken>(Signer::address_of(signer), staked);

        if (!Account::is_accepts_token<RewardToken>(Signer::address_of(signer))) {
            Account::accept_token<RewardToken>(signer);
        };
        if (Token::value<RewardToken>(&earned) > 0) {
            Account::deposit<RewardToken>(Signer::address_of(signer), earned);
        } else {
            Token::destroy_zero<RewardToken>(earned);
        };
    }
}