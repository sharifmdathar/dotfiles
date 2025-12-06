{ lib, ... }:

{
  disko.devices = {
    nodev = {
      "/boot" = {
        fsType = "vfat";
        device = "/dev/disk/by-uuid/B4AA-5210";
        mountOptions = [ "fmask=0077" "dmask=0077" ];
      };
    };
    
    disk = {
      nixos = {
        device = "/dev/nvme0n1p4";
        type = "disk";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "@" = {
              mountpoint = "/";
              mountOptions = [ "compress=zstd" "noatime" "subvol=@" ];
            };
            "@home" = {
              mountpoint = "/home";
              mountOptions = [ "compress=zstd" "noatime" "subvol=@home" ];
            };
            "@nix" = {
              mountpoint = "/nix";
              mountOptions = [ "compress=zstd" "noatime" "subvol=@nix" ];
            };
            "@var-log" = {
              mountpoint = "/var/log";
              mountOptions = [ "compress=zstd" "noatime" "subvol=@var-log" ];
            };
            "@snapshots" = {
              mountpoint = "/.snapshots";
              mountOptions = [ "noatime" "subvol=@snapshots" ];
            };
          };
        };
      };
    };
  };
}

