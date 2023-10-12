## Elixir and Erlang Release

To vendor elixir package into your release, run:

```
$ git clone https://github.com/dark5un/bosh-package-elixir-release.git ~/workspace/bosh-package-elixir-release
$ cd ~/workspace/your-release
$ bosh vendor-package elixir-1.15-otp-26 ~/workspace/bosh-package-elixir-release
```

### Runtime functions and scripts

To use `elixir-*` package at runtime in your job scripts:

```bash
#!/bin/bash -eu
source /var/vcap/packages/otp-26/bosh/runtime.env
source /var/vcap/packages/elixir-1.15-otp-26/bosh/runtime.env

hex ...
```
