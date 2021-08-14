import Debug "mo:base/Debug";

import Principal "../principal";

let p = Principal.fromText("em77e-bvlzu-aq");
let b = Principal.toBlob(p);
assert(p == Principal.fromBlob(b));