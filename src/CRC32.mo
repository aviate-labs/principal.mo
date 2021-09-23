import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";

import util "util";

module CRC32 {
    // Returns the CRC-32 checksum of data using the IEEE polynomial.
    // @pre: data.size() < 16
    public func checksum(data : [Nat8]) : Nat32 {
        slicingUpdate(0, slicingTable(), data);
    };

    private func simpleUpdate(crc : Nat32, table: [Nat32], data : [Nat8]) : Nat32 {
        var u = ^crc;
        for (v in data.vals()) {
            u := table[Nat8.toNat(util.nat32ToNat8(u) ^ v)] ^ (u >> 8)
        };
        ^u;
    };

    private func slicingUpdate(crc : Nat32, table: [[Nat32]], data : [Nat8]) : Nat32 {
        if (data.size() == 0 ) { return crc;    };
        let u = if (data.size() >= 16) {
            var u = ^crc;
            var p = data;
            while (p.size() > 8) {
                u := ^(util.nat8ToNat32(data[0])       | util.nat8ToNat32(data[1]) << 8 |
                       util.nat8ToNat32(data[2]) << 16 | util.nat8ToNat32(data[3]) << 24);
                u := table[0][Nat8.toNat(p[7])]     ^ table[1][Nat8.toNat(p[6])]              ^ table[2][Nat8.toNat(p[5])]             ^ table[3][Nat8.toNat(p[4])] ^
                     table[4][Nat32.toNat(u >> 24)] ^ table[5][Nat32.toNat((u >> 16) & 0xFF)] ^ table[6][Nat32.toNat((u >> 8) & 0xFF)] ^ table[7][Nat32.toNat(u & 0xFF)];
                p := util.drop(p, 8);
            };
            ^u;
        } else { crc; };
        simpleUpdate(u, table[0], data);
    };

    let IEEE : Nat32 = 0xedb88320;
    
    private func simpleTable() : [var Nat32] {
        let t = Array.init<Nat32>(256, 0);
        for (i in Iter.range(0, 255)) {
            var crc = Nat32.fromNat(i);
            for (_ in Iter.range(0, 7)) {
                if ((crc & 1) == 1) {
                    crc := (crc >> 1) ^ IEEE;
                } else {
                    crc >>= 1;
                };
            };
            t[i] := crc;
        };
        t;
    };

    private func slicingTable() : [[Nat32]] {
        var t = Array.init<[var Nat32]>(8, Array.init<Nat32>(256, 0));
        t[0] := simpleTable();
        for (i in Iter.range(0, 255)) {
            var crc = t[0][i];
            for (j in Iter.range(1, 7)) {
                crc := t[0][Nat32.toNat(crc & 0xFF)] ^ (crc >> 8);
                t[j][i] := crc;
            };
        };
        Array.tabulate(t.size(), func (i : Nat) : [Nat32] {
            Array.freeze(t[i]);
        });
    };
};
