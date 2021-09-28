import Debug "mo:base/Debug";
import Principal "mo:base/Principal";

import AccountIdentifier "../src/AccountIdentifier";

let p = Principal.fromText("g42pg-k3n7u-4sals-ufza4-34yrp-mmvkt-psecp-7do7x-snvq4-llwrj-2ae");
assert(AccountIdentifier.fromPrincipal(p, null) == "A7218DB708C35689495871C3C6860504503AB2A545630809DD8609130331B0C2");
