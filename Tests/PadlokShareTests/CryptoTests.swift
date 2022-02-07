//
//  CryptoTests.swift
//
//
//  Created by Thomas Durand on 29/01/2022.
//

import CryptoSwift
import XCTest
@testable import PadlokShare

final class CryptoTests: XCTestCase {

    func testSealAndOpen() throws {
        let codable = ["Hello", "World", ChaCha20.randomIV(16).toBase64()]
        let sealed = try Crypto.seal(codable)
        let decoded: [String] = try Crypto.open(sealed)
        XCTAssertEqual(codable, decoded)
    }

    func testSealShouldCreateRandomKeyNonceAndPassphrase() throws {
        let codable = ["Hello", "World", ChaCha20.randomIV(16).toBase64()]
        let sealed1 = try Crypto.seal(codable)
        let sealed2 = try Crypto.seal(codable)
        XCTAssertNotEqual(sealed1.nonce.withUnsafeBytes({ Data(Array($0)) }), sealed2.nonce.withUnsafeBytes({ Data(Array($0)) }))
        XCTAssertNotEqual(sealed1.keyParameters.passphrase, sealed2.keyParameters.passphrase)
        XCTAssertNotEqual(sealed1.keyParameters.salt, sealed2.keyParameters.salt)
        XCTAssertNotEqual(sealed1.keyParameters.salt, sealed2.keyParameters.salt)
    }

    func testKeyTagAndNonceSizes() throws {
        let codable = ["Hello", "World", ChaCha20.randomIV(16).toBase64()]
        let sealed = try Crypto.seal(codable)
        XCTAssertEqual(sealed.nonce.count, AES.blockSize)
        XCTAssertEqual(try sealed.keyParameters.key().count, 32)
    }

    func testCombinedSealedData() throws {
        let codable = ["Hello", "World", ChaCha20.randomIV(16).toBase64()]
        let sealed = try Crypto.seal(codable)
        XCTAssertEqual(sealed.combined, sealed.nonce + sealed.cipher)
    }

    func testSealAndOpenExpectedFailures() throws {
        let codable = ["Hello", "World", ChaCha20.randomIV(16).toBase64()]
        let sealed = try Crypto.seal(codable)
        // Wrong type
        XCTAssertThrowsError(try Crypto.open(sealed) as [String: String]) { error in
            guard let error = error as? DecodingError else {
                XCTFail("Error is not a DecodingError, got \(type(of: error)) instead.")
                return
            }
            if case .typeMismatch = error {} else {
                XCTFail("Error is not a DecodingError.typeMismatch")
            }
        }
        // Wrong key
        let otherKey = Crypto.SealedBoxAndPassphrase(key: try .generate(), cipher: sealed.cipher, nonce: sealed.nonce)
        XCTAssertThrowsError(try Crypto.open(otherKey) as [String])
        // Wrong passphrase
        let wrongPassphrase = Crypto.SealedBoxAndPassphrase(key: .init(passphrase: otherKey.keyParameters.passphrase, salt: sealed.keyParameters.salt, iterations: sealed.keyParameters.iterations), cipher: sealed.cipher, nonce: sealed.nonce)
        XCTAssertThrowsError(try Crypto.open(wrongPassphrase) as [String])
    }

    func testRandomPassphrase() throws {
        let key1 = try Crypto.KeyParameters.generate()
        let key2 = try Crypto.KeyParameters.generate()
        XCTAssertNotEqual(try key1.key(), try key2.key())
        XCTAssertNotEqual(key1.passphrase, key2.passphrase)
    }
}
