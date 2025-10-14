# /etc/nixos/configuration.nix

{ config, lib, pkgs, ... }:

{
    imports =
        [
            # Sertakan hasil pemindaian perangkat keras (hardware scan).
            ./hardware-configuration.nix
        ];

    # --- Pemuat Boot (Boot Loader) ---
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    
    # HAPUS: services.getty.autologinUser = "hasim";
    # Kita akan menggunakan Greetd sebagai gantinya.

    # --- Driver Grafis ---
    # Tambahkan driver AMDGPU untuk ThinkPad T14 AMD Gen 1
    # Tidak perlu services.xserver.videoDrivers jika hanya menggunakan Wayland,
    # tetapi hardware.opengl PENTING untuk akselerasi.
    # services.xserver.videoDrivers = [ "amdgpu" ]; # TIDAK DIPERLUKAN KARENA WAYLAND
    hardware.opengl.enable = true;
    hardware.opengl.extraPackages = with pkgs; [
      amdvlk
      mesa.drivers
    ];
    
    # --- Jaringan dan Waktu ---
    networking.hostName = "T14"; # Nama host
    networking.networkmanager.enable = true; # Gunakan NetworkManager
    time.timeZone = "Asia/Jakarta"; # Zona waktu

    # --- Tampilan (Display) dan Lingkungan Desktop ---
    # services.xserver.enable = true; # HAPUS INI karena kita pakai Wayland native

    # Konfigurasi Hyprland
    programs.hyprland = {
        enable = true;
        # Xwayland PENTING untuk menjalankan aplikasi berbasis X di Hyprland
        xwayland.enable = true;
    };
    
    # --- Display Manager: Greetd dengan Gtkgreet ---
    services.greetd = {
        enable = true;
        # Greetd berjalan sebagai Wayland compositor
        settings = {
            default_session = {
                # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'WELCOME TUKIMEN' --user-menu --asterisks --remember --time --cmd Hyprland";
                # Pastikan gtkgreet berjalan di Wayland
                user = "hasim";
            };
            
            # Konfigurasi untuk sesi pengguna (Hyprland)
            session = {
                # PERBAIKAN: Ganti TANDA KUTIP TUNGGAL (') dengan GANDA (")
                "hyprland" = {
                    command = "${pkgs.hyprland}/bin/Hyprland";
                };
            };
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
    services.libinput.enable = true; 

    # --- Pengguna dan Grup ---
    users.users.hasim = {
        isNormalUser = true;
        extraGroups = [ 
            "wheel" 
            "networkmanager" 
            "video" 
            "audio"
        ];
        shell = pkgs.zsh;
        
        # Tambahkan beberapa paket ke profil pengguna secara global
        packages = with pkgs; [
            tree
            git
        ];
    };
    
    # --- Paket Sistem (System Packages) ---
    environment.systemPackages = with pkgs; [
        greetd.gtkgreet
        vim 
        neovim
        wget
        foot
        kitty
        brightnessctl
        fzf
        yazi
        tmux
        firefox
        gcc
        glibc
        bibata-cursors
    ];
    
    # HAPUS: nix.settings.experimental-features (karena tanpa flakes)
    
    system.stateVersion = "25.05"; 
}
