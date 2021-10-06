import Array "mo:base/Array";
import Array_ "mo:array/Array";
import Binary "mo:encoding/Binary";
import Blob "mo:base/Blob";
import CRC32 "mo:hash/CRC32";
import Hash "mo:base/Hash";
import Hex "mo:encoding/Hex";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import SHA256 "mo:sha/SHA256";

module {
    // Represents an account identifier that was dirived from a principal.
    // NOTE: does NOT include the hash, unlike in the textual representation.
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

    // Decodes the given hex encoded account identifier.
    // NOTE: does not validate if the hash/account identifier.
    public func fromText(accountId : Text) : Result.Result<AccountIdentifier, Text> {
        switch (Hex.decode(accountId)) {
            case (#err(e)) { #err(e); };
            case (#ok(bs)) {
                // Remove the hash prefix.
                #ok(Array_.drop<Nat8>(bs, 4));
            };
        };
    };

    private let prefix : [Nat8] = [10, 97, 99, 99, 111, 117, 110, 116, 45, 105, 100];

    // Creates an account identifier based on the given principal and subaccount.
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
