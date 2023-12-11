{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types literalExpression mkEnableOption;

  cfg = config.programs.schizofox;
in {
  options.programs.schizofox.search = {
    defaultSearchEngine = mkOption {
      type = types.str;
      example = "DuckDuckGo";
      default = "Searx";
      description = "Default search engine";
    };

    addEngines = mkOption {
      type = with types; listOf attrs;
      default = import ../engineList.nix cfg;
      description = "List of search engines to add to your Schizofox configuration";
      example = literalExpression ''
        [
          {
            Name = "Etherscan";
            Description = "Checking balances";
            Alias = "!eth";
            Method = "GET";
            URLTemplate = "https://etherscan.io/search?f=0&q={searchTerms}";
          }
        ]
      '';
    };

    removeEngines = mkOption {
      type = with types; listOf str;
      default = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
      description = "List of default search engines to remove";
      example = literalExpression ''["LibRedirect"]'';
    };

    searxRandomizer = {
      enable = mkEnableOption "Randomize searx instances";
      instances = mkOption {
        type = with types; listOf str;
        default = ["searx.be" "search.notashelf.dev"];
        example = ["searx.be" "search.notashelf.dev"];
        description = "Instances for searx randomizer";
      };
    };
  };
}
