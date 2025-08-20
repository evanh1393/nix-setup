{ pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-sugar-candy";
    settings = {
      Theme = { Current = "sddm-sugar-candy"; };
      Users = {
        HideUsers = "root";
        RememberLastUser = true;
        RememberLastSession = true;
      };
      General = { InputMethod = ""; };
    };
  };

  services.xserver.enable = true;

  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation {
      pname = "sddm-sugar-candy";
      version = "1.6";

      src = pkgs.fetchFromGitHub {
        owner = "MarianArlt";
        repo = "sddm-sugar-candy";
        rev = "v1.6"; # current tag
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # fill with correct hash
      };

      installPhase = ''
        mkdir -p $out/share/sddm/themes/
        cp -r . $out/share/sddm/themes/sddm-sugar-candy
      '';
    })
  ];

  environment.etc."sddm/themes/sddm-sugar-candy/theme.conf.user".text = ''
[General]
Background="backgrounds/nord-mountains.jpg"
ScreenWidth=1920
ScreenHeight=1080
FullBlur=true
PartialBlur=false
AccentColor=#88C0D0
BackgroundColor=#2E3440
PasswordFieldColor=#4C566A
PasswordFieldTextColor=#ECEFF4
UiFont="Inter"
HeaderText=Welcome
HeaderTextColor=#ECEFF4
ClockFontSize=34
FormPosition=center
'';

  environment.etc."sddm/themes/sddm-sugar-candy/backgrounds/nord-mountains.jpg".source =
    /path/to/your/nord-mountains.jpg;
}

