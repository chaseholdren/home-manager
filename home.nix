{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "c6-dev";
  home.homeDirectory = "/home/c6-dev";

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

    # # You can also set the file content immediately.
    ".config/turborepo/telemetry.json".text = ''
      { "telemetry_enabled": false }
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
  targets.genericLinux.enable = true;
  xdg.enable = true;
  # https://nix-community.github.io/home-manager/options.xhtml
  home.shell.enableShellIntegration = true;

  programs.chromium = {
    enable = true;
  };
  programs.docker-cli = {
    enable = true;
    # settings = {};
    # configDir = 
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
  # https://searchix.ovh/options/home-manager/search

  programs.fresh-editor.enable = true;
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    oh-my-zsh.enable = true;
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
      append = true;
      ignoreDups = false;
      ignoreAllDups = true;
      saveNoDups = true;
      findNoDups = false;
      ignoreSpace = false;
      expireDuplicatesFirst = false;
      extended = true;
      share = false;
    };
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

    };
  };

  programs.gh.enable = true;

  programs.gemini-cli.enable = true;
  programs.gemini-cli.settings = {
  security = {
    auth = {
      selectedType = "oauth-personal";
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
    experimental = {
      modelSteering = true;
      directWebFetch = true;
      topicUpdateNarration = true;
    };
  };
};
}
