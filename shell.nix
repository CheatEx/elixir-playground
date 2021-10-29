{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  basePackages = [
    beam.packages.erlang.elixir
    beam.packages.erlang.erlang
    nodejs
  ];
  
  hooks = ''
    # this allows mix to work on the local directory
    mkdir -p .nix-mix .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-mix
    export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
    
    mix local.hex --force --if-missing
    mix local.rebar --force --if-missing
    
    export LANG=en_US.UTF-8
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';
in

mkShell {
  buildInputs = basePackages ++ 
                [ glibcLocales libnotify inotify-tools ];
  shellHooks = hooks;
}
