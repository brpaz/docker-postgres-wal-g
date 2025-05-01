{ pkgs, lib, config, inputs, ... }:

{
  packages = [
    pkgs.container-structure-test
    pkgs.go-task
    pkgs.lefthook
    pkgs.hadolint
  ];

  enterShell = ''
  '';
}
