//
//  Crypto.swift
//
//
//  Created by Thomas Durand on 29/01/2022.
//

import Foundation

public enum Models {
    public struct Building: Codable, Equatable {
        // Identifier
        public let identifier: UUID

        // Position
        public let address: String
        public let coordinates: Coordinates

        // Infos
        public let building: String?
        public let doors: [Door]
        public let intercom: String?
        public let staircase: String?
        public let floor: Int?
        public let moreInfos: String?

        public init(identifier: UUID, address: String, coordinates: Models.Coordinates, building: String?, doors: [Models.Door], intercom: String?, staircase: String?, floor: Int?, moreInfos: String?) {
            self.identifier = identifier
            self.address = address
            self.coordinates = coordinates
            self.building = building
            self.doors = doors
            self.intercom = intercom
            self.staircase = staircase
            self.floor = floor
            self.moreInfos = moreInfos
        }
    }

    public struct Coordinates: Codable, Equatable {
        public let latitude: Double
        public let longitude: Double

        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }

    public struct Door: Codable, Equatable {
        public enum Label: Codable, Equatable {
            case door
            case gate
            case portal
            case custom(string: String)
        }
        public let label: Label
        public let code: String

        public init(label: Models.Door.Label, code: String) {
            self.label = label
            self.code = code
        }
    }
}

// Test case

extension Models.Building {
    static var test: Models.Building {
        return .init(
            identifier: UUID(uuidString: "3357815D-BECA-477D-97F0-F89F93054CCC").unsafelyUnwrapped,
            address: "55 de la rue du Faubourg-Saint-Honoré",
            coordinates: .init(latitude: 48.869978342034287, longitude: 2.3165022395478303),
            building: "Principal",
            doors: [
                .init(label: .door, code: "AB23C"),
                .init(label: .gate, code: "P12BD"),
                .init(label: .portal, code: "GUARD"),
                .init(label: .custom(string: "Porte Jupiter"), code: "19B29B02")
            ],
            intercom: "M. le Président",
            staircase: "Principal",
            floor: 1,
            moreInfos: "Bureau du président"
        )
    }
}
