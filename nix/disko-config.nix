{ lib, ... }:

{
  disko.devices = {
    nodev = {
      "/boot" = {
        fsType = "vfat";
        device = "/dev/disk/by-uuid/B4AA-5210";
        mountOptions = [ "fmask=0077" "dmask=0077" ];
      };
      "/" = {
        fsType = "btrfs";
        device = "/dev/disk/by-uuid/13e37ccc-6d0f-4562-987f-4cd2ba21364a";
        mountOptions = [ "compress=zstd" "noatime" "subvol=@" ];
      };
      "/home" = {
        fsType = "btrfs";
        device = "/dev/disk/by-uuid/13e37ccc-6d0f-4562-987f-4cd2ba21364a";
        mountOptions = [ "compress=zstd" "noatime" "subvol=@home" ];
      };
      "/nix" = {
        fsType = "btrfs";
        device = "/dev/disk/by-uuid/13e37ccc-6d0f-4562-987f-4cd2ba21364a";
        mountOptions = [ "compress=zstd" "noatime" "subvol=@nix" ];
      };
      "/var/log" = {
        fsType = "btrfs";
        device = "/dev/disk/by-uuid/13e37ccc-6d0f-4562-987f-4cd2ba21364a";
        mountOptions = [ "compress=zstd" "noatime" "subvol=@var-log" ];
      };
      "/.snapshots" = {
        fsType = "btrfs";
        device = "/dev/disk/by-uuid/13e37ccc-6d0f-4562-987f-4cd2ba21364a";
        mountOptions = [ "noatime" "subvol=@snapshots" ];
      };
    };
  };
}

