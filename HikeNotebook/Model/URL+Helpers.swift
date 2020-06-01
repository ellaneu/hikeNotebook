//
//  URL+Helpers.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 4/14/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
