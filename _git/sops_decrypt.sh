#!/usr/bin/env bash
set -euo pipefail

scriptdir="$( dirname -- "$BASH_SOURCE"; )"
repo_root=$(realpath "$scriptdir/../")

SOPS_AGE_KEY=()

conv_age_key () {
    [[ $# -ne 1 ]] && return;

    if [[ -r $1 ]]; then
        key=$(ssh-to-age -private-key -i $1)
        [[ ! -z $key ]] && SOPS_AGE_KEY+=($key)
    fi
}

load_age_keys() {
    command -v ssh-to-age >/dev/null 2>&1 || {
        echo "WARN: ssh-to-age not found. Skip convert ssh-keys."
        return
    }

    conv_age_key "/etc/ssh/ssh_host_ed25519_key"
    conv_age_key "$HOME/.ssh/id_ed25519"

    SOPS_AGE_KEY=$(printf "%s\n" "${SOPS_AGE_KEY[*]}")
}

decrypt_file() {
    local input_file=$1
    local output_file=${input_file//.enc/}

    [[ ! -r $input_file ]] && {
        echo "ERR: Unable to get file content. Path: $input_file"
        return
    }

    SOPS_AGE_KEY=$SOPS_AGE_KEY sops --config "$repo_root/.sops.yaml" --decrypt --input-type yaml --output-type binary --output $output_file $input_file 2>/dev/null
    [[ $? -eq 0 ]] || echo "Decrypt: Skip $input_file"
}

do_decrypt() {
    command -v sops >/dev/null 2>&1 || {
        echo "ERR: command sops not found. exit..."
        exit 1
    }

    load_age_keys

    for f in $(find $repo_root -name "secrets.enc.toml"); do
        decrypt_file $f
    done
}

do_decrypt