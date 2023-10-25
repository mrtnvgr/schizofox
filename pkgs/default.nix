{inputs, ...}: {
  systems = ["x86_64-linux" "aarch64-linux"];

  perSystem = {pkgs, ...}: {
    packages = let
      docs = import ../docs {
        inherit pkgs;
        nmdSrc = inputs.nmd;
      };
    in {
      # Extensions
      darkreader = pkgs.callPackage ./darkreader.nix {};

      # Documentation
      docs = docs.manual.html;
      docs-html = docs.manual.html;
      docs-manpages = docs.manPages;
      docs-json = docs.options.json;
    };
  };
}
