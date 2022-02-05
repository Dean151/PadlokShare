//
//  CryptoTests.swift
//
//
//  Created by Thomas Durand on 29/01/2022.
//

import Crypto
import XCTest
@testable import PadlokShare

final class CryptoTests: XCTestCase {

    func testSealAndOpen() throws {
        let codable = ["Hello", "World", try Crypto.randomPassphrase()]
        let (sealed, key, passphrase) = try Crypto.seal(codable)
        let decoded: [String] = try Crypto.open(sealed, using: key, and: passphrase)
        XCTAssertEqual(codable, decoded)
    }

    func testSealShouldCreateRandomKeyNonceAndPassphrase() throws {
        let codable = ["Hello", "World", try Crypto.randomPassphrase()]
        let (sealed1, key1, passphrase1) = try Crypto.seal(codable)
        let (sealed2, key2, passphrase2) = try Crypto.seal(codable)
        XCTAssertNotEqual(sealed1.nonce.withUnsafeBytes({ Data(Array($0)) }), sealed2.nonce.withUnsafeBytes({ Data(Array($0)) }))
        XCTAssertNotEqual(key1, key2)
        XCTAssertNotEqual(passphrase1, passphrase2)
    }

    func testKeyTagAndNonceSizes() throws {
        let codable = ["Hello", "World", try Crypto.randomPassphrase()]
        let (sealed, key, _) = try Crypto.seal(codable)
        XCTAssertEqual(sealed.nonce.withUnsafeBytes({ Data(Array($0)) }).count, 12)
        XCTAssertEqual(sealed.tag.count, 16)
        XCTAssertEqual(key.withUnsafeBytes({ Data(Array($0)) }).count, 32)
    }

    func testCombinedSealedData() throws {
        let codable = ["Hello", "World", try Crypto.randomPassphrase()]
        let (sealed, _, _) = try Crypto.seal(codable)
        XCTAssertEqual(sealed.combined, sealed.nonce + sealed.ciphertext + sealed.tag)
    }

    func testSealAndOpenExpectedFailures() throws {
        let codable = ["Hello", "World", try Crypto.randomPassphrase()]
        let (sealed, key, passphrase) = try Crypto.seal(codable)
        XCTAssertThrowsError(try Crypto.open(sealed, using: SymmetricKey(size: .bits256), and: passphrase) as [String]) { error in
            guard error is CryptoKitError else {
                XCTFail("Error is not a CryptoKitError, got \(type(of: error)) instead.")
                return
            }
        }
        XCTAssertThrowsError(try Crypto.open(sealed, using: key, and: try Crypto.randomPassphrase()) as [String]) { error in
            guard error is CryptoKitError else {
                XCTFail("Error is not a CryptoKitError, got \(type(of: error)) instead.")
                return
            }
        }
        XCTAssertThrowsError(try Crypto.open(sealed, using: key, and: passphrase) as [String: String]) { error in
            guard let error = error as? DecodingError else {
                XCTFail("Error is not a DecodingError, got \(type(of: error)) instead.")
                return
            }
            if case .typeMismatch = error {} else {
                XCTFail("Error is not a DecodingError.typeMismatch")
            }
        }
    }

    func testRandomPassphrase() throws {
        for size in 6...16 {
            let random1 = try Crypto.randomPassphrase(of: size)
            let random2 = try Crypto.randomPassphrase(of: size)
            XCTAssertEqual(size, random1.count)
            XCTAssertEqual(size, random2.count)
            XCTAssertNotEqual(random1, random2)
        }
    }

    func testKeyDerivation() throws {
        // KeyDerivation should be the same for same keys/passphrase
        let key = SymmetricKey(size: .bits256)
        let passphrase = try Crypto.randomPassphrase()
        let reference = try Crypto.derive(key, using: passphrase)
        let derivedSameKeySamePassphrase = try Crypto.derive(key, using: passphrase)
        XCTAssertEqual(reference, derivedSameKeySamePassphrase)
        // Key size should be the same
        XCTAssertEqual(key.bitCount, reference.bitCount)
        // Different key, same passphrase
        let derivedDifferentKeySamePassphrase = try Crypto.derive(SymmetricKey(size: .bits256), using: passphrase)
        XCTAssertNotEqual(reference, derivedDifferentKeySamePassphrase)
        // Different passphrase should end with different result
        let derivedSameKeyDifferentPassphrase = try Crypto.derive(key, using: try Crypto.randomPassphrase())
        XCTAssertNotEqual(reference, derivedSameKeyDifferentPassphrase)
    }
}
