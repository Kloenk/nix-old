{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, jdk, jre, libpulseaudio, libXxf86vm
}:

let
  desktopItem = makeDesktopItem {
    name = "FeedTheBeast";
    exec = "ftb";
    comment = "A sandbox-building game with a beast";
    desktopName = "Feed the Beast";
    genericName = "ftb";
    categories = "Game;";
  };

  libPath = stdenv.lib.makeLibraryPath [
    libpulseaudio
    libXxf86vm # Needed only for versions <1.13
  ];

in stdenv.mkDerivation {
  name = "ftb-0.0.1";

  src = fetchurl {
    url = "http://ftb.forgecdn.net/FTB2/launcher/FTB_Launcher.jar";
    sha256 = "f2ec575e3ffd92bac87caf8b306fc22d4ba78b19bf9577a2d915e9dedab2c030";
  };

  nativeBuildInputs = [ makeWrapper ];

  #unpackPhase = "${jdk}/bin/jar xf $src favicon.png";
  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin $out/share/ftb

    makeWrapper ${jre}/bin/java $out/bin/ftb \
      --add-flags "-jar $out/share/ftb/FTB_Launcher.jar" \
      --suffix LD_LIBRARY_PATH : ${libPath}

    cp -r ${desktopItem}/share/applications $out/share
    cp $src $out/share/ftb/FTB_Launcher.jar
  '';

  meta = with stdenv.lib; {
    description = "ftb";
    homepage = https://minecraft.net;
    maintainers = with maintainers; [ cpages ryantm infinisil ];
    license = licenses.unfreeRedistributable;
  };
}
