{
  pkgs ? import <nixpkgs> { },
  lib,
  py-vers ? pkgs.python313Packages,
  fetchFromGitHub,
}:

let
  # Python version
  py-vers = pkgs.python313Packages;
in

py-vers.buildPythonApplication (finalAttrs: rec {
  pname = "gamesentenceminer";
  version = "2026.10.0";
  pyproject = true;

  # GitHub
  src = fetchFromGitHub {
    owner = "bpwhelan";
    repo = "GameSentenceMiner";
    tag = "v${version}";
    hash = "sha256-D0rS5asVA/bRJh/x/LLVC1o1cHqI1W95RKf/QaRukq0=";
  };


  
  # Rust
  cargoRoot = "native/gsm-native";

  cargoDeps = pkgs.rustPlatform.importCargoLock {
    lockFile = "${src}/${cargoRoot}/Cargo.lock";
  };

 

  # NodeJS (Frontend)
#  npmDeps = pkgs.fetchNpmDeps {  
#    inherit (finalAttrs) src;
#    hash = "";
#  }; 
 # npmRoot = ".";
  
  build-system = with py-vers; [
    setuptools
    setuptools-rust
    pythonRelaxDepsHook
  ];

  nativeBuildInputs = with pkgs; [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    gcc
    makeWrapper
    nodejs
    nodejsInstallExecutables
  #  npmHooks.npmConfigHook
  #  npmHooks.npmBuildHook
  #  npmHooks.npmInstallHook
  ];

  buildInputs = with pkgs; [
    libX11
    electron
  ];

  # Python dependencies
  dependencies = (with py-vers; [
    libevdev
    uv
    pip
    openai
    requests
    cryptography
    watchdog
    soundfile
    toml
    psutil
    xlib
    rapidfuzz
    plyer
    keyboard
    websockets
    dataclasses-json
    obsws-python
    pytz
    numpy
    faster-whisper
    kaldi-native-fbank
    regex
    opencv-python
    opencv-python-headless
    sounddevice
    groq
    flask
    pystray
    pillow
    flask-compress
    jaconv
    loguru
    pyperclipfix
    desktop-notifier
    mss
    pyqt6
    pyqtdarktheme
    pysbd
    pypresence
    curl-cffi
    protobuf
    py7zr
    waitress
    ollama
    google-genai
    tzlocal
    langid
    flasgger
    aiohttp
  ]);

  pythonRelaxDeps = [
    "openai"
    "uv"
    "cryptography"
    "soundfile"
    "numpy"
    "opencv-python"
    "opencv-python-headless"
    "groq"
    "onnxruntime"
    "tokenizers"
    "jaconv"
    "mss"
    "curl-cffi"
    "google-genai"
    "aiohttp"
  ];

  pythonRemoveDeps = [
    # Windows-only 
    "oneocr"

    # Nixpkgs unavaibility/Need package.
    "meikiocr"
  ];


  postPatch = ''
    substituteInPlace GameSentenceMiner/util/config/configuration.py \
      --replace-fail "/usr/bin/obs" "${pkgs.obs-studio}/bin/obs"
  '';
  
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ pkgs.ffmpeg pkgs.obs-studio ]}"
    
  ];
 
  doCheck = false;
  strictDeps = true;

  



  meta = {
    changelog = "https://github.com/bpwhelan/GameSentenceMiner/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/bpwhelan/GameSentenceMiner";
    description = "A tool for mining sentences from games. Update: Dependencies, replay buffer based line searching, and bug fixes.";
    license = lib.licenses.gpl3Only;
  };

})
