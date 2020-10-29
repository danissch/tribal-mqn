//
//  Sponsorship.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation

// MARK: - Sponsorship
struct Sponsorship: Codable {
    let impressionUrls: [String]?
    let tagline: String?
    let taglineURL: String?
    let sponsor: User?

    enum CodingKeys: String, CodingKey {
        case impressionUrls = "impression_urls"
        case tagline
        case taglineURL = "tagline_url"
        case sponsor
    }
}

// MARK: Sponsorship convenience initializers and mutators

extension Sponsorship {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Sponsorship.self, from: data)
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
        impressionUrls: [String]?? = nil,
        tagline: String?? = nil,
        taglineURL: String?? = nil,
        sponsor: User?? = nil
    ) -> Sponsorship {
        return Sponsorship(
            impressionUrls: impressionUrls ?? self.impressionUrls,
            tagline: tagline ?? self.tagline,
            taglineURL: taglineURL ?? self.taglineURL,
            sponsor: sponsor ?? self.sponsor
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
