{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;
  elixir = beam.packages.erlangR23.elixir_1_11;
  nodejs = nodejs-14_x;
  postgresql = postgresql_12;
in

mkShell {
  buildInputs = [
    elixir
    nodejs
    git
    postgresql
  ]
  ++ optional stdenv.isLinux inotify-tools # For file_system on Linux.
  ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    # For file_system on macOS.
    CoreFoundation
    CoreServices
  ]);

  PGHOST = "${builtins.getEnv "PWD"}/.tmp/postgres_host";
  PGDATA = "${builtins.getEnv "PWD"}/.tmp/postgres_data"; 
}
