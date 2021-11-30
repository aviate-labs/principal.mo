import Blob "mo:base/Blob";
import Hex "mo:encoding/Hex";
import Principal "mo:base/Principal";

import AId "../src/AccountIdentifier";
import AIdBlob "../src/blob/AccountIdentifier";

let p  = Principal.fromText("g42pg-k3n7u-4sals-ufza4-34yrp-mmvkt-psecp-7do7x-snvq4-llwrj-2ae");
let a  = AId.fromPrincipal(p, null);
let at1 = "A7218DB708C35689495871C3C6860504503AB2A545630809DD8609130331B0C2";
let at2 = "a7218db708c35689495871c3c6860504503ab2a545630809dd8609130331b0c2";
assert(AId.toText(a) == at1);
assert(AId.fromText(at1) == #ok(a));
assert(AId.fromText(at2) == #ok(a));

// Note, this type of account identifier already includes the hash!
let ab = AIdBlob.fromPrincipal(p, null);
assert(AIdBlob.toText(ab) == at1);
assert(Hex.equal(Hex.encode(Blob.toArray(ab)), at2));
