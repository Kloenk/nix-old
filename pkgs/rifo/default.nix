{ stdenv, fzf, jq, pass, termite, fetchgit, xdotool, oathToolkit }:

stdenv.mkDerivation rec {
  name = "rifo";
  version = "0.2.1_r1";

  src = fetchgit {
    "url" = "https://git.kloenk.de/finn/Rifo";
    "rev" = "79e24d4fd164a7b2f9fa7ced8173613fbd718e85";
    "fetchSubmodules" = false;
    sha256 = "0czgssv5m57b995xv2558rqb7ym5cc2rvx57z9ag0a91a57vv5f6";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -Dm0755 rifopass.sh $out/bin/rifopass
    install -Dm0755 rifo.sh $out/bin/rifo
    install -Dm0755 passlistgen.sh $out/bin/passlistgen.sh
    install -Dm0755 rifo-init.sh $out/bin/rifo-init.sh
  '';
}