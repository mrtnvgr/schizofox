{
  pkgs,
  lib ? import ../lib/extended-lib.nix pkgs.lib,
  nmdSrc,
  ...
}: let
  nmd = import nmdSrc {inherit lib pkgs;};

  # Make sure the used package is scrubbed to avoid actually instantiating
  # derivations.
  #
  # Also disable checking since we'll be referring to undefined options.
  setupModule = {
    imports = [
      {
        _module.args = {
          pkgs = lib.mkForce (nmd.scrubDerivations "pkgs" pkgs);
          pkgs_i686 = lib.mkForce {};
        };
        _module.check = false;
      }
    ];
  };

  hmModulesDocs = nmd.buildModulesDocs {
    modules = [
      setupModule
      ../modules/hm/options.nix
    ];
    moduleRootPaths = [../modules/hm];
    mkModuleUrl = path:
      "https://github.com/schizofox/schizofox/blob/main"
      + "/modules/hm/${path}#blob-content-holder";
    channelName = "schizofox";
    docBook = {
      id = "schizofox-options";
      optionIdPrefix = "opt";
    };
  };

  docs = nmd.buildDocBookDocs {
    pathName = "schizofox";
    modulesDocs = [hmModulesDocs];
    documentsDirectory = ./.;
    chunkToc = ''
      <toc>
        <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-schizofox-manual"><?dbhtml filename="index.html"?>
          <d:tocentry linkend="ch-schizofox-options"><?dbhtml filename="schizofox-options.html"?></d:tocentry>
        </d:tocentry>
      </toc>
    '';
  };
in {
  options = {
    json = pkgs.symlinkJoin {
      name = "schizofox-options-json";
      paths = [
        (hmModulesDocs.json.override {
          path = "share/doc/schizofox/options.json";
        })
      ];
    };
  };

  manPages = docs.manPages;

  manual = {inherit (docs) html htmlOpenTool;};
}
