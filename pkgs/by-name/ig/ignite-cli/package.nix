{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  go,
  buf,
}:

buildGoModule (finalAttrs: {
  pname = "ignite-cli";
  version = "29.9.2";

  src = fetchFromGitHub {
    repo = "cli";
    owner = "ignite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0BlQhCfjD9hgEyFApV6rVMtIcuntGT9i/FtRwaPhpQ0=";
  };

  vendorHash = "sha256-kiADtFopRmvpCAIhdiCRBIrgxrx8jrpVZ3rYwFw0a08=";

  subPackages = [
    "ignite/cmd/ignite"
  ];

  nativeBuildInputs = [ makeWrapper ];

  # Many tests require access to either executables, state or networking
  doCheck = false;

  # Required for wrapProgram
  allowGoReference = true;

  # Required for commands like `ignite version`, `ignite network` and others
  postFixup = ''
    wrapProgram $out/bin/ignite --prefix PATH : ${
      lib.makeBinPath [
        go
        buf
      ]
    }
  '';

  meta = {
    homepage = "https://ignite.com/";
    changelog = "https://github.com/ignite/cli/releases/tag/v${finalAttrs.version}";
    description = "All-in-one platform to build, launch, and maintain any crypto application on a sovereign and secured blockchain";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "ignite";
  };
})
