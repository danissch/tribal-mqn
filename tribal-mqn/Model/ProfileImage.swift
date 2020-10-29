//
//  ProfileImage.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String?
}

// MARK: ProfileImage convenience initializers and mutators

extension ProfileImage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProfileImage.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        small: String?? = nil,
        medium: String?? = nil,
        large: String?? = nil
    ) -> ProfileImage {
        return ProfileImage(
            small: small ?? self.small,
            medium: medium ?? self.medium,
            large: large ?? self.large
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
