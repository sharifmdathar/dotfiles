{
  pkgs,
  config,
  inputs,
  unstablePkgs,
  helium-browser,
  ...
}:

let
  customVolumectl = pkgs.writeShellApplication {
    name = "volumectl";
    runtimeInputs = [
      pkgs.wireplumber
      pkgs.avizo
      pkgs.gnugrep
      pkgs.bc
      pkgs.coreutils
      pkgs.gawk
    ];
    text = builtins.readFile ./volumectl;
  };
  avizoWithCustomVolumectl = pkgs.symlinkJoin {
    name = "avizo-with-custom-volumectl";
    paths = [
      pkgs.avizo
      customVolumectl
    ];
    postBuild = ''
      rm -f $out/bin/volumectl
      ln -s ${customVolumectl}/bin/volumectl $out/bin/volumectl
    '';
  };
in
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./mpv.nix
  ];

  stylix = {
    enable = true;
    image = ./wallpaper.jpg;
    polarity = "dark";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  home.packages = with pkgs; [
    # User applications
    _64gram
    helium-browser
    imv
    libreoffice-qt6-fresh
    motrix
    protonvpn-gui

    # Development tools
    unstablePkgs.android-studio
    unstablePkgs.vscode
    unstablePkgs.code-cursor
    unstablePkgs.unityhub
    arduino-ide
    espeak
    flac
    gcc
    gnumake
    libpulseaudio
    linuxHeaders
    neovim
    nodejs_24
    portaudio
    pnpm
    podman
    podman-compose
    python313
    uv

    # Terminal utilities
    bat
    bluetuith
    bottom
    broot
    dust
    eza
    fastfetch
    fd
    fzf
    gh
    htop
    hyperfine
    nixfmt-rfc-style
    procs
    playerctl
    ranger
    ripgrep
    swaynotificationcenter
    avizoWithCustomVolumectl
    tldr
    unstablePkgs.gemini-cli
    unstablePkgs.hyprmon
    wget
    xplr
    zoxide

    # File management & archives
    p7zip
    unzip
    unar
    xfce.thunar

    # Desktop utilities
    pavucontrol
    swww
    wofi
    libnotify

    # Fonts
    pkgs.nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

  xdg.configFile."containers/policy.json".text = ''
    {
      "default": [
        {
          "type": "insecureAcceptAnything"
        }
      ],
      "transports": {
        "docker": {
          "docker.io": [
            {
              "type": "insecureAcceptAnything"
            }
          ]
        }
      }
    }
  '';

  xdg.configFile."containers/registries.conf".text = ''
    unqualified-search-registries = ["docker.io", "quay.io"]

    [[registry]]
    location = "docker.io"
    insecure = false
    blocked = false

    [[registry]]
    location = "quay.io"
    insecure = false
    blocked = false
  '';

  systemd.user.services.caffeine = {
    Unit = {
      Description = "Keep the session awake (inhibit idle/sleep)";
    };
    Service = {
      Type = "simple";
      ExecStart = ''${pkgs.systemd}/bin/systemd-inhibit --what=idle:sleep --mode=block --why=Caffeine ${pkgs.coreutils}/bin/sleep infinity'';
    };
    Install = {
      WantedBy = [ ];
    };
  };

  home.sessionVariables = {
    PATH = "${pkgs.flac}/bin:$PATH";
  };

  programs = {
    home-manager.enable = true;
    alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window.padding = {
          x = 10;
          y = 10;
        };
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "sharifmdathar";
        user.email = "116189751+sharifmdathar@users.noreply.github.com";

        core.editor = "nvim";
        core.pager = "less -FRSX";
        core.ignorecase = false;
        core.excludesfile = "~/.gitignore_global";

        color.ui = "auto";
        diff.algorithm = "histogram";
        diff.colorMoved = "default";
        diff.mnemonicPrefix = true;
        diff.renames = true;
        log.date = "iso";
        status.showUntrackedFiles = "all";

        pull.rebase = true;
        pull.ff = "only";
        rebase.autoStash = true;
        rebase.autoSquash = true;
        merge.conflictstyle = "zdiff3";

        branch.sort = "-committerdate";

        fetch.prune = true;
        fetch.pruneTags = true;
        push.default = "simple";
        push.autoSetupRemote = true;
        push.followTags = true;

        gc.auto = 256;
        pack.useBitmaps = true;

        grep.lineNumber = true;
        grep.patternType = "perl";

        rerere.enabled = true;
        rerere.autoupdate = true;

        help.autocorrect = "prompt";

        init.defaultBranch = "main";

        # Aliases
        alias.lg = "log --oneline --decorate --graph --all";
        alias.last = "log -1 HEAD";
        alias.unc = "reset --soft HEAD~1";
      };
    };

    git-credential-oauth.enable = true;

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "sharifmdathar";
          email = "116189751+sharifmdathar@users.noreply.github.com";
        };
        ui = {
          editor = "nvim";
          color = "auto";
        };
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        nix_shell = {
          disabled = false;
          symbol = "❄";
          format = "[$symbol$state]($style) ";
        };
      };
    };

    wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "pidof hyprlock || hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "s";
        }
        {
          label = "suspend-then-hibernate";
          action = "systemctl suspend-then-hibernate";
          text = "Suspend → Hibernate";
          keybind = "h";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "b";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "u";
        }
      ];
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        n = "nvim";
        ls = "eza";
        ll = "eza -l";
        la = "eza -la";
        lt = "eza --tree";
        cat = "bat";
        du = "dust";
        find = "fd";
        grep = "rg";
        ps = "procs";
        man = "tldr";
        tree = "broot";
        top = "btm";
        nnn = "xplr";
        cd = "z";

        gst = "git status";
        gl = "git log --oneline --graph --decorate";
        ga = "git add";
        gaa = "git add .";
        gc = "git commit";
        gcsm = "git commit -sm";
        gca = "git commit --amend";
        gco = "git checkout";
        gcb = "git checkout -b";
        gpl = "git pull";
        gp = "git push";
        gpu = "git push -u origin HEAD";

        hms = "nix run github:nix-community/home-manager/release-25.11 -- switch --flake $HOME/dotfiles/nix#blazen";
      };
      initContent = ''
        bindkey "^[[1;5D" backward-word  # Ctrl + Left
        bindkey "^[[1;5C" forward-word   # Ctrl + Right
        bindkey "^H" backward-kill-word   # Ctrl + Backspace
        bindkey "^[[3;5~" kill-word       # Ctrl + Delete
        export EDITOR="nvim"
        export VISUAL="nvim"
        export SUDO_EDITOR="nvim"
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      '';
    };
  };

  gtk.enable = true;

  xdg.desktopEntries.helium-browser = {
    name = "Helium Browser";
    genericName = "Web Browser";
    exec = "helium-browser %U";
    icon = "helium-browser";
    terminal = false;
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/xml"
      "application/vnd.mozilla.xul+xml"
      "application/rss+xml"
      "application/rdf+xml"
      "image/svg+xml"
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "helium-browser.desktop";
    "x-scheme-handler/http" = "helium-browser.desktop";
    "x-scheme-handler/https" = "helium-browser.desktop";
    "x-scheme-handler/about" = "helium-browser.desktop";
    "x-scheme-handler/unknown" = "helium-browser.desktop";
  };

  stylix.targets.mako.enable = false;

  home.activation.reapplyStylixWallpaper = ''
    # Set wallpaper using stylix config value directly
    if [ -f "${config.stylix.image}" ] && command -v swww >/dev/null 2>&1; then
      # Make sure swww daemon is running
      if ! pgrep -x swww-daemon >/dev/null; then
        swww-daemon &
        sleep 1
      fi
      swww img "${config.stylix.image}" --transition-type wipe --transition-duration 1 || true
    fi
  '';

  home.homeDirectory = "/home/blazen";
  home.stateVersion = "25.11";
  home.username = "blazen";
}
