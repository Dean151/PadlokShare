//
//  ModelsTests.swift
//  
//
//  Created by Thomas Durand on 29/01/2022.
//

import Crypto
import XCTest
@testable import PadlokShare

final class ModelsTests: XCTestCase {

    func testRetrocompatibilityWithVersion1Json() throws {
        let passphrase = "DV9LX4CCoW2Y"
        let key = SymmetricKey(data: Data(base64Encoded: "HGp4M0KDdFKJg4U+BM5LvxNrUps+F8PraN+oe6PTWB8=")!)
        let sealed = try ChaChaPoly.SealedBox(combined: Data(base64Encoded: "49Gyk7tk5/qUnOrHW/p6l93r208MkKg7nGrj4mBha3J3+J3+eQp8PDuL2MnSjMX63pxHHI00dQPgTaT7NmL1IAhq8JKS6W7GJ1uutGiOwIuhQ+pMkHaG8CdOXwtMhFDYTtQBwVvlo4+e3jMZQHVZRrMqPJUJ6iEUvLNRu4pqrsuCLvgFYbRIXAsbpqAdxIstRq8EP3UWHwPhwcJVj3S1p+q2ZyjMSW3gSjweWMbhgtTwHt2Jb4VL64dXzZs97lo7VvZPGPnfRPCeCMISTYLLyX4HyBsCTmMgF9u6WMbV+9bt/eAgOHi4P7MZc2zDqrsSQ/sBusoz0nmFm+hqHI/ZW/hq642PQtgEby6Taoqz9DxSvnf1mVCOKVW+itFFhejS7hA+cCWMSFZi3ji2QcxZabzOUNau08xxyr0c+79cqXXod0e2pqk+2t/TTIoi/XaoXapLu/EbVnQwB5kvqQtyQR1qO59yDmBghYvMcpZXnk/yS0rm1DPqbWpJXOe6otFjbuDYqRIL1KI9stM+JrUVSgNe6185w0IzmqJuDmQw45VTSx9daiQqPM+jfdolNpA6l4p9JRIIr+jUKO3qdyMXF2FjLy4yTdhlMLel60+4R28VRzMu57zdx2t7frfmKhbW0FRQvPm3hGuyXiTJ5unT29DEDZ1HqsaaMqpdtB6INm4=")!)
        let building: Models.Building = try Crypto.open(sealed, using: key, and: passphrase)
        XCTAssertEqual(building.address, "55 de la rue du Faubourg-Saint-Honoré")
        XCTAssertEqual(building.coordinates.latitude, 48.869978342034287)
        XCTAssertEqual(building.coordinates.longitude, 2.3165022395478303)
        XCTAssertEqual(building.building, "Principal")
        XCTAssertEqual(building.intercom, "M. le Président")
        XCTAssertEqual(building.staircase, "Principal")
        XCTAssertEqual(building.floor, 1)
        XCTAssertEqual(building.doors.count, 4)
        XCTAssertEqual(building.doors[0].label, .door)
        XCTAssertEqual(building.doors[1].label, .gate)
        XCTAssertEqual(building.doors[2].label, .portal)
        XCTAssertEqual(building.doors[3].label, .custom(string: "Porte Jupiter"))
        XCTAssertEqual(building.doors[0].code, "AB23C")
        XCTAssertEqual(building.doors[1].code, "P12BD")
        XCTAssertEqual(building.doors[2].code, "GUARD")
        XCTAssertEqual(building.doors[3].code, "19B29B02")
    }
}
