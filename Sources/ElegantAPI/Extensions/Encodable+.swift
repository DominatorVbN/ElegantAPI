//
//  Encodable+.swift
//  SnapSponser
//
//  Created by dominator on 02/05/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

extension Encodable {
    public func toJSONData()throws -> Data { try JSONEncoder().encode(self) }
    public func toJSONData(_ encoder: JSONEncoder) throws -> Data {try encoder.encode(self)}
}
