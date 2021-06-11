{config, pkgs,...}:

with import ./colors.nix {}; {
    programs.mako = {
	enable = true;
	font = "JetBrainsMono Nerd Font 10";
	borderSize = 4;
	defaultTimeout = 5000;
	height = 100;
	backgroundColor = "${bg}";
	textColor = "${purple}";
	borderColor = "${purple}";
	    };
	}








