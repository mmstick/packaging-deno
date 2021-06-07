clean() {
    rm -rf debian/.debhelper

    if test "${CLEAN}" -eq "1"; then
        cargo clean
    fi

    if test "${VENDOR}" -eq "1" && ! ischroot && ! test -e vendor.tar; then
        vendor
    fi
}

vendor() {
    mkdir -p .cargo
	cargo vendor \
        --sync bench_util/Cargo.toml \
        --sync cli/Cargo.toml \
        --sync core/Cargo.toml \
        --sync runtime/Cargo.toml \
        --sync serde_v8/Cargo.toml \
        --sync test_plugin/Cargo.toml \
        --sync test_util/Cargo.toml \
        --sync extensions/console/Cargo.toml \
        --sync extensions/crypto/Cargo.toml \
        --sync extensions/fetch/Cargo.toml \
        --sync extensions/file/Cargo.toml \
        --sync extensions/timers/Cargo.toml \
        --sync extensions/url/Cargo.toml \
        --sync extensions/web/Cargo.toml \
        --sync extensions/webgpu/Cargo.toml \
        --sync extensions/webidl/Cargo.toml \
        --sync extensions/websocket/Cargo.toml \
        --sync extensions/webstorage/Cargo.toml \
        | head -n -1 > .cargo/config
	echo 'directory = "vendor"' >> .cargo/config
	tar pcf vendor.tar vendor
	rm -rf vendor
}

extract() {
    if test "${VENDOR}" -eq "1"; then
        tar pxf ./vendor.tar
    fi
}

$1