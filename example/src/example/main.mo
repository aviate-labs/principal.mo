import Principal "mo:principal/Principal"

actor {
    let p = Principal.fromText("em77e-bvlzu-aq");
    assert(p == Principal.fromBlob(Principal.toBlob(p))); 
};
