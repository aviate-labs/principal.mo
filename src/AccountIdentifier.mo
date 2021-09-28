import Array "mo:base/Array";
import Binary "mo:encoding/Binary";
import Blob "mo:base/Blob";
import Hex "mo:encoding/Hex";
import Principal "mo:base/Principal";
import SHA256 "mo:sha/SHA256";

import CRC32 "CRC32";

module {
    public type AccountIdentifier = Text;
    public type SubAccount        = [Nat8];

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
        let hash = SHA256.sum224(Array.flatten<Nat8>([prefix, data, account]));
        let crc  = CRC32.checksum(hash);
        Hex.encode(Array.append<Nat8>(Binary.BigEndian.fromNat32(crc), hash));
    };
};
