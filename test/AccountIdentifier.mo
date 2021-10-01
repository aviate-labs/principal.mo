import Hex "mo:encoding/Hex";
import Principal "mo:base/Principal";

import AccountIdentifier "../src/AccountIdentifier";
import util "../src/util";

let p  = Principal.fromText("g42pg-k3n7u-4sals-ufza4-34yrp-mmvkt-psecp-7do7x-snvq4-llwrj-2ae");
let a  = AccountIdentifier.fromPrincipal(p, null);
let at1 = "A7218DB708C35689495871C3C6860504503AB2A545630809DD8609130331B0C2";
let at2 = "a7218db708c35689495871c3c6860504503ab2a545630809dd8609130331b0c2";
assert(AccountIdentifier.toText(a) == at1);
assert(AccountIdentifier.fromText(at1) == #ok(a));
assert(AccountIdentifier.fromText(at2) == #ok(a));
