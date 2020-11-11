script {
    use {{sender}}::CoCo;

    fun create_coco(signer: &signer, initial_supply: u128) {
        CoCo::initialize(signer, initial_supply);
    }
}