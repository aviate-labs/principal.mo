let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.6.6-20210809/package-set.dhall sha256:bd11878d8690bcdedc5a9d386a0ce77f8e9de69b65f6ecbed930cbd79bf43338
let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let additions = [
   { name = "principal"
   , repo = "https://github.com/aviate-labs/principal.mo"
   , version = "v0.1.1"
   , dependencies = [ "base" ]
   }
]

in  upstream # additions
