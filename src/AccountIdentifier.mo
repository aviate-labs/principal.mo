import Array "mo:base/Array";
import Binary "mo:encoding/Binary";
import Blob "mo:base/Blob";
import Hash "mo:base/Hash";
import Hex "mo:encoding/Hex";
import Principal "mo:base/Principal";
import SHA256 "mo:sha/SHA256";

import CRC32 "CRC32";

module {
    public type AccountIdentifier = [Nat8]; // Size 28
    public type SubAccount        = [Nat8]; // Size 4

    // Checks whether two account identifiers are equal.
    public func equal(a : AccountIdentifier, b : AccountIdentifier) : Bool {
        a == b;
    };

    // Creates a CRC-32 hash of the given account identifier.
    public func hash(accountId : AccountIdentifier) : Hash.Hash {
        CRC32.checksum(accountId);
    };

    // Hex string of length 64. The first 8 characters are the CRC-32 encoded
    // hash of the following 56 characters of hex.
    public func toText(accountId : AccountIdentifier) : Text {
        Hex.encode(Array.append<Nat8>(Binary.BigEndian.fromNat32(hash(accountId)), accountId));
    };

    private let prefix : [Nat8] = [10, 97, 99, 99, 111, 117, 110, 116, 45, 105, 100];

    public func fromPrincipal(p : Principal, subAccount : ?SubAccount) : AccountIdentifier {
        fromBlob(Principal.toBlob(p), subAccount);
    };

    public func fromBlob(data : Blob, subAccount : ?SubAccount) : AccountIdentifier {
        fromArray(Blob.toArray(data), subAccount);
    };

    public func fromArray(data : [Nat8], subAccount : ?SubAccount) : AccountIdentifier {
        let account : [Nat8] = switch (subAccount) {
            case (null) { Array.freeze(Array.init<Nat8>(32, 0)); };
            case (?sa)  { sa; };
        };
        SHA256.sum224(Array.flatten<Nat8>([prefix, data, account]));
    };
};
