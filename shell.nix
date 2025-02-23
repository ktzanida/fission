{ rosetta ? false }:
  let
    sources  = import ./nix/sources.nix;
    commands = import ./nix/commands.nix;

    overrides = if rosetta then { system = "x86_64-darwin"; } else {};

    nixos    = import sources.nixos    overrides;
    darwin   = import sources.darwin   overrides;
    unstable = import sources.unstable overrides;

    pkgs  = if darwin.stdenv.isDarwin then darwin else nixos;
    tasks = commands {
      inherit pkgs;
      inherit unstable;
      inherit server-path;
      inherit server-port;
    };

    server-path = "~/.local/bin/fission-server";
    server-port = 10235;

    deps = {
      common = [
        unstable.niv
      ];

    crypto = [
      pkgs.openssl.dev
      pkgs.openssl.out
    ];

    cli = [pkgs.ncurses.dev.out];

    data = [
      pkgs.ipfs
      pkgs.lzma.dev
      pkgs.lzma.out
      pkgs.zlib.dev
      pkgs.zlib.out
      pkgs.postgresql
    ];

    haskell = [
      unstable.haskell-language-server
      unstable.stack
      unstable.stylish-haskell
    ];

    macos =
      if pkgs.stdenv.isDarwin then
        [ unstable.darwin.apple_sdk.frameworks.CoreServices
          unstable.darwin.apple_sdk.frameworks.Foundation
          unstable.darwin.apple_sdk.frameworks.Cocoa
        ]
      else
        [];
  };

  in
    unstable.haskell.lib.buildStackProject {
      name = "Fission";
      nativeBuildInputs = builtins.concatLists [
        deps.common
        deps.crypto
        deps.cli
        deps.data
        deps.macos
        deps.haskell
        tasks
      ];

      shellHook = ''
        export LANG=C.UTF8
      '';
    }
