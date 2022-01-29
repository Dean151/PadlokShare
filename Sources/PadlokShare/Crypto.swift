//
//  Crypto.swift
//  
//
//  Created by Thomas Durand on 29/01/2022.
//

import Crypto
import Foundation

public enum Crypto {
    enum Errors: Error {
        case passphraseNotEncodableToUtf8
    }

    /// This function will only run on iOS devices anyway. It's about encoding the data, encrypting it.
    /// Note that the signing key is derived using  a passphrase that the server will ignore
    public static func seal<T: Encodable>(_ encodable: T) throws -> (ChaChaPoly.SealedBox, SymmetricKey, String) {
        let encoder = JSONEncoder()
        let data = try encoder.encode(encodable)
        let key = SymmetricKey(size: .bits256)
        let passphrase = try randomPassphrase()
        let signingKey = try derive(key, using: passphrase)
        let sealed = try ChaChaPoly.seal(data, using: signingKey, nonce: .init())
        return (sealed, key, passphrase)
    }

    /// This function will allow the server to decrypt data when required (webapp) ; or the iOS app to do so (AppClip, import...)
    /// The less the servers does, the best it is
    public static func open<T: Decodable>(_ sealed: ChaChaPoly.SealedBox, using key: SymmetricKey, and passphrase: String) throws -> T {
        let decoder = JSONDecoder()
        let signingKey = try derive(key, using: passphrase)
        let unsealed = try ChaChaPoly.open(sealed, using: signingKey)
        return try decoder.decode(T.self, from: unsealed)
    }

    /// Return a random passphrase that will be of use within the URL
    static func randomPassphrase() throws -> String {
        var passphrase: String
        repeat {
            let noise = SymmetricKey(size: .bits256).withUnsafeBytes {
                Data(Array($0))
                    .base64EncodedString()
                    .replacingOccurrences(of: "=", with: "")
                    .replacingOccurrences(of: "+", with: "")
                    .replacingOccurrences(of: "/", with: "")
            }
            passphrase = String(noise.prefix(16))
        } while passphrase.count < 16
        return passphrase
    }

    /// Derive a key using a passphrase
    static func derive(_ key: SymmetricKey, using passphrase: String) throws -> SymmetricKey {
        let info = key.withUnsafeBytes { Data(Array($0)) }
        guard let pseudoRandomKey = passphrase.data(using: .utf8) else {
            throw Errors.passphraseNotEncodableToUtf8
        }
        return HKDF<SHA256>.expand(pseudoRandomKey: pseudoRandomKey, info: info, outputByteCount: SymmetricKeySize.bits256.bitCount / 8)
    }
}
