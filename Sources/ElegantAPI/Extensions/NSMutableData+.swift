//
//  NSMutableData+.swift
//  ElegantAPI
//
//  Created by dominator on 02/05/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

public extension NSMutableData {
    /// Appends string to blob of Data
    /// - Parameter string: string to be appended in data
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
