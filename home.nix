{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "chase";
  home.homeDirectory = "/home/chase";
  home.shell.enableZshIntegration = true;
  home.shell.enableBashIntegration = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;
  fonts.fontconfig.antialiasing = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nixfmt
    pkgs.killport
    # # You can also create simple shell scripts directly inside your
    # # configuration:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".config/pitchfork/config.toml".text = ''
      [settings.general]
      mise = true
      mise_bin = "~/.nix-profile/bin/mise"

      [settings.web]
      auto_start = true
    '';

    ".config/fresh/config.json".text = ''
      {
          "file_explorer": {
            "show_hidden": true,
            "show_gitignored": true
          },
          "theme": "high-contrast",
          "editor": {
            "tab_size": 2
          },
          "file_browser": {
            "show_hidden": true
          }
        }
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'.
  home.sessionVariables = {
    EDITOR = "fresh";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  services.home-manager.autoUpgrade = {
    enable = true;
    useFlake = true;
    frequency = "weekly";
  };

  targets.genericLinux = {
    enable = true;
    gpu.enable = true;
  };

  xdg.enable = true;
  # https://nix-community.github.io/home-manager/options.xhtml
  home.shell.enableShellIntegration = true;
  programs.direnv = {
    enable = true;
    config = {
      strict_env = true;
    };
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.chromium = {
    enable = true;
  };
  programs.jq = {
    enable = true;
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
  };
  programs.ripgrep = {
    enable = true;
  };
  programs.command-not-found = {
    enable = true;
  };
  programs.fd = {
    enable = true;
  };
  programs.fzf = {
    enable = true;
  };
  programs.man = {
    enable = true;
  };
  programs.gcc.enable = true;
  # https://searchix.ovh/options/home-manager/search

  programs.fresh-editor.enable = true;
  programs.zsh = {
    enable = true;
    initContent = ''
      function hms() {
        local config_dir="$HOME/.config/home-manager"
        if [ -d "$config_dir" ]; then
          pushd "$config_dir" > /dev/null
          
          nixfmt flake.nix home.nix
          
          # Stage changes so the Flake can see them
          git add .
          
          # Run the switch using nh
          if nh home switch; then
            # If switch was successful, commit and push if there are changes
            if ! git diff --cached --quiet; then
              git commit -m "chore: update configuration $(date +%F)"
              git push
            else
              echo "No changes to commit."
            fi
          else
            echo "Switch failed, skipping commit/push."
          fi
          
          popd > /dev/null
        else
          echo "Error: $config_dir not found."
          return 1
        fi
      }

      eval "$(pitchfork activate zsh)" | true
    '';
    shellAliases = {
      hme = "home-manager edit";
      ".." = "cd ..";
    };
    dotDir = "${config.xdg.configHome}/zsh";
    oh-my-zsh = {
      enable = true;
      plugins = [
        "1password"
        "command-not-found"
        "bun"
        "direnv"
        "docker"
        "docker-compose"
        "extract"
        "fancy-ctrl-z"
        "fzf"
        "gcloud"
        "gh"
        "git"
        "git-prompt"
        "mise"
        "npm"
        "node"
        "tailscale"
        "zsh-interactive-cd"
        "shrink-path"
        "starship"
        "ubuntu"
        "vscode"

      ];
    };
    autocd = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
        "match_prev_cmd"
      ];
    };
    enableVteIntegration = true;
    historySubstringSearch = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };

    setOptions = [
      "AUTO_LIST"
      "AUTO_PARAM_SLASH"
      "AUTO_PUSHD"
      "ALWAYS_TO_END"
      "CORRECT"
      "HIST_FCNTL_LOCK"
      "HIST_VERIFY"
      "INTERACTIVE_COMMENTS"
      "MENU_COMPLETE"
      "PUSHD_IGNORE_DUPS"
      "PUSHD_TO_HOME"
      "PUSHD_SILENT"
      "NOTIFY"
      "PROMPT_SUBST"
      "MULTIOS"
      "NOFLOWCONTROL"
      "NO_CORRECT_ALL"
      "NO_HIST_BEEP"
      "NO_NOMATCH"
    ];
    # This should also show intelligent formatting for history options
    history = {
      size = 50000;
      save = 50000;
      # These will create many disabled options
      append = false;
      ignoreDups = false;
      ignoreAllDups = true;
      saveNoDups = true;
      findNoDups = false;
      ignoreSpace = false;
      expireDuplicatesFirst = false;
      extended = true;
      share = true;
    };
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs = {
      enable = true;
    };
    settings = {
      user = {
        email = "chaseholdren@users.noreply.github.com";
        name = "Chase Holdren";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.gh.enable = true;

  programs.gemini-cli.enable = true;
  programs.gemini-cli.settings = {
    security = {
      auth = {
        selectedType = "oauth-personal";
      };
      general = {
        defaultApprovalMode = "auto_edit";
        plan = {
          directory = "./plans";
        };
      };
      ui = {
        inlineThinkingMode = "full";
        hideBanner = true;
      };
      model = {
        name = "gemini-3.1-pro-preview";
      };
      context = {
        fileFiltering = {
          respectGitIgnore = false;
        };
      };
      advanced = {
        autoConfigureMemory = true;
      };
      ide = {
        enabled = true;
      };
      experimental = {
        modelSteering = true;
        directWebFetch = true;
        topicUpdateNarration = true;
        memoryManager = true;
      };
    };

  };
}
