//
//  Urls.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String?
    let thumb: String?
}

// MARK: Urls convenience initializers and mutators

extension Urls {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Urls.self, from: data)
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
        raw: String?? = nil,
        full: String?? = nil,
        regular: String?? = nil,
        small: String?? = nil,
        thumb: String?? = nil
    ) -> Urls {
        return Urls(
            raw: raw ?? self.raw,
            full: full ?? self.full,
            regular: regular ?? self.regular,
            small: small ?? self.small,
            thumb: thumb ?? self.thumb
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
