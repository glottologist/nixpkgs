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
  version = "0.29.0";
  sha256 = "sha256-mftge1idALb4vwyF8wGo6qLmrnvCBK3l+Iw7txCyhDc=
";

  inherit (darwin.apple_sdk_11_0) Libsystem;
  inherit (darwin.apple_sdk_11_0.frameworks) System IOKit AppKit Security;
in
  rustPlatform.buildRustPackage rec {
    pname = "anchor";
    inherit version;

    src = fetchFromGitHub {
      owner = "coral-xyz";
      repo = "anchor";
      rev = "v${version}";
      inherit sha256;
    };

    cargoHash = "";

    cargoLock = {
      lockFile = ./Cargo.lock;

      outputHashes = {
        "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=
";
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
      description = "Anchor - Sealevel Framework for the Solana blockchain";
      homepage = "https://github.com/coral-xyz/anchor";
      license = licenses.asl20;
      maintainers = with maintainers; [glottologist];
      platforms = platforms.unix;
    };

    passthru.updateScript = nix-update-script {};
  }
