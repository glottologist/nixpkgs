{
  lib,
  fetchFromGitHub,
  pythonPackages,
}:
pythonPackages.buildPythonApplication rec {
  pname = "solana-py";
  version = "0.30.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "solana-py";
    repo = pname;
    rev = version;
    sha256 = "0qzrxqhsxn0h71nfrsi9g78hx3pqm3b8sr6fjq01k4k6dd2nwfam";
  };

  meta = with lib; {
    description = "Python library for interacting with the Solana blockchain";
    homepage = "https://github.com/michaelhly/solana-py";
    license = licenses.mit;
    maintainers = with maintainers; [glottologist];
    platforms = platforms.linux;
  };
}
