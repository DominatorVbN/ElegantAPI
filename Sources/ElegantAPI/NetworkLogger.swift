//
//  NetworkLogger.swift
//  ElegantAPI
//
//  Created by dominator on 02/05/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

/// Utiliy class to log network events
open class NetworkLogger {
    
    /// Log's the outgoing url request
    /// - Parameter request: Request to be logged
    public class func log(request: URLRequest){

        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            let bodyString = body.prettyPrintedJSONString ?? String(data: body, encoding: String.Encoding.utf8) ?? "Can't render body; not utf8 encoded";
            requestLog += "\n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n";
        print(requestLog)
    }
    
    /// Log's the recieved server response
    /// - Parameters:
    ///   - data: Data coming from serevr
    ///   - response: Response coming from serevr
    ///   - error: Error coming from serevr
    public class func log(data: Data?, response: URLResponse?, error: Error?){

        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        if let httpResponse = response as? HTTPURLResponse{
            responseLog += "HTTP \(httpResponse.statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host{
            responseLog += "Host: \(host)\n"
        }
        for (key,value) in (response as? HTTPURLResponse)?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data{
            let bodyString = body.prettyPrintedJSONString ?? String(data: body, encoding: String.Encoding.utf8) ?? "Can't render body; not utf8 encoded";
            responseLog += "\n\(bodyString)\n"
        }
        if let error = error{
            responseLog += "\nError: \(error.localizedDescription)\n"
        }

        responseLog += "\n<------------------------\n";
        print(responseLog)
    }
    
}

public extension Data {
    /// Formats the data in indented style
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [JSONSerialization.WritingOptions.prettyPrinted]),
            let prettyPrintedString = String(data: data, encoding: String.Encoding.utf8)
            else{
                return nil
        }

        return prettyPrintedString
    }
}
