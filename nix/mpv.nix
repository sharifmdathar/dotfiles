{ config, pkgs, lib, ... }:

{
  programs.mpv = {
    enable = true;
    bindings = {
      "+" = "add speed 0.5";
      "-" = "add speed -0.5";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      KP_ADD = "add speed 0.5";
      KP_SUBTRACT = "add speed -0.5";
    };
    config = {
      script-opts="ytdl_hook-ytdl_path=yt-dlp";
      save-position-on-quit=true;
      force-seekable=true;
      vlang="en,eng";
      vo="gpu-next";
      volume-max=100;
      volume=100;
      keep-open=true;
      hls-bitrate="max";
      prefetch-playlist=true;
      snap-window=true;
      gpu-api="vulkan";
      profile="fast";
      hwdec="nvdec";
      autocreate-playlist="same";
      demuxer-mkv-subtitle-preroll=true;
      blend-subtitles=true;
      target-colorspace-hint=true;
      target-contrast="auto";
      deband=true;
      deband-iterations=4;
      deband-threshold=48;
      deband-range=24;
      deband-grain=16;
      scale-antiring=0.8;
      dscale-antiring=0.8;
      cscale-antiring=0.8;
      interpolation=true;
      video-sync="display-resample";
      cursor-autohide-fs-only=true;
      msg-color=true;
      msg-module=true;
      term-osd-bar=true;
      osd-bar-align-y=-1;
      osd-bar-h=2;
      osd-bar-w=99;
      # osd-border-color=lib.mkForce "#DD322640";  # Override stylix
      osd-border-size=2;
      # osd-color="#FFFFFFFF";
      osd-duration=1000;
      osd-font-size=32;
      osd-status-msg="\${time-pos} / \${duration}\${?percent-pos:  (\${percent-pos}%)}\${?frame-drop-count:\${!frame-drop-count==0:  Dropped: \${frame-drop-count}}}\\n\${?chapter:Chapter: \${chapter}}";
      osd-bar=false;
      border=false;
      alang="jp,jap,en,eng";
      embeddedfonts=true;
      slang="en,eng";
      sub-auto="all";
      sub-file-paths-append = [
        "Subs/\${filename/no-ext}"
        "Subs/\${filename}"
        "subs/\${filename/no-ext}"
        "subs/\${filename}"
        "ass"
        "Ass"
        "ASS"
        "srt"
        "Srt"
        "SRT"
        "sub"
        "Sub"
        "subs"
        "Subs"
        "subtitles"
        "Subtitles"
      ];
      sub-fix-timing=false;
      sub-font-size="45";
      # sub-font="Arial";
      sub-scale-with-window=true;
      glsl-shaders-clr = true;

      linear-downscaling = false;
      glsl-shaders-append = [
        # SSimDownscaler: Perceptually based downscaler.
        "${config.home.homeDirectory}/.config/mpv/shaders/SSimDownscaler.glsl" # https://gist.github.com/igv/36508af3ffc84410fe39761d6969be10

        # SSimSuperRes: Make corrections to the image upscaled by mpv built-in scaler
        # (removes ringing artifacts and restores original sharpness).
        "${config.home.homeDirectory}/.config/mpv/shaders/SSimSuperRes.glsl" # https://gist.github.com/igv/2364ffa6e81540f29cb7ab4c9bc05b6b

        # KrigBilateral: Chroma scaler that uses luma information for high quality upscaling.
        "${config.home.homeDirectory}/.config/mpv/shaders/KrigBilateral.glsl" # https://gist.github.com/igv/a015fc885d5c22e6891820ad89555637
                
        # Adaptive-directional sharpening algorithm shaders for NVidia GPUs.
        # https://gist.github.com/agyild/7e8951915b2bf24526a9343d951db214
        "${config.home.homeDirectory}/.config/mpv/shaders/NVScaler.glsl"
        "${config.home.homeDirectory}/.config/mpv/shaders/NVSharpen.glsl"
      ];
    };
    profiles = {
      "protocol.http" = {
        cache = true;
        cache-secs = 600;
      };
      "protocol.https" = {
        cache = true;
        cache-secs = 600;
      };
      "upscale-lowres-using-GPU-shaders" = {
        profile-desc = "Upscales low resolution videos using GPU upscaling shaders.";
        profile-cond = "height < 1080";
      };
      "extension.gif" = {
        profile-desc = "GIF";
        cache = false;
        pause = false;
        loop-file = true;
      };
      "extension.png" = {
        profile-desc = "PNG";
        video-aspect-override = false;
        loop-file = true;
      };
      "extension.jpg" = {
        profile-desc = "JPG";
        video-aspect-override = false;
        loop-file = true;
      };
      "extension.jpeg" = {
        profile-desc = "JPEG";
        profile = "extension.jpg";
        loop-file = true;
      };
    };
    scripts = [
      pkgs.mpvScripts.uosc
      pkgs.mpvScripts.thumbfast
    ];
  };
}