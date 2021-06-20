//
//  Encodable+.swift
//  ElegantAPI
//
//  Created by dominator on 02/05/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

/// Extension Encodable
public extension Encodable {
    /// Encodes the encodable object to Data
    /// - Returns: return encoded date
    func toJSONData()throws -> Data { try JSONEncoder().encode(self) }
    /// Encodes the encodable object to Data using provided encoder
    /// - Returns: return encoded date
    func toJSONData(_ encoder: JSONEncoder) throws -> Data {try encoder.encode(self)}
}
