//
//  Crypto.swift
//  
//
//  Created by Thomas Durand on 29/01/2022.
//

import CryptoSwift
import Foundation

public enum Crypto {
    public struct SealedBoxAndPassphrase {
        let combined: Data
        let keyParameters: KeyParameters

        public init(key: KeyParameters, cipher: Data, nonce: Data) {
            precondition(nonce.count == AES.blockSize)
            self.combined = nonce + cipher
            self.keyParameters = key
        }

        public init(key: KeyParameters, combined: Data) {
            self.combined = combined
            self.keyParameters = key
        }

        var nonce: Data {
            combined[..<AES.blockSize]
        }
        var cipher: Data {
            combined[AES.blockSize...]
        }
    }

    public struct KeyParameters {
        public let passphrase: String
        public let salt: Data
        public let iterations: Int


        public init(passphrase: String, salt: Data, iterations: Int) {
            self.passphrase = passphrase
            self.salt = salt
            self.iterations = iterations
        }

        func key() throws -> [UInt8] {
            try PKCS5.PBKDF2(
                password: Array(passphrase.utf8),
                salt: salt.bytes,
                iterations: iterations
            ).calculate()
        }

        static func generate(count: Int = 12) throws -> Self {
            // 64 bits a.k.a 8 bytes is the minimum according to https://stackoverflow.com/questions/17218089/salt-and-hash-using-pbkdf2
            let salt: [UInt8] = AES.randomIV(8)
            return KeyParameters(passphrase: randomPassphrase(count: count), salt: Data(salt), iterations: 1000)
        }

        private static func randomPassphrase(count: Int = 12) -> String {
            var passphrase: String
            repeat {
                let noise = AES.randomIV(count).toBase64()
                    .replacingOccurrences(of: "=", with: "")
                    .replacingOccurrences(of: "+", with: "")
                    .replacingOccurrences(of: "/", with: "")
                passphrase = String(noise.prefix(count))
            } while passphrase.count < count
            return passphrase
        }
    }

    /// This function will only run on iOS devices anyway. It's about encoding the data, encrypting it.
    /// Note that the signing key is derived using  a passphrase that the server will ignore
    public static func seal<T: Encodable>(_ encodable: T, count: Int = 12) throws -> SealedBoxAndPassphrase {
        let encoder = JSONEncoder()
        let data = try encoder.encode(encodable)
        let parameters = try KeyParameters.generate(count: count)
        let nonce = AES.randomIV(AES.blockSize)
        let gcm = GCM(iv: nonce, mode: .combined)
        let cipher = try AES(key: try parameters.key(), blockMode: gcm, padding: .pkcs7).encrypt(data.bytes)
        return .init(key: parameters, cipher: Data(cipher), nonce: Data(nonce))
    }

    /// This function will allow the server to decrypt data when required (webapp) ; or the iOS app to do so (AppClip, import...)
    /// The less the servers does, the best it is
    public static func open<T: Decodable>(_ box: SealedBoxAndPassphrase) throws -> T {
        let gcm = GCM(iv: box.nonce.bytes, mode: .combined)
        let bytes = try AES(key: try box.keyParameters.key(), blockMode: gcm, padding: .pkcs7).decrypt(box.cipher.bytes)
        return try JSONDecoder().decode(T.self, from: Data(bytes))
    }
}
