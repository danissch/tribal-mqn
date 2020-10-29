//
//  UserLinks.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation

// MARK: - UserLinks
struct UserLinks: Codable {
    let linksSelf, html, photos, likes: String?
    let portfolio, following, followers: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

// MARK: UserLinks convenience initializers and mutators

extension UserLinks {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserLinks.self, from: data)
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
        linksSelf: String?? = nil,
        html: String?? = nil,
        photos: String?? = nil,
        likes: String?? = nil,
        portfolio: String?? = nil,
        following: String?? = nil,
        followers: String?? = nil
    ) -> UserLinks {
        return UserLinks(
            linksSelf: linksSelf ?? self.linksSelf,
            html: html ?? self.html,
            photos: photos ?? self.photos,
            likes: likes ?? self.likes,
            portfolio: portfolio ?? self.portfolio,
            following: following ?? self.following,
            followers: followers ?? self.followers
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
