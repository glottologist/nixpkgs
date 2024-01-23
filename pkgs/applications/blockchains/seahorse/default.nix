{
  stdenv,
  fetchFromGitHub,
  lib,
  rustPlatform,
  darwin,
  udev,
  protobuf,
  libcxx,
  pkg-config,
  openssl,
  nix-update-script,
}: let
  version = "0.2.7";
  sha256 = "sha256-Gv17jkpIF6w7ccWzIqmotdpwf1zjy3eSqwX+fxmcFPk=";

  inherit (darwin.apple_sdk_11_0) Libsystem;
  inherit (darwin.apple_sdk_11_0.frameworks) System IOKit AppKit Security;
in
  rustPlatform.buildRustPackage rec {
    pname = "seahorse";
    inherit version;

    src = fetchFromGitHub {
      owner = "ameliatastic";
      repo = "seahorse-lang";
      rev = "main";
      inherit sha256;
    };

    cargoLock = {
      lockFile = ./Cargo.lock;

      outputHashes = {
      };
    };

    patches = [
    ];

    strictDeps = true;

    doCheck = false;

    nativeBuildInputs = [protobuf pkg-config];
    buildInputs =
      [openssl rustPlatform.bindgenHook]
      ++ lib.optionals stdenv.isLinux [udev]
      ++ lib.optionals stdenv.isDarwin [
        libcxx
        IOKit
        Security
        AppKit
        System
        Libsystem
      ];

    postInstall = ''
    '';

    # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
    OPENSSL_NO_VENDOR = 1;

    meta = with lib; {
      description = "Seahorse - Write Solana programs in Python";
      homepage = "https://github.com/ameliatastic/seahorse-lang";
      license = licenses.asl20;
      maintainers = with maintainers; [glottologist];
      platforms = platforms.unix;
    };

    passthru.updateScript = nix-update-script {};
  }
