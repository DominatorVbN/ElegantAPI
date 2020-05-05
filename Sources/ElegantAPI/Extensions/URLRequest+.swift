//
//  URLRequest+.swift
//  SnapSponser
//
//  Created by dominator on 16/04/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation
extension URLRequest{
    /// Adds parameter as url queries
    /// - Parameter parameters: parameter to encode
    public mutating func addURLQuery(parameter: [String: Any])-> Bool{
        guard let url = self.url else{ return false}
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.addQuery(parameters: parameter)
        guard let updatedUrl = urlComponents?.url else{return false}
        self.url = updatedUrl
        return true
    }
    
    public mutating func addMultipart(multipart array: [MultipartFormData]){
        let boundary = "Boundary-\(UUID().uuidString)"
        self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let httpBody = NSMutableData()
        for element in array{
            if let fileName = element.fileName,let mimeType = element.mimeType{
                httpBody.append(convertFileData(fieldName: element.name, fileName: fileName, mimeType: mimeType, fileData: element.data, using: boundary))
            }else{
                httpBody.append(convertFormField(named: element.name, value: element.data, using: boundary))
            }
        }
        self.httpBody = httpBody as Data
    }
    
    public func convertFormField(named name: String, value: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendString("\r\n")
        data.append(value)
        data.appendString("\r\n")
        return data as Data
    }
    
    public func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")
      return data as Data
    }
}
