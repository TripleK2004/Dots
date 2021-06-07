{config, pkgs,...}:

with import ./colors.nix { };{
	programs.alacritty = {
	enable = true;
	settings = {
	    env = { TERM = "xterm-256color"; };
	    font = {
		normal = {
		    family = "JetBrainsMono Nerd Font";
		    style = "Regular";
		};
		bold = {
		    family = "JetBrainsMono Nerd Font";
		    style = "Regular";
		};
		italic = {
		    family = "JetBrainsMono Nerd Font";
		    style = "Regular";
		};
		bold-italic = {
		    family = "JetBrainsMono Nerd Font";
		    style = "Regular";
		};
		size = 12;
	    };

	    colors = {
		primary = {
		    background = "#282a36";
		    foreground = "#f8f8f2";
			    };
		normal = {
		    black = "${crntline}";
		    red ="${red}";
		    green="${green}";
		    yellow="${yellow}";
		    blue="${cmmnt}";
		    magenta="${pink}";
		    cyan="${cyan}";
		    white="${cyan}";
			};
		bright = {
		    black = "${crntline}";
		    red ="${red}";
		    green="${green}";
		    yellow="${yellow}";
		    blue="${cmmnt}";
		    magenta="${pink}";
		    cyan="${cyan}";
		    white="${cyan}";
			};
		dim = {
		    black = "${crntline}";
		    red ="${red}";
		    green="${green}";
		    yellow="${yellow}";
		    blue="${cmmnt}";
		    magenta="${pink}";
		    cyan="${cyan}";
		    white="${cyan}";
			};
		    };
	    background_opacity = 0.95;
			};
		    };
	    }
	
		




	
