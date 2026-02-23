{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.hm.dag) entryAfter;
in
{
  home.activation =
    if pkgs.stdenv.hostPlatform.isDarwin then
      {
        ensureSopsDecrypted = entryAfter [ "writeBoundary" ] ''
          plist_path="$HOME/Library/LaunchAgents/org.nix-community.home.sops-nix.plist"

          if [[ ! -e "$plist_path" ]]; then
            gen_path="${"newGenPath:-$oldGenPath"}"

            if [[ -n "$gen_path" && -d "$gen_path" ]]; then
              for item in "$gen_path"/*-sops-nix-user; do
                if [[ -f "$item" ]]; then
                  "$item" 2>/dev/null || true
                  break
                fi
              done
            fi
          fi
        '';

        createRaycastCommands = entryAfter [ "linkGeneration" ] ''
                    RAYCAST_DIR="$HOME/.local/share/raycast/commands"
                    mkdir -p "$RAYCAST_DIR"
                    mkdir -p "$HOME/.local/share/flake/scripts"

                    # Symlink new scripts (oll, opz, doll)
                    ln -sf "$HOME/.config/flake/scripts/oll" "$HOME/.local/share/flake/scripts/oll" 2>/dev/null || true
                    ln -sf "$HOME/.config/flake/scripts/opz" "$HOME/.local/share/flake/scripts/opz" 2>/dev/null || true
                    ln -sf "$HOME/.config/flake/scripts/doll" "$HOME/.local/share/flake/scripts/doll" 2>/dev/null || true

                    # Legacy symlinks (for backwards compatibility)
                    ln -sf "$HOME/.config/flake/scripts/ollamactl" "$HOME/.local/share/flake/scripts/ollamactl" 2>/dev/null || true
                    ln -sf "$HOME/.config/flake/scripts/connect-ollama" "$HOME/.local/share/flake/scripts/connect-ollama" 2>/dev/null || true
                    ln -sf "$HOME/.config/flake/scripts/toggle-capslock.sh" "$HOME/.local/share/flake/scripts/toggle-capslock.sh" 2>/dev/null || true
                    ln -sf "$HOME/.config/flake/scripts/agent-tasks" "$HOME/.local/share/flake/scripts/agent-tasks" 2>/dev/null || true
                    ln -sf "$HOME/.config/flake/scripts/agent-tasks-dashboard" "$HOME/.local/share/flake/scripts/agent-tasks-dashboard" 2>/dev/null || true
                    ln -sf "$HOME/.config/flake/scripts/time-room-dashboard" "$HOME/.local/share/flake/scripts/time-room-dashboard" 2>/dev/null || true
                    ln -sf "$HOME/.config/flake/scripts/just-provision" "$HOME/.local/share/flake/scripts/just-provision" 2>/dev/null || true

                    # Copy OpenCode skills
                    mkdir -p "$HOME/.config/opencode/skills"
                    cp -r "$HOME/.config/flake/.opencode/skills/"* "$HOME/.config/opencode/skills/" 2>/dev/null || true

                    # Toggle Caps Lock
                    cat > "$RAYCAST_DIR/Toggle Caps Lock.sh" << 'RAYCAST_EOF'
          #!/bin/bash
          "$HOME/.local/share/flake/scripts/toggle-capslock.sh"
          RAYCAST_EOF
                    chmod +x "$RAYCAST_DIR/Toggle Caps Lock.sh"

                    # Ollama Dashboard
                    cat > "$RAYCAST_DIR/Ollama Dashboard.sh" << 'RAYCAST_EOF'
          #!/bin/bash
          "$HOME/.local/share/flake/scripts/doll"
          RAYCAST_EOF
                    chmod +x "$RAYCAST_DIR/Ollama Dashboard.sh"

                    # Ollama Start
                    cat > "$RAYCAST_DIR/Ollama Start.sh" << 'RAYCAST_EOF'
          #!/bin/bash
          "$HOME/.local/share/flake/scripts/oll" server start
          RAYCAST_EOF
                    chmod +x "$RAYCAST_DIR/Ollama Start.sh"

                    # Ollama Stop
                    cat > "$RAYCAST_DIR/Ollama Stop.sh" << 'RAYCAST_EOF'
          #!/bin/bash
          "$HOME/.local/share/flake/scripts/oll" server stop
          RAYCAST_EOF
                    chmod +x "$RAYCAST_DIR/Ollama Stop.sh"

                    # Ollama Status
                    cat > "$RAYCAST_DIR/Ollama Status.sh" << 'RAYCAST_EOF'
          #!/bin/bash
          "$HOME/.local/share/flake/scripts/oll" status
          RAYCAST_EOF
                    chmod +x "$RAYCAST_DIR/Ollama Status.sh"

                    # OpenCode
                    cat > "$RAYCAST_DIR/OpenCode.sh" << 'RAYCAST_EOF'
          #!/bin/bash
          "$HOME/.local/share/flake/scripts/opz"
          RAYCAST_EOF
                    chmod +x "$RAYCAST_DIR/OpenCode.sh"

                    # Provision Nebulanix
                    cat > "$RAYCAST_DIR/Provision Nebulanix.sh" << 'RAYCAST_EOF'
          #!/bin/bash
          "$HOME/.local/share/flake/scripts/just-provision" nebulanix --heal
          RAYCAST_EOF
                    chmod +x "$RAYCAST_DIR/Provision Nebulanix.sh"

                    # Provision Spacehound
                    cat > "$RAYCAST_DIR/Provision Spacehound.sh" << 'RAYCAST_EOF'
          #!/bin/bash
          "$HOME/.local/share/flake/scripts/just-provision" spacehound --heal
          RAYCAST_EOF
                    chmod +x "$RAYCAST_DIR/Provision Spacehound.sh"

                    # Provision Check
                    cat > "$RAYCAST_DIR/Provision Check.sh" << 'RAYCAST_EOF'
          #!/bin/bash
          "$HOME/.local/share/flake/scripts/just-provision" --check
          RAYCAST_EOF
                    chmod +x "$RAYCAST_DIR/Provision Check.sh"
        '';
      }
    else
      { };

}
