let upstream = https://github.com/aviate-labs/package-set/releases/download/v0.1.3/package-set.dhall sha256:ca68dad1e4a68319d44c587f505176963615d533b8ac98bdb534f37d1d6a5b47
let Package = { name : Text, version : Text, repo : Text, dependencies : List Text }
let additions = [
  { name = "crypto"
  , repo = "https://github.com/aviate-labs/crypto.mo"
  , version = "v0.1.0"
  , dependencies = [ "base", "encoding" ]
  },
] : List Package
in  upstream # additions
