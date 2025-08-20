{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation rec {
      pname = "nordzy-icon-theme";
      version = "latest";

      src = pkgs.fetchFromGitHub {
        owner = "MolassesLover";
        repo = "Nordzy-icon";
        rev = "main";
        sha256 = "13v10c0x4ag7xif0ji2yvi7398q9w8jnzgcrfsmgk5by8y09za8r";
      };

      dontBuild = true;

      installPhase = ''
        mkdir -p $out/share/icons
        for dir in $src/Nordzy*; do
          if [ -d "$dir" ]; then
            cp -r "$dir" $out/share/icons/
          fi
        done
      '';
    })
  ];

  environment.variables = {
    GTK_ICON_THEME = "Nordzy";
    XCURSOR_THEME = "Nordzy";
  };
}

