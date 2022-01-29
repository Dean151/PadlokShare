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
        do {
            // Should not work for different keys
            let other = try Crypto.open(sealed, using: SymmetricKey(size: .bits256), and: passphrase) as [String]
            XCTAssertNotEqual(codable, other)
        } catch {}
        do {
            // Should not work for different passphrase
            let other = try Crypto.open(sealed, using: key, and: try Crypto.randomPassphrase()) as [String]
            XCTAssertNotEqual(codable, other)
        } catch {}
    }

    func testRandomPassphrase() throws {
        for _ in 1...20 {
            let random1 = try Crypto.randomPassphrase()
            let random2 = try Crypto.randomPassphrase()
            XCTAssertEqual(16, random1.count)
            XCTAssertEqual(16, random2.count)
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
