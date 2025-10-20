{ config, pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  programs.zellij = {
    inherit (config.garden.profiles.workstation) enable;
    # enable = false;

    enableFishIntegration = true;
    enableZshIntegration = true;

    settings = {
      session_name = "gzw~";
      attach_to_session = true;
      on_force_close = "quit";
      default_mode = "locked";
      default_shell = getExe config.programs.fish.package;
      # scrollback-editor = getExe config.programs.neovim.package;
      scrollback-editor = "${getExe config.programs.mise.package} x neovim@latest -- nvim";

      keybinds._props.clear-defaults = true;
      keybinds._children = [
        {
          locked._children = [
            {
              bind = {
                _args = ["Ctrl g"];
                _children = [
                  { SwitchToMode._args = ["normal"]; }
                ];
              };
            }
          ];
        }

        {
          pane._children = [
            {
              bind = {
                _args = ["left"];
                _children = [
                  { MoveFocus = "left"; }
                ];
              };
            }{
              bind = {
                _args = ["right"];
                _children = [
                  { MoveFocus = "right"; }
                ];
              };
            }{
              bind = {
                _args = ["up"];
                _children = [
                  { MoveFocus = "up"; }
                ];
              };
            }{
              bind = {
                _args = ["down"];
                _children = [
                  { MoveFocus = "down"; }
                ];
              };
            }{
              bind = {
                _args = ["tab"];
                _children = [
                  {
                    SwitchFocus = {};
                  }
                ];
              };
            }

            {
              bind = {
                _args = ["c"];
                _children = [
                  { SwitchToMode = "renamepane"; PaneNameInput = 0; }
                ];
              };
            }
            {
              bind = {
                _args = ["d"];
                _children = [
                  { SwitchToMode = "locked"; }
                  { NewPane = "down"; }
                ];
              };
            }
            {
              bind = {
                _args = ["e"];
                _children = [
                  { SwitchToMode = "locked"; TogglePaneEmbedOrFloating = {}; }
                ];
              };
            }
            {
              bind = {
                _args = ["f"];
                _children = [
                  { ToggleFocusFullscreen = {}; }
                  { SwitchToMode = "locked"; }
                ];
              };
            }
            {
              bind = {
                _args = ["h"];
                _children = [
                  { MoveFocus = "left"; }
                ];
              };
            }
            {
              bind = {
                _args = ["i"];
                _children = [
                  { SwitchToMode = "locked"; }
                  { TogglePanePinned = {}; }
                ];
              };
            }
            {
              bind = {
                _args = ["j"];
                _children = [
                  { NewPane = "down"; }
                ];
              };
            }
            {
              bind = {
                _args = ["k"];
                _children = [
                  { NewPane = "up"; }
                ];
              };
            }
            {
              bind = {
                _args = ["l"];
                _children = [
                  { SwitchToMode = "locked"; }
                  { NewPane = "right"; }
                ];
              };
            }
            {
              bind = {
                _args = ["n"];
                _children = [
                  { SwitchToMode = "locked"; }
                  { NewPane = {}; }
                ];
              };
            }
            {
              bind = {
                _args = ["p"];
                _children = [
                  { SwitchToMode = "normal"; }
                ];
              };
            }
            {
              bind = {
                _args = ["r"];
                _children = [
                  { SwitchToMode = "locked"; }
                  { NewPane = "right"; }
                ];
              };
            }
            {
              bind = {
                _args = ["s"];
                _children = [
                  { SwitchToMode = "locked"; }
                  { NewPane = "stacked"; }
                ];
              };
            }
            {
              bind = {
                _args = ["w"];
                _children = [
                  { SwitchToMode = "locked"; }
                  { ToggleFloatingPanes = {}; }
                ];
              };
            }
            {
              bind = {
                _args = ["x"];
                _children = [
                  { SwitchToMode = "locked"; }
                  {
                    CloseFocus = {};
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["z"];
                _children = [
                  { SwitchToMode = "locked"; }
                  { TogglePaneFrames = {}; }
                ];
              };
            }
          ];
        }

        {
          tab._children = [
            {
              bind = {
                _args = ["left"];
                _children = [{ GoToPreviousTab = {}; }];
              };
            }
            {
              bind = {
                _args = ["down"];
                _children = [{ GoToNextTab = {}; }];
              };
            }
            {
              bind = {
                _args = ["up"];
                _children = [{ GoToPreviousTab = {}; }];
              };
            }
            {
              bind = {
                _args = ["right"];
                _children = [{ GoToNextTab = {}; }];
              };
            }
            {
              bind = {
                _args = ["h"];
                _children = [{ GoToPreviousTab = {}; }];
              };
            }
            {
              bind = {
                _args = ["j"];
                _children = [{ GoToNextTab = {}; }];
              };
            }
 
            {
              bind = {
                _args = ["k"];
                _children = [{ GoToPreviousTab = {}; }];
              };
            }
            {
              bind = {
                _args = ["l"];
                _children = [{ GoToNextTab = {}; }];
              };
            }

            {
              bind = {
                _args = ["1"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    GoToTab = 1;
                  }
                ];
              };
            }

            {
              bind = {
                _args = ["["];
                _children = [
                  {
                    SwitchToMode = "locked";
                    BreakPaneLeft = {};
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["["];
                _children = [
                  {
                    SwitchToMode = "locked";
                    BreakPaneLeft = {};
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["b"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    BreakPane = {};
                  }
                ];
              };
            }

            {
              bind = {
                _args = ["n"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    NewTab = {};
                  }
                ];
              };
            }

            {
              bind = {
                _args = ["r"];
                _children = [
                  {
                    SwitchToMode = "renametab";
                    TabNameInput = 0;
                  }
                ];
              };
            }

            {
              bind = {
                _args = ["s"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    ToggleActiveSyncTab = {};
                  }
                ];
              };
            }

            {
              bind = {
                _args = ["t"];
                _children = [
                  {
                    SwitchToMode = "normal";
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["x"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    CloseTab = {};
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["tab"];
                _children = [{ ToggleTab = {}; }];
              };
            }
          ];
        }

        {
          resize._children = [
            {
              bind = {
                _args = ["left"];
                _children = [{ Resize = "Increase left"; }];
              };
            }
            {
              bind = {
                _args = ["down"];
                _children = [{ Resize = "Increase down"; }];
              };
            }
            {
              bind = {
                _args = ["up"];
                _children = [{ Resize = "Increase up"; }];
              };
            }
            {
              bind = {
                _args = ["right"];
                _children = [{ Resize = "Increase right"; }];
              };
            }
            {
              bind = {
                _args = ["h"];
                _children = [{ Resize = "Increase left"; }];
              };
            }
            {
              bind = {
                _args = ["j"];
                _children = [{ Resize = "Increase down"; }];
              };
            }
            {
              bind = {
                _args = ["k"];
                _children = [{ Resize = "Increase up"; }];
              };
            }
            {
              bind = {
                _args = ["l"];
                _children = [{ Resize = "Increase right"; }];
              };
            }
            {
              bind = {
                _args = ["H"];
                _children = [{ Resize = "Decrease left"; }];
              };
            }
            {
              bind = {
                _args = ["J"];
                _children = [{ Resize = "Decrease left"; }];
              };
            }
            {
              bind = {
                _args = ["K"];
                _children = [{ Resize = "Decrease left"; }];
              };
            }
            {
              bind = {
                _args = ["L"];
                _children = [{ Resize = "Decrease left"; }];
              };
            }


            {
              bind = {
                _args = ["+"];
                _children = [{ Resize = "Increase"; }];
              };
            }
            {
              bind = {
                _args = ["="];
                _children = [{ Resize = "Increase"; }];
              };
            }
            {
              bind = {
                _args = ["-"];
                _children = [{ Resize = "Decrease"; }];
              };
            }

            {
              bind = {
                _args = ["r"];
                _children = [{ SwitchToMode = "normal"; }];
              };
            }
          ];
        }

        {
          move._children = [
            {
              bind = {
                _args = ["left"];
                _children = [{ MovePane = "left"; }];
              };
            }
            {
              bind = {
                _args = ["down"];
                _children = [{ MovePane = "down"; }];
              };
            }
            {
              bind = {
                _args = ["up"];
                _children = [{ MovePane = "up"; }];
              };
            }
            {
              bind = {
                _args = ["right"];
                _children = [{ MovePane = "right"; }];
              };
            }
            {
              bind = {
                _args = ["h"];
                _children = [{ MovePane = "left"; }];
              };
            }
            {
              bind = {
                _args = ["j"];
                _children = [{ MovePane = "down"; }];
              };
            }
            {
              bind = {
                _args = ["k"];
                _children = [{ MovePane = "up"; }];
              };
            }
            {
              bind = {
                _args = ["l"];
                _children = [{ MovePane = "right"; }];
              };
            }

            {
              bind = {
                _args = ["n"];
                _children = [{ MovePane = {}; }];
              };
            }
            {
              bind = {
                _args = ["tab"];
                _children = [{ MovePane = {}; }];
              };
            }
            {
              bind = {
                _args = ["p"];
                _children = [{ MovePaneBackwards = {}; }];
              };
            }

            {
              bind = {
                _args = ["m"];
                _children = [{ SwitchToMode = "normal"; }];
              };
            }
          ];
        }

        {
          scroll._children = [
            {
              bind = {
                _args = ["Alt left"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    MoveFocusOrTab = "left";
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["Alt down"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    MoveFocus = "down";
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["Alt up"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    MoveFocus = "up";
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["Alt right"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    MoveFocusOrTab = "right";
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["Alt h"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    MoveFocusOrTab = "left";
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["Alt j"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    MoveFocus = "down";
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["Alt k"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    MoveFocus = "up";
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["Alt l"];
                _children = [
                  {
                    SwitchToMode = "locked";
                    MoveFocusOrTab = "right";
                  }
                ];
              };
            }

            {
              bind = {
                _args = ["e"];
                _children = [
                  {
                    EditScrollback = {};
                    SwitchToMode = "locked";
                  }
                ];
              };
            }

            {
              bind = {
                _args = ["f"];
                _children = [
                  {
                    SwitchToMode = "entersearch";
                    SearchInput = 0;
                  }
                ];
              };
            }
            {
              bind = {
                _args = ["s"];
                _children = [
                  {
                    SwitchToMode = "normal";
                  }
                ];
              };
            }
          ];
        }

        {
          search._children = [
            {
              bind = {
                _args = ["c"];
                _children = [{ SearchToggleOption = "CaseSensitivity"; }];
              };
            }
            {
              bind = {
                _args = ["o"];
                _children = [{ SearchToggleOption = "WholeWord"; }];
              };
            }
            {
              bind = {
                _args = ["w"];
                _children = [{ SearchToggleOption = "Wrap"; }];
              };
            }

            {
              bind = {
                _args = ["n"];
                _children = [{ Search = "down"; }];
              };
            }
            {
              bind = {
                _args = ["p"];
                _children = [{ Search = "up"; }];
              };
            }
          ];
        }

        {
          session._children = [

            {
              bind = {
                _args = ["p"];
                _children = [{
                  SwitchToMode = "locked";
                  LaunchOrFocusPlugin = {
                    _args = ["plugin-manager"];
                    _children = [{
                      floating = true;
                      move_to_focused_tab = true;
                    }];
                  };
                }];
              };
            }
            {
              bind = {
                _args = ["s"];
                _children = [{
                  SwitchToMode = "locked";
                  LaunchOrFocusPlugin = {
                    _args = ["zellij:share"];
                    _children = [{
                      floating = true;
                      move_to_focused_tab = true;
                    }];
                  };
                }];
              };
            }
            {
              bind = {
                _args = ["w"];
                _children = [{
                  SwitchToMode = "locked";
                  LaunchOrFocusPlugin = {
                    _args = ["session-manager"];
                    _children = [{
                      floating = true;
                      move_to_focused_tab = true;
                    }];
                  };
                }];
              };
            }
            {
              bind = {
                _args = ["a"];
                _children = [{
                  SwitchToMode = "locked";
                  LaunchOrFocusPlugin = {
                    _args = ["zellij:about"];
                    _children = [{
                      floating = true;
                      move_to_focused_tab = true;
                    }];
                  };
                }];
              };
            }
            {
              bind = {
                _args = ["c"];
                _children = [{
                  SwitchToMode = "locked";
                  LaunchOrFocusPlugin = {
                    _args = ["configuration"];
                    _children = [{
                      floating = true;
                      move_to_focused_tab = true;
                    }];
                  };
                }];
              };
            }

            {
              bind = {
                _args = ["d"];
                _children = [{ Detach = {}; }];
              };
            }
            {
              bind = {
                _args = ["o"];
                _children = [{ SwitchToMode = "normal"; }];
              };
            }
          ];
        }

        {
          shared_among = {
            _args = ["normal" "locked"];
            _children = [

              {
                bind = {
                  _args = ["Alt left"];
                  _children = [
                    { MoveFocusOrTab = "left"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt down"];
                  _children = [
                    { MoveFocus = "down"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt up"];
                  _children = [
                    { MoveFocus = "up"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt right"];
                  _children = [
                    { MoveFocusOrTab = "right"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt h"];
                  _children = [
                    { MoveFocusOrTab = "left"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt j"];
                  _children = [
                    { MoveFocus = "down"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt k"];
                  _children = [
                    { MoveFocus = "up"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt l"];
                  _children = [
                    { MoveFocusOrTab = "right"; }
                  ];
                };
              }

              {
                bind = {
                  _args = ["Alt +"];
                  _children = [
                    { Resize = "Increase"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt ="];
                  _children = [
                    { Resize = "Increase"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt -"];
                  _children = [
                    { Resize = "Decrease"; }
                  ];
                };
              }

              {
                bind = {
                  _args = ["Alt ["];
                  _children = [
                    { PreviousSwapLayout = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt ]"];
                  _children = [
                    { NextSwapLayout = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt f"];
                  _children = [
                    { ToggleFloatingPanes = {}; }
                  ];
                };
              }

              {
                bind = {
                  _args = ["Alt i"];
                  _children = [
                    { MoveTab = "left"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt o"];
                  _children = [
                    { MoveTab = "right"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt n"];
                  _children = [
                    { NewPane = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt p"];
                  _children = [
                    { TogglePaneInGroup = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Alt Shift p"];
                  _children = [
                    { ToggleGroupMarking = {}; }
                  ];
                };
              }
            ];
          };
        }

        {
          shared_among = {
            _args = ["normal" "resize" "tab" "scroll" "prompt" "tmux"];
            _children = [
              {
                bind = {
                  _args = ["p"];
                  _children = [
                        { SwitchToMode = "pane"; }
                  ];
                };
              }
            ];
          };
        }

        {
          shared_among = {
            _args = ["normal" "resize" "search" "move" "prompt" "tmux"];
            _children = [
              {
                bind = {
                  _args = ["s"];
                  _children = [
                        { SwitchToMode = "scroll"; }
                  ];
                };
              }
            ];
          };
        }

        {
          shared_among = {
            _args = ["scroll" "search"];
            _children = [

              {
                bind = {
                  _args = ["PageDown"];
                  _children = [
                        { PageScrollDown = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["PageUp"];
                  _children = [
                        { PageScrollUp = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["left"];
                  _children = [
                        { PageScrollUp = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["down"];
                  _children = [
                        { ScrollDown = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["up"];
                  _children = [
                        { ScrollUp = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["right"];
                  _children = [
                        { PageScrollDown = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Ctrl b"];
                  _children = [
                        { PageScrollUp = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Ctrl c"];
                  _children = [
                        { ScrollToBottom = {}; SwitchToMode = "locked"; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["d"];
                  _children = [
                        { HalfPageScrollDown = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["Ctrl f"];
                  _children = [
                        { PageScrollDown = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["h"];
                  _children = [
                        { PageScrollUp = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["j"];
                  _children = [
                        { ScrollDown = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["k"];
                  _children = [
                        { ScrollUp = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["l"];
                  _children = [
                        { PageScrollDown = {}; }
                  ];
                };
              }
              {
                bind = {
                  _args = ["u"];
                  _children = [
                        { HalfPageScrollUp = {}; }
                  ];
                };
              }
            ];
          };
        }

        {
            shared_except = {
              _args = ["locked" "renametab" "renamepane"];
              _children = [
                {
                  bind = {
                    _args = ["Ctrl g"];
                    _children = [
                      { SwitchToMode = "locked"; }
                    ];
                  };
                }{
                  bind = {
                    _args = ["Ctrl q"];
                    _children = [
                      { Quit = {}; }
                    ];
                  };
                }
              ];
            };
        }
        {
            shared_except = {
              _args = ["locked" "entersearch"];
              _children = [
                {
                  bind = {
                    _args = ["enter"];
                    _children = [
                      { SwitchToMode = "locked"; }
                    ];
                  };
                }
              ];
            };
        }
        {
            shared_except = {
              _args = ["locked" "entersearch" "renametab" "renamepane"];
              _children = [
                {
                  bind = {
                    _args = ["esc"];
                    _children = [
                      { SwitchToMode = "locked"; }
                    ];
                  };
                }
              ];
            };
        }
        {
            shared_except = {
              _args = ["locked" "entersearch" "renametab" "renamepane" "move"];
              _children = [
                {
                  bind = {
                    _args = ["m"];
                    _children = [
                      { SwitchToMode = "move"; }
                    ];
                  };
                }
              ];
            };
        }
        {
            shared_except = {
              _args = ["locked" "entersearch" "search" "renametab" "renamepane" "session"];
              _children = [
                {
                  bind = {
                    _args = ["o"];
                    _children = [
                      { SwitchToMode = "session"; }
                    ];
                  };
                }
              ];
            };
        }
        {
            shared_except = {
              _args = ["locked" "tab" "entersearch" "renametab" "renamepane"];
              _children = [
                {
                  bind = {
                    _args = ["t"];
                    _children = [
                      { SwitchToMode = "tab"; }
                    ];
                  };
                }
              ];
            };
        }
        {
            shared_except = {
              _args = ["locked" "resize" "pane" "tab" "entersearch" "renametab" "renamepane"];
              _children = [
                {
                  bind = {
                    _args = ["r"];
                    _children = [
                      { SwitchToMode = "resize"; }
                    ];
                  };
                }
              ];
            };
        }

        {
            entersearch._children = [

              {
                  bind = {
                    _args = ["Ctrl c"];
                    _children = [{ SwitchToMode = "scroll"; }];
                  };
              }
              {
                  bind = {
                    _args = ["esc"];
                    _children = [{ SwitchToMode = "scroll"; }];
                  };
              }
              {
                  bind = {
                    _args = ["enter"];
                    _children = [{ SwitchToMode = "search"; }];
                  };
              }
            ];
        }

        {
            renametab._children = [{
                bind = {
                  _args = ["esc"];
                  _children = [{ UndoRenameTab = {}; SwitchToMode = "tab"; }];
                };
            }];
        }
        {
            shared_among = {
                _args = ["renametab" "renamepane"];
                _children = [{
                  bind = {
                    _args = ["esc"];
                    _children = [{ UndoRenameTab = {}; SwitchToMode = "tab"; }];
                  };
                }];
            };
        }
        {
            renamepane._children = [{
                bind = {
                  _args = ["esc"];
                  _children = [{ UndoRenamePane = {}; SwitchToMode = "pane"; }];
                };
            }];
        }
      ];
    };
  };
}
