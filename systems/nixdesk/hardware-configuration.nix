{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.kernelParams = [
    "video=DP-1:1920x1080@144"
    "video=HDMI-A-1:1920x1080@60"
  ];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5598714a-876d-43d8-a753-9e2a0d2b690d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DA27-CF51";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/run/media/jack/T7" = {
    device = "/dev/disk/by-uuid/A07D-29EF";
    fsType = "exfat";
    options = ["fmask=0077" "dmask=0077" "uid=1000" "gid=100"];
    noCheck = true; # fsck takes very long for this drive and systemd waits
  };

  fileSystems."/run/media/jack/ArchDisk" = {
    device = "/dev/disk/by-uuid/b2c62987-cc15-42a9-a8b7-6e3a421f7ea6";
    fsType = "ext4";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp14s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp15s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
