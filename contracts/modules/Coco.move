module CoCo {
    use 0x1::Token;
    use 0x1::Account;
    use 0x1::Signer;

    struct CoCo { }

    public fun initialize(signer: &signer, initial_supply: u128) {
        Token::register_token<CoCo>(signer, 6);
        Account::accept_token<CoCo>(signer);
        let tokens = Token::mint<CoCo>(signer, initial_supply);
        Account::deposit<CoCo>(Signer::address_of(signer), tokens);
    }
}