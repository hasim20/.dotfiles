# /etc/nixos/configuration.nix

{ config, lib, pkgs, ... }:

{
    imports =
        [
            # Sertakan hasil pemindaian perangkat keras (hardware scan).
            /etc/nixos/hardware-configuration.nix
        ];

    # --- Pemuat Boot (Boot Loader) ---
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    
    # --- Driver Grafis ---
    # Tambahkan driver AMDGPU untuk ThinkPad T14 AMD Gen 1
    # Tidak perlu services.xserver.videoDrivers jika hanya menggunakan Wayland,
    # tetapi hardware.opengl PENTING untuk akselerasi.
    # services.xserver.videoDrivers = [ "amdgpu" ]; # TIDAK DIPERLUKAN KARENA WAYLAND
    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = with pkgs; [
      amdvlk
      mesa
    ];
    
    # --- Jaringan dan Waktu ---
    networking.hostName = "T14";
    networking.networkmanager.enable = true;
    time.timeZone = "Asia/Jakarta";

    # Konfigurasi Hyprland
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };
    
    # --- Display Manager: Greetd dengan Gtkgreet ---
    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'WELCOME TUKIMEN' --user-menu --asterisks --remember --time --cmd Hyprland";
                user = "hasim";
            };
            
            # session = {
            #     # PERBAIKAN: Ganti TANDA KUTIP TUNGGAL (') dengan GANDA (")
            #     "hyprland" = {
            #         command = "${pkgs.hyprland}/bin/Hyprland";
            #     };
            # };
        };
    };

    # --- Suara (Sound) ---
    services.pipewire = {
        enable = true;
        pulse.enable = true; 
    };
    
    # --- Bluetooth ---
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
            General = {
                Experimental = true;
                FastConnectable = true;
            };
            Policy = {
                AutoEnable = true;
            };
        };
    };

    # --- Terminal dan Perangkat Input ---
    programs.zsh.enable = true; 

    # --- Perangkat Input ---
    services.libinput.enable = true; 

    # --- Pengguna dan Grup ---
    users.users.hasim = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ 
            "wheel" 
            "networkmanager" 
            "video" 
            "audio"
        ];
    };
    
    # --- Paket Sistem (System Packages) ---
    environment.systemPackages = with pkgs; [
        vim 
        neovim
        git
        brightnessctl
        wget

        kitty
        fzf
        yazi
        tmux
        gcc
        glibc

        bibata-cursors
    ];
    programs.firefox.enable = true; 

    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    
    system.stateVersion = "25.05"; 
}
