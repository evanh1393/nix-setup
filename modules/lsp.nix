# /etc/nixos/modules/language-servers.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Language Servers
    vue-language-server
    lua-language-server
    nil                                    # Nix
    nodePackages.typescript-language-server # JS/TS
    nodePackages.intelephense              # PHP
    python311Packages.python-lsp-server    # Python LSP
    
    # Language Runtimes
    python311                              # Python runtime
    
    # Formatters for the LSPs
    stylua
    nixpkgs-fmt
    nodePackages.prettier
    php84Packages.composer                 # PHP 8.4
    python311Packages.black                # Python formatter
    python311Packages.isort                # Python import sorter
    
    # Build tools for Treesitter compilation
    gcc
    gnumake
    tree-sitter                            # Treesitter CLI
  ];
}
