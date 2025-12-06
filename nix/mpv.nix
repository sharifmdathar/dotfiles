{ config, pkgs, lib, ... }:

let
  ssimDownscaler = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/igv/36508af3ffc84410fe39761d6969be10/raw/SSimDownscaler.glsl";
    sha256 = "017q51w0gi58y9myyz70gd6w1c480mhxhbnqp5c71lb2l484fvzl";
  };
  ssimSuperRes = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/igv/2364ffa6e81540f29cb7ab4c9bc05b6b/raw/SSimSuperRes.glsl";
    sha256 = "03s62mwcj90pnpp7dmwa4lbh404805g3f6s1a1908q0chhap3cm8";
  };
  krigBilateral = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/igv/a015fc885d5c22e6891820ad89555637/raw/KrigBilateral.glsl";
    sha256 = "1c0cjjysi9gmqy7nwj5ywc39hk6ivxfrhw8drrpn90vvnymrhiwa";
  };
  nvScaler = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/agyild/7e8951915b2bf24526a9343d951db214/raw/NVScaler.glsl";
    sha256 = "0g5psv5k1sdwjlppdajjpnz5prjpqair8xyrvbj75lh807n7iixs";
  };
  nvSharpen = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/agyild/7e8951915b2bf24526a9343d951db214/raw/NVSharpen.glsl";
    sha256 = "04ls9zsqj601x0r6nklj173c1sl3wwcs0ikyyz0q90m1klmaql9x";
  };
in

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
        "${ssimDownscaler}"
        "${ssimSuperRes}"
        "${krigBilateral}"
        "${nvScaler}"
        "${nvSharpen}"
      ];
    };
    profiles = {
      "protocol.http" = {
        cache = true;
        cache-secs = 1800;
      };
      "protocol.https" = {
        cache = true;
        cache-secs = 1800;
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