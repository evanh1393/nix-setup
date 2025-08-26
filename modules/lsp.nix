{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
    # Language Servers
    vue-language-server
    lua-language-server
    nil
    nodePackages.typescript-language-server
    nodePackages.intelephense
    python311Packages.python-lsp-server
    gopls
    dockerfile-language-server-nodejs 
    
    # Language Runtimes
    python311
    
    # Formatters
    stylua
    nixpkgs-fmt
    nodePackages.prettier
    python311Packages.black
    python311Packages.isort
    gofumpt
    go-tools
    
    # Linters
    golangci-lint
    hadolint                          
    
    # Build tools for Treesitter compilation
    gcc
    gnumake
    tree-sitter
    
    # Bash
    bash-language-server
    shfmt
    shellcheck
    
    # Optional Go tools
    delve
    gotests
  ];
}
