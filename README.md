# RDGen, a RustDesk client generator to use with your self-hosted RustDesk server

The client generator is currently hosted [here](https://rdgen.crayoneater.org).
If you would like to host the generator yourself, see [here](setup.md)

## Features

- Embed server and key into client
- Custom app name
- Custom icon/logo
- Set default settings for the client
- Support for rustdesk advanced settings (https://rustdesk.com/docs/en/self-host/client-configuration/advanced-settings/)

## Generate RustDesk clients from command line instead of using a web browser

Save your configuration from the rdgen web interface, or generate your own, then use that json file with [@AlekseyLapunov's rdgen-cli](https://github.com/AlekseyLapunov/rdgen-cli) to build from the command line on Windows, Linux, or MacOS like this: `python rdgen-cli -f my_config.json --set-version 1.4.5 --set-platform windows -s https://rdgen.crayoneater.org`

## Notes

- Icons should be square (256x256 recommended)
- Avoid special characters or non-English characters in app name and file name
- Build time is currently 30 - 45 minutes


## Branding presets (multi-empresa)

Cada empresa tem uma pasta em `branding/<empresa>/` com `preset.env` (servidor, chave pública, nomes, cor) e, opcionalmente, `icon.png` (128x128) e `logo.png` (160x160).

```bash
./scripts/build-client.sh --list                                   # presets disponíveis
./scripts/build-client.sh innerbit --platform windows --dry-run    # confere o comando
./scripts/build-client.sh liberalcontabilidade --platform windows  # dispara o build
```

Para adicionar uma empresa: copie `branding/liberalcontabilidade/` para `branding/<nova>/`, preencha `preset.env`, adicione os PNGs e rode com `--dry-run` primeiro.
