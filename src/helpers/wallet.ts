export function sendPayload(payload: string) {
    const relocate = `stc://wallet.starcoin.org/${payload}`;
    window.location.replace(relocate);
}
