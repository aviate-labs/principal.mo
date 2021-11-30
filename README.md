# Principal

Provides a wrapper around the [base principal module](https://github.com/dfinity/motoko-base/blob/master/src/Principal.mo).

## Usage

You can add the package with [vessel](https://github.com/dfinity/vessel).

## Principals

### Functions

- `fromText`: creates a principal from its textual representation.
- `toText`: converts a principal to its textual representation.

- `fromBlob` (**NEW**): creates a principal from its binary representation.
- `toBlob`: converts a principal to its binary representation.

## Account Identifiers

It is recommended to use the `blob` subpackage if you do not need random access or mutation.

### Example

```motoko
let accountId = AccountIdentifier.fromPrincipal(p, null);
let aIdText   = AccountIdentifier.toText(ab);
assert(Hex.equal(aIdText, "a7218db708c35689495871c3c6860504503ab2a545630809dd8609130331b0c2"));
```

### `Text` vs. `[Nat8]` vs. `Blob`

1. `Text` is case-sensitive, if you choose to use it, make use to use `Hex.equal`.
2. `[Nat8]` has the same memory layout as other array, so is less compact as `Blob`.
3. `Blob` is the best choice if you do not need to access the underlying bytes.
