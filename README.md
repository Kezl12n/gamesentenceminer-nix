# Description
This is an unofficial Nix Flake for GameSentenceMiner. (AppImage format)

Intention: Make it work and convenient enough for devices running NixOS.


## Important dependencies
- [Anki](https://wiki.nixos.org/wiki/Anki)
- [OBS Studio](https://wiki.nixos.org/wiki/OBS_Studio)

## Getting started
[Linux guide](https://docs.gamesentenceminer.com/docs/getting-started/linux/)


## Credits
* [GameSentenceMiner](https://github.com/bpwhelan/GameSentenceMiner) - Original application by [@bpwhelan](https://github.com/bpwhelan)


---

## Desktop entry missing
Launchers may not detect the added desktop entry. This can be easily fixed by adding the command:

```
cp /run/current-system/sw/share/applications/com.beangate.gamesentenceminer.desktop ~/.local/share/application 

```

## Testing Checklist (incomplete)

- [x] Communicating with OBS, Anki
- [x] Setting up with wayland (Although you may experience limitations when using wayland compared to X11)
- [ ] OCR Operations (Google Lens works as of 2026-10-27)







