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
        let key = Crypto.KeyParameters(passphrase: "BYhngAXAZ5o0", salt: Data(base64Encoded: "kLpHPb2zsjo=").unsafelyUnwrapped, iterations: 1000)
        let combined = Data(base64Encoded: "rphyE9rfNKrLwupKCR7bSTTOxlm++joQFqiR8UOYfXKFw2D9oQ/bo1gtFFYwre7El4AUWyA64MatY6KVAhJu9EBErzMyIRM4ezZU76rovsbM27W20FEBRqIlE1msM92MirPTb6/koZhSp2vr1jH62fayfVwt2uckC5iRMLolxrFCylKxToi+qyXzr6KPETJR1Rzf9W5P1JmAC209nkoA6LduKKPYhiYguecmWawYdfJEmtmlnfMPZMTTGWrAgJ4yW/hxqeMqgSaFi5495FficfqlBx6eieH20NtW58BFt0uX4tGKLyHtJU/XVMeayOcV4cBHK87MToZNevRTtjf2zq8Pdk3YxerNOzPBDzeX17NJvq0s6mAGg5brQouwT/1GxYbWkDhUjb/ztJVm706ruGsUtqtk5ohtYW88J2lk/95qW0/GLhlzwaBEXEYXoUBmEp6nDuvDa86KG9JWmYwCaXnGezsEc64Qh1ZfsCtfDL+Xp2W4jqdKMPtgFwnC3jO+10uqr+iOuUktkU0dTC7UHKs1OPala4vY8Y0ZS54z062rrRbgp+gj5EBQh0yejZPfVoxU8ySfQoj6fmB7CFpuVP/dSutCTbIi0F8z8SjAwJgBSFreYyoHQPS7+7628TPcGUa57OGrXAWTa5Xz8+TiYyYek+jxkriaadHIeMj94QiqpbSMFHQ+dCuS1+zLsR3r").unsafelyUnwrapped
        let building: Models.Building = try Crypto.open(.init(key: key, combined: combined))
        XCTAssertEqual(building, Models.Building.test)
    }
}
