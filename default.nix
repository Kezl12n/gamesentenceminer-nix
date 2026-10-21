# default.nix
let
  pkgs = import <nixpkgs> {};
  
  # 1. Explicitly select the exact Python version you want to target
  # Options: python310, python311, python312, python313, etc.
  chosenPython = pkgs.python312; 
in
  # 2. Use the package set belonging to that specific Python interpreter
  chosenPython.pkgs.callPackage ./package.nix {}
