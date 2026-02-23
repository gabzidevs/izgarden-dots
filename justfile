flake := env('FLAKE', justfile_directory())

# rebuild is also set as a var so you can add --set to change it if you need to

rebuild := if os() == "macos" { "sudo darwin-rebuild" } else { "nixos-rebuild" }
system-args := if os() == "macos" { "" } else { "--sudo --no-reexec" }

[private]
default:
    @just --list --unsorted

# rebuild group

[group('rebuild')]
[no-exit-message]
[private]
builder goal *args:
    #!/usr/bin/env bash
    set -euo pipefail
    {{ rebuild }} {{ goal }} \
      --flake {{ flake }} \
      --log-format internal-json \
      {{ system-args }} \
      {{ args }} \
      |& nom --json

[group('rebuild')]
[no-exit-message]
deploy host *args:
    #!/usr/bin/env bash
    set -euo pipefail
    before=$(ssh -q {{ host }} 'readlink /run/current-system')
    just builder switch --target-host {{ host }} --use-substitutes {{ args }}

    if [[ -n "${DEPLOY_SUMMARY:-}" ]]; then
        {
            echo "===== {{ host }} ====="
            ssh -q {{ host }} TERM=xterm-256color lix diff "$before"
            echo
        } >> "$DEPLOY_SUMMARY"
    else
        ssh {{ host }} TERM=xterm-256color lix diff "$before"
    fi

[group('rebuild')]
[no-exit-message]
deploy-all:
    #!/usr/bin/env bash
    set -euo pipefail
    export DEPLOY_SUMMARY=".deploy-summary"
    : > "$DEPLOY_SUMMARY"

    just deploy minerva
    just deploy athena
    just deploy aphrodite
    just deploy skadi
    just deploy hephaestus
    just deploy isis

    echo
    echo "===== DEPLOYMENT SUMMARY ====="
    cat "$DEPLOY_SUMMARY"
    rm "$DEPLOY_SUMMARY"

# rebuild the boot
[group('rebuild')]
[no-exit-message]
boot *args: (builder "boot" args)

# test what happens when you switch
[group('rebuild')]
[no-exit-message]
test *args: (builder "test" args)

# switch the new system configuration
[group('rebuild')]
[no-exit-message]
switch *args:
    #!/usr/bin/env bash
    set -euo pipefail
    before=$(readlink /run/current-system)
    just builder switch {{ args }}
    lix diff "$before"

# provision a new macOS host (use --use-nix-daemon to work around Lix daemon bugs)
[group('rebuild')]
[macos]
[arg('use_nix_daemon', long="use-nix-daemon", value="false")]
[arg('cleanup_lix', long="cleanup-lix", value="false")]
provision host use_nix_daemon="false" cleanup_lix="false":
    #!/usr/bin/env bash
    set -uo pipefail
    
    echo "=== Starting provision for {{ host }} ===" >&2
    
    # Run nix-darwin rebuild with live output
    # Note: nix-darwin often returns exit code 1 even on success, so we check output
    if [[ "{{ use_nix_daemon }}" == "true" ]]; then
        "{{ justfile_directory() }}/scripts/with-nix-daemon.sh" \
            sudo -E nix run github:LnL7/nix-darwin -- switch --flake {{ flake }}#{{ host }} 2>&1 | tee /tmp/nix-darwin-output.log
    else
        sudo -E nix run github:LnL7/nix-darwin -- switch --flake {{ flake }}#{{ host }} 2>&1 | tee /tmp/nix-darwin-output.log
    fi
    NIX_DARWIN_EXIT=${PIPESTATUS[0]}
    
    # Check if rebuild actually failed (not just exit code 1 quirk)
    if grep -q "error:" /tmp/nix-darwin-output.log; then
        echo "⚠️ nix-darwin rebuild had errors, continuing with post-install tasks..." >&2
        tail -20 /tmp/nix-darwin-output.log >&2
    else
        echo "✅ nix-darwin rebuild successful"
    fi
    
    echo "=== Build complete! Running post-install tasks ===" >&2
    
    # Cleanup lix if requested
    if [[ "{{ cleanup_lix }}" == "true" ]]; then
        if ! sudo -i nix-env --uninstall lix; then
            echo "⚠️ Failed to uninstall lix" >&2
        fi
    fi
    
    # Setup PATH for mise shims
    export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"
    
    # Find mise executable
    MISE_PATH="$(command -v mise 2>/dev/null || true)"
    
    # Run mise as current user (not sudo)
    echo "=== Installing mise tools ===" >&2
    if [[ -z "$MISE_PATH" ]]; then
        echo "⚠️ mise not found in PATH, skipping mise install" >&2
    elif ! "$MISE_PATH" install; then
        echo "⚠️ mise install failed" >&2
    fi
    if [[ -n "$MISE_PATH" ]]; then
        "$MISE_PATH" ls
    fi
    
    # Install OpenCode plugins
    # echo "=== Installing OpenCode plugins ===" >&2
    # if [[ -n "$MISE_PATH" ]]; then
    #     mkdir -p ~/.cache/opencode
    #     cd ~/.cache/opencode && "$MISE_PATH" x bun -- bun install 2>&1 || echo "⚠️ OpenCode plugin install failed" >&2
    # else
    #     echo "⚠️ mise not found, skipping OpenCode plugins" >&2
    # fi
    
    echo "=== ✅ Provision complete! ===" >&2

# package group
# build the package, you must specify the package you want to build

# build the iso image, you must specify the image you want to build
[group('package')]
[no-exit-message]
iso image:
    nom build {{ flake }}#nixosConfigurations.{{ image }}.config.system.build.isoImage

# build the tarball, you must specify the host you want to build
[group('package')]
[no-exit-message]
tar host:
    sudo nix run {{ flake }}#nixosConfigurations.{{ host }}.config.system.build.tarballBuilder

# dev group

# check the flake for errors
[group('dev')]
[no-exit-message]
check *args:
    nix flake check --option allow-import-from-derivation false {{ args }}

[group('dev')]
[no-exit-message]
repl-host host=`hostname`:
    nix repl .#nixosConfigurations.{{ host }}

# update a set of given inputs
[group('dev')]
[no-exit-message]
update *input:
    nix flake update {{ input }} \
      --refresh \
      --commit-lock-file \
      --commit-lockfile-summary "flake.lock: update {{ if input == "" { "all inputs" } else { input } }}" \
      --flake {{ flake }}

# build & serve the docs locally
[group('dev')]
[no-exit-message]
serve:
    nix run {{ flake }}#docs.serve

# push to the mirrors
[group('dev')]
[no-exit-message]
push-mirrors:
    git push git@gitlab.com:isabelroses/dotfiles.git
    git push --mirror ssh://git@codeberg.org/isabel/dotfiles.git
    git push --mirror git@tangled.org:isabelroses.com/dotfiles

# rotate all secrets
[group('dev')]
[no-exit-message]
roate-secrets:
    find secrets/ -name "*.yaml" | xargs -I {} sops rotate -i {}

# update the secret keys
[group('dev')]
[no-exit-message]
update-secrets:
    find secrets/ -name "*.yaml" | xargs -I {} sops updatekeys -y {}

# utils group

alias fix := repair

# verify the integrity of the nix store
[group('utils')]
[no-exit-message]
verify *args:
    nix-store --verify {{ args }}

# repairs the nix store from any breakages it may have
[group('utils')]
[no-exit-message]
repair: (verify "--check-contents --repair")

# clean the nix store and optimise it
[group('utils')]
[no-exit-message]
clean:
    nix-collect-garbage --delete-older-than 3d
    nix store optimise
