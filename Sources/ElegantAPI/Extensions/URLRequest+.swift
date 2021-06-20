//
//  URLRequest+.swift
//  ElegantAPI
//
//  Created by dominator on 16/04/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

public extension URLRequest {
    
    /// Adds parameter as url queries
    /// - Parameter parameters: parameter to encode
    mutating func addURLQuery(parameter: [String: Any])-> Bool{
        guard let url = self.url else{ return false}
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.addQuery(parameters: parameter)
        guard let updatedUrl = urlComponents?.url else{return false}
        self.url = updatedUrl
        return true
    }
    
    /// Update the request to have multipart data
    /// - Parameter array: Array of mutipart data to be added
    mutating func addMultipart(multipart array: [MultipartFormData]){
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
    
    /// Creates data in formate of form data specification
    /// - Parameters:
    ///   - name: Name of field
    ///   - value: Value of field
    ///   - boundary: Data boundary of field
    /// - Returns: returns the formatted Data object
    func convertFormField(named name: String, value: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendString("\r\n")
        data.append(value)
        data.appendString("\r\n")
        return data as Data
    }
    
    /// Creates data in format of content desposition (mutipart file upload) specification
    /// - Parameters:
    ///   - fieldName: Name of field
    ///   - fileName: File name
    ///   - mimeType: File's mime type
    ///   - fileData: File's content
    ///   - boundary: Data boundary of field
    /// - Returns: returns the formatted data
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")
      return data as Data
    }
}
