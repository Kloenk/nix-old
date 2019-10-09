{ ... }:

{
  networking.nat = {
    enable = true;
    externalInterface = "eth0";
    internalIPs = [ "192.168.42.0/24" "192.168.30.0/24" ];
    internalinterfaces = [ "wg0" ];
  };
}
