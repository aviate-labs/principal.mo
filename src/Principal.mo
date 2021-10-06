import Array "mo:base/Array";
import Base32 "mo:encoding/Base32";
import Blob "mo:base/Blob";
import Char "mo:base/Char";
import CRC32 "mo:hash/CRC32";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Prim "mo:⛔"; // Char.toLower();
import Principal "mo:base/Principal";

module {
    public let fromText : (t : Text) -> Principal = Principal.fromText;

    public let toText : (p : Principal) -> Text = Principal.toText;

    public func fromBlob(b : Blob) : Principal {
        let bs  = Blob.toArray(b);
        let b32 = Base32.encode(Array.append<Nat8>(
            nat32ToNat8Array(CRC32.checksum(bs)),
            bs,
        ));
        Principal.fromText(format(b32));
    };

    public let toBlob : (p : Principal) -> Blob = Principal.toBlob;

    public func format(bs : [Nat8]) : Text {
        var id = "";
        for (i in bs.keys()) {
            let c = Prim.charToLower(Char.fromNat32(nat8ToNat32(bs[i])));
            id #= Char.toText(c);
            if ((i + 1) % 5 == 0 and i + 1 != bs.size()) {
                id #= "-"
            };
        };
        id;
    };

    private func nat8ToNat32(n : Nat8) : Nat32 {
        Nat32.fromNat(Nat8.toNat(n));
    };

    private func nat32ToNat8(n : Nat32) : Nat8 {
        Nat8.fromNat(Nat32.toNat(n) % 256);
    };

    private func nat32ToNat8Array(n : Nat32) : [Nat8] {
        [
            nat32ToNat8(n >> 24),
            nat32ToNat8(n >> 16),
            nat32ToNat8(n >> 8),
            nat32ToNat8(n),
        ];
    };
}
