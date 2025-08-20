{ config, pkgs, lib, ... }:

{
  options.development.php-laravel.enable = lib.mkEnableOption "PHP Laravel development environment";
  
  config = lib.mkIf config.development.php-laravel.enable {
    environment.systemPackages = 
    let
      myPhp = pkgs.php84.withExtensions ({ all, enabled }: enabled ++ (with all; [
        imagick redis pdo_mysql pdo_pgsql gd mbstring curl openssl zip 
        tokenizer fileinfo dom session ctype iconv simplexml xmlreader xmlwriter
      ]));
      
      myComposer = pkgs.phpPackages.composer.override { php = myPhp; };
    in
    with pkgs; [
      imagemagick
      myPhp
      myComposer
      mariadb_114
      postgresql_16
      redis
      meilisearch
      nodejs_latest
      bun
      git
    ];

    services.mysql = {
      enable = true;
      package = pkgs.mariadb_114;
      settings.mysqld = {
        bind-address = "127.0.0.1";
        port = 3306;
      };
      initialDatabases = [{ name = "laravel_dev"; }];
      initialScript = pkgs.writeText "mysql-init.sql" ''
        CREATE USER IF NOT EXISTS 'laravel'@'localhost' IDENTIFIED BY 'password';
        GRANT ALL PRIVILEGES ON laravel_dev.* TO 'laravel'@'localhost';
        FLUSH PRIVILEGES;
      '';
    };

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      settings.port = 5432;
      initialScript = pkgs.writeText "postgresql-init.sql" ''
        CREATE USER laravel WITH PASSWORD 'password' CREATEDB;
        CREATE DATABASE laravel_dev OWNER laravel;
      '';
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
    };

    services.redis = {
      servers."" = {
        enable = true;
        bind = "127.0.0.1";
        port = 6379;
      };
    };

    environment.etc."scripts/start-meilisearch.sh" = {
      text = ''
        #!/bin/sh
        echo "Starting Meilisearch on http://localhost:7700"
        ${pkgs.meilisearch}/bin/meilisearch --http-addr 127.0.0.1:7700 --no-analytics
      '';
      mode = "0755";
    };
  };
}

