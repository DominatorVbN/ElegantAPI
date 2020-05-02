//
//  NSMutableData+.swift
//  SnapSponser
//
//  Created by dominator on 02/05/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

extension NSMutableData {
  public func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
