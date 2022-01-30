//
//  Crypto.swift
//
//
//  Created by Thomas Durand on 29/01/2022.
//

import Foundation

public enum Models {
    public struct Building: Codable {
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
    }

    public struct Coordinates: Codable {
        public let latitude: Double
        public let longitude: Double
    }

    public struct Door: Codable {
        public enum Label: Codable, Equatable {
            case door
            case gate
            case portal
            case custom(string: String)
        }
        public let label: Label
        public let code: String
    }
}
