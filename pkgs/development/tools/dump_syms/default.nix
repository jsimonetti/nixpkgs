{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl

# darwin
, Security
}:

let
  pname = "dump_syms";
  version = "1.0.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cgLlCNNid7JIukdWKy3nPJwyZ84YpKrnCC4Rm6E7DDk=";
  };

  cargoSha256 = "sha256-0qRaBgIoWXYnQkxY7hFkvj3v/7mEGGRzQV7JFib8JRk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals (stdenv.isDarwin) [
    Security
  ];

  checkFlags = [
    # Disable tests that require network access
    # ConnectError("dns error", Custom { kind: Uncategorized, error: "failed to lookup address information: Temporary failure in name resolution" })) }', src/windows/pdb.rs:725:56
    "--skip windows::pdb::tests::test_ntdll"
    "--skip windows::pdb::tests::test_oleaut32"
  ];

  meta = with lib; {
    changelog = "https://github.com/mozilla/dump_syms/releases/tag/v${version}";
    description = "Command-line utility for parsing the debugging information the compiler provides in ELF or stand-alone PDB files";
    license = licenses.asl20;
    homepage = "https://github.com/mozilla/dump_syms/";
    maintainers = with maintainers; [ hexa ];
  };
}
