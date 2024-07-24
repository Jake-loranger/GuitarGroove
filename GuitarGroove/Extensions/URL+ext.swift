//
//  URL+ext.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/24/24.
//

import Foundation

extension URL {
    var creationDate: Date? {
        return try? FileManager.default.attributesOfItem(atPath: path)[.creationDate] as? Date
    }
}
