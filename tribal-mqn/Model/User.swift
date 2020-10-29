//
//  User.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation

// MARK: - User
struct User: Codable {
    let id: String?
    let updatedAt: String?
    let username, name, firstName: String
    let lastName, twitterUsername: String?
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let links: UserLinks?
    let profileImage: ProfileImage?
    let instagramUsername: String?
    let totalCollections, totalLikes, totalPhotos: Int?
    let acceptedTos: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location, links
        case profileImage = "profile_image"
        case instagramUsername = "instagram_username"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case acceptedTos = "accepted_tos"
    }
}

// MARK: User convenience initializers and mutators

extension User {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(User.self, from: data)
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
        id: String?? = nil,
        updatedAt: String = "",
        username: String?? = nil,
        name: String?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        twitterUsername: String?? = nil,
        portfolioURL: String?? = nil,
        bio: String?? = nil,
        location: String?? = nil,
        links: UserLinks?? = nil,
        profileImage: ProfileImage?? = nil,
        instagramUsername: String?? = nil,
        totalCollections: Int?? = nil,
        totalLikes: Int?? = nil,
        totalPhotos: Int?? = nil,
        acceptedTos: Bool?? = nil
    ) -> User {
        return User(
            id: id ?? self.id,
            updatedAt: updatedAt ?? self.updatedAt,
            username: (username ?? self.username) ?? "",
            name: (name ?? self.name) ?? "",
            firstName: (firstName ?? self.firstName) ?? "",
            lastName: lastName ?? self.lastName,
            twitterUsername: twitterUsername ?? self.twitterUsername,
            portfolioURL: portfolioURL ?? self.portfolioURL,
            bio: bio ?? self.bio,
            location: location ?? self.location,
            links: links ?? self.links,
            profileImage: profileImage ?? self.profileImage,
            instagramUsername: instagramUsername ?? self.instagramUsername,
            totalCollections: totalCollections ?? self.totalCollections,
            totalLikes: totalLikes ?? self.totalLikes,
            totalPhotos: totalPhotos ?? self.totalPhotos,
            acceptedTos: acceptedTos ?? self.acceptedTos
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
