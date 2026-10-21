{
  pkgs ? import <nixpkgs> { },
  lib,
  py-vers ? pkgs.python313Packages,
  fetchPypi,
}:

let
  # Python version
  py-vers = pkgs.python313Packages;
in

py-vers.buildPythonApplication (finalAttrs: rec {
  pname = "gamesentenceminer";
  version = "2026.10.0.post1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HqNXCpVqtBJdvJiY1ESYyHQrJSSPJLpxRGCjEvolBcw=";
  };

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src sourceRoot;
    hash = "sha256-ooGfsA7M7JBAuQ9DhKqV2XfzXFyqZt6nsc59IC10Vkc=";
  };
  
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
    ffmpeg
    obs-studio
  ];

  buildInputs = with pkgs; [
    libX11
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

  sourceRoot = "gamesentenceminer-${finalAttrs.version}";
  cargoRoot = "native/gsm-native";

  postPatch = ''
    substituteInPlace GameSentenceMiner/util/config/configuration.py \
      --replace-fail "/usr/bin/obs" "${pkgs.obs-studio}/bin/obs"
  '';
  
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ pkgs.ffmpeg pkgs.obs-studio ]}"
    
  ];
 
  doCheck = false;

  



  meta = {
    changelog = "https://github.com/bpwhelan/GameSentenceMiner/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/bpwhelan/GameSentenceMiner";
    description = "A tool for mining sentences from games. Update: Dependencies, replay buffer based line searching, and bug fixes.";
    license = lib.licenses.gpl3Only;
  };

})
