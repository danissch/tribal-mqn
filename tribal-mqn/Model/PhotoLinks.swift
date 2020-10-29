//
//  PhotoLinks.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation

// MARK: - PhotoLinks
struct PhotoLinks: Codable {
    let linksSelf, html, download, downloadLocation: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: PhotoLinks convenience initializers and mutators

extension PhotoLinks {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PhotoLinks.self, from: data)
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
        download: String?? = nil,
        downloadLocation: String?? = nil
    ) -> PhotoLinks {
        return PhotoLinks(
            linksSelf: linksSelf ?? self.linksSelf,
            html: html ?? self.html,
            download: download ?? self.download,
            downloadLocation: downloadLocation ?? self.downloadLocation
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
