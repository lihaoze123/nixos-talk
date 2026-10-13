{
  description = "NixOS —— 浅谈 AI 时代的 Agentic Linux 操作系统（讲座幻灯片）";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      forAll = f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (s: f nixpkgs.legacyPackages.${s});
    in
    {
      # 字体（Fira Code、方正系列）使用系统已安装的字体
      devShells = forAll (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [ typst tinymist just pympress ];
        };
      });
    };
}
