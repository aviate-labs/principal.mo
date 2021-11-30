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

import AccountIdentifier "../AccountIdentifier";

module {
    // Represents an account identifier that was dirived from a principal.
    // NOTE: does include the hash, unlike in the default package.
    public type AccountIdentifier = Blob;   // Size 32
    public type SubAccount        = [Nat8]; // Size 4

    // Checks whether two account identifiers are equal.
    public func equal(a : AccountIdentifier, b : AccountIdentifier) : Bool {
        a == b;
    };

    // Hex string of length 64. The first 8 characters are the CRC-32 encoded
    // hash of the following 56 characters of hex.
    public func toText(accountId : AccountIdentifier) : Text {
        Hex.encode(Blob.toArray(accountId));
    };

    // Decodes the given hex encoded account identifier.
    // NOTE: does not validate if the hash/account identifier.
    public func fromText(accountId : Text) : Result.Result<AccountIdentifier, Text> {
        switch (Hex.decode(accountId)) {
            case (#err(e)) #err(e);
            case (#ok(bs)) #ok(Blob.fromArray(bs));
        };
    };

    // Creates an account identifier based on the given principal and subaccount.
    public func fromPrincipal(p : Principal, subAccount : ?SubAccount) : AccountIdentifier {
        fromBlob(Principal.toBlob(p), subAccount);
    };

    public func fromBlob(data : Blob, subAccount : ?SubAccount) : AccountIdentifier {
        fromArray(Blob.toArray(data), subAccount);
    };

    public func fromArray(data : [Nat8], subAccount : ?SubAccount) : AccountIdentifier {
        Blob.fromArray(AccountIdentifier.addHash(AccountIdentifier.fromArray(data, subAccount)))
    };
};
