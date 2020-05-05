//
//  URLComponents+.swift
//  SnapSponser
//
//  Created by dominator on 16/04/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation
extension URLComponents{
    /// Adds parameter as url queries
    /// - Parameter parameters: parameter to encode
    public mutating func addQuery(parameters: [String:Any]){
        self.queryItems = self.queryItems ?? [] + parameters.map {
            if $0.1 is String{
                return URLQueryItem(name: $0.0, value: $0.1 as? String)
            }else if $0.1 is LosslessStringConvertible{
                return URLQueryItem(name: String($0.0), value: String($0.1 as! LosslessStringConvertible))
            }
        }
        .compactMap{$0}
    }
}
