{ pkgs, ... }:

let
  pname = "gamesentenceminer";
  version = "2026.10.1";

  src = pkgs.fetchurl {
    url = "https://github.com/bpwhelan/GameSentenceMiner/releases/download/v${version}/GameSentenceMiner-${version}.AppImage";
    hash = "sha256-/p6bHqE43oWDtjYTsgJyYl27O9L4qP+2REdP7bC7/r0=";
  };
  
  # Desktop & icon
  desktopName = "com.beangate.gamesentenceminer";
  
  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };  
in

 pkgs.appimageTools.wrapType2 rec {
    inherit pname version src desktopName;

    extraPkgs = pkgs: [
      pkgs.libGL
      pkgs.glib
      pkgs.zstd
    ];

  extraInstallCommands = ''
    install -m 444 -D \
      "${appimageContents}/${desktopName}.desktop" \
      "$out/share/applications/${desktopName}.desktop"

    install -m 444 -D \
      "${appimageContents}/${desktopName}.png" \
      "$out/share/pixmaps/${desktopName}.png"

    mv $out/share/applications/${desktopName}.desktop $out/share/applications/${pname}.desktop

    substituteInPlace "$out/share/applications/${pname}.desktop" \
      --replace-fail 'Exec=AppRun' "Exec=$out/bin/${pname}"
  '';

  meta = {
    changelog = "https://github.com/bpwhelan/GameSentenceMiner/releases/tag/v${version}";
    homepage = "https://github.com/bpwhelan/GameSentenceMiner";
    description = "A tool for mining sentences from games.";
    license = pkgs.lib.licenses.gpl3Plus;
    sourceProvenance = with pkgs.lib.sourceTypes; [ binaryNativeCode ];
  };    
 }





