let upstream = https://github.com/aviate-labs/package-set/releases/download/v0.1.1/package-set.dhall sha256:f1a3f0af31ad92eca20cc829f1fb32ed54e9c6a49257f43c3831732b37bf7559
let Package = { name : Text, version : Text, repo : Text, dependencies : List Text }

let additions = [
  { name = "array"
  , repo = "https://github.com/aviate-labs/array.mo"
  , version = "v0.1.1"
  , dependencies = [ "base" ]
  },
  { name = "hash"
  , repo = "https://github.com/aviate-labs/hash.mo"
  , version = "v0.1.0"
  , dependencies = [ "base" ]
  },
  { name = "encoding"
  , repo = "https://github.com/aviate-labs/encoding.mo"
  , version = "v0.3.0"
  , dependencies = [ "base", "array" ]
  }
] : List Package

in  upstream # additions