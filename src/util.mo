import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";

module Util {
    public func nat32ToNat8(n : Nat32) : Nat8 {
        Nat8.fromNat(Nat32.toNat(n) % 256);
    };

    public func drop<A>(xs : [A], n : Nat) : [A] {
        var ys : [A] = [];
        for (i in xs.keys()) {
            if (i >= n) {
                ys := Array.append(ys, [xs[i]])
            };
        };
        ys;
    }
}