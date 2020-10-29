//
//  Photo.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let id: String?
    let createdAt, updatedAt: String?
    let promotedAt: String?
    let width, height: Int?
    let color, blurHash: String?
    let photoDescription: String?
    let altDescription: String?
    let urls: Urls?
    let links: PhotoLinks?
    let categories: [JSONAny]?
    let likes: Int?
    let likedByUser: Bool?
    let currentUserCollections: [JSONAny]?
    let sponsorship: Sponsorship?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
        case photoDescription = "description"
        case altDescription = "alt_description"
        case urls, links, categories, likes
        case likedByUser = "liked_by_user"
        case currentUserCollections = "current_user_collections"
        case sponsorship, user
    }
}

// MARK: Photo convenience initializers and mutators

extension Photo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Photo.self, from: data)
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
        createdAt: String?? = nil,
        updatedAt: String?? = nil,
        promotedAt: String?? = nil,
        width: Int?? = nil,
        height: Int?? = nil,
        color: String?? = nil,
        blurHash: String?? = nil,
        photoDescription: String?? = nil,
        altDescription: String?? = nil,
        urls: Urls?? = nil,
        links: PhotoLinks?? = nil,
        categories: [JSONAny]?? = nil,
        likes: Int?? = nil,
        likedByUser: Bool?? = nil,
        currentUserCollections: [JSONAny]?? = nil,
        sponsorship: Sponsorship?? = nil,
        user: User?? = nil
    ) -> Photo {
        return Photo(
            id: id ?? self.id,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            promotedAt: promotedAt ?? self.promotedAt,
            width: width ?? self.width,
            height: height ?? self.height,
            color: color ?? self.color,
            blurHash: blurHash ?? self.blurHash,
            photoDescription: photoDescription ?? self.photoDescription,
            altDescription: altDescription ?? self.altDescription,
            urls: urls ?? self.urls,
            links: links ?? self.links,
            categories: categories ?? self.categories,
            likes: likes ?? self.likes,
            likedByUser: likedByUser ?? self.likedByUser,
            currentUserCollections: currentUserCollections ?? self.currentUserCollections,
            sponsorship: sponsorship ?? self.sponsorship,
            user: user ?? self.user
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
