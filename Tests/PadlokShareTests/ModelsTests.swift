//
//  ModelsTests.swift
//  
//
//  Created by Thomas Durand on 29/01/2022.
//

import XCTest
@testable import PadlokShare

final class ModelsTests: XCTestCase {

    func testRetrocompatibilityWithVersion1Json() throws {
        let key = Crypto.KeyParameters(passphrase: "K2lZHO6q6akZ", salt: Data(base64Encoded: "ZZ9kHI6uEyw=").unsafelyUnwrapped, iterations: 1000)
        let combined = Data(base64Encoded: "hI7vl1On13OSsr+cf7Y/2ue5k4+S3yvNaxdr2n0UAW0P3PpXGF9xytPd8wQ+jXpj0CGSiUqeVIQxYqm3X6JN2GObVHNvs9E88piLEe+Pie6W0ToEm25vzK6tEahpy8dijLbUeDvOVT6N18KBy5UW4I6sxo5EajwV8CrfM37YW4rOt/FTffjVrN1D0F2uJnD7GYn2lddb+bR+ZLDmVhKRklJNXpt9vhPllgq4GDgG7zHMseUGy01cvfcP+jUQYIDeu1yLufKEcZsnPK6HAGhMYQYMNkwS1ynGGbVbLtsRDsfOZTsBzAKsIfB1iePYB28NsBqWPzkUbMXT+jwCJyuEWmEZN9Ka4dCZ9/PEBbTaUbYKM/xUWpLJF/69aYvvKMzeQLKOPKlgKodpAIwkOiNhDiOFM0Ve0SRkaC+c4JO8/IGrmFOJhABBkOpUssVe2L33nymvprCqQo7sVTZgcWTizGPPzMHTiEB2wHF8AcvcCvO3eiyZSmqHCANAZ4D/shuBxlObi4/AUVMScqWI2eZ2Z7fM7EMP92ZsYEMUKk6NX9dpJqmdtrZR+bjqgEAnab2g7THf153YlxNWTVoxQbGjYk/VCl2BDDQRfKecelR/7d5hmpnfQbphZEeIe0vynl78VZlevugmUGkU0cg/ze835z4aZ7zX+zfg").unsafelyUnwrapped
        let building: Models.Building = try Crypto.open(.init(key: key, combined: combined))
        XCTAssertEqual(building, Models.Building.test)
    }
}
