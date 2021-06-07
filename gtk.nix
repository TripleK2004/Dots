{config, pkgs,...}:
{
gtk = {
    enable = true;
    theme.package = pkgs.arc-theme;
    theme.name = "Arc-Dark";
    iconTheme.package = pkgs.arc-icon-theme;
    iconTheme.name = "Arc";
    font.name = "Sans Bold 10";
    gtk3.extraConfig = {
      gtk-cursor-theme-size = 16;
      gtk-application-prefer-dark-theme = 1;
      gtk-button-images = 1;
      gtk-menu-images = 1;
      gtk-enable-event-sounds = 1;
      gtk-enable-input-feedback-sounds  = 1;
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH_HORIZ";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-xft-antialias =  1;
      gtk-xft-hinting =  1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba  ="rgb";
      gtk-cursor-theme-name ="Adwaita";
      gtk-modules ="gail:atk-bridge";
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-name="Adwaita"
      gtk-cursor-theme-size=16
      gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
      gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      gtk-button-images=1
      gtk-menu-images=1
      gtk-enable-event-sounds=1
      gtk-enable-input-feedback-sounds=1
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintfull"
      gtk-xft-rgba="rgb"
      gtk-modules="gail:atk-bridge"
    '';
  };
  }
