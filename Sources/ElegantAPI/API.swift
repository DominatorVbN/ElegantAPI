//
//  API.swift
//  ElegantAPI
//
//  Created by dominator on 16/04/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation
import Combine

/// The protocol used to define the specifications necessary for a genarting an URLRequest
///  Some additional content
///  This protocol is intented to be implemented by an enum whoose cases reperesnt each endpoint of the api calls you want to make, and provide the requirement according to each case.
public protocol API {
    
    /// The request's base `URL`.
    var baseURL: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: Method { get }
    
    /// Provides stub data for use in testing.
    var sampleData: Data { get }
    
    /// The type of HTTP task to be performed.
    var task: Task { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    /// Genrates URLRequest combining all the properties of API protocol
    /// - Returns: Genrated URLRequest
    func getURLRequest() -> URLRequest?
}

public extension API{
    func getURLRequest() -> URLRequest? {
        let fullURL = baseURL.appendingPathComponent(self.path)
        var urlRequest = URLRequest(url: fullURL)
        
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.allHTTPHeaderFields = self.headers
        switch self.task {
        case .requestData(let data):
            urlRequest.httpBody = data
        case .requestJSONEncodable(let value):
            do{
                let data = try value.toJSONData()
                urlRequest.httpBody = data
            }catch{
                print(error)
                return nil
            }
        case .requestCompositeData(let bodyData,let urlParameters):
            guard urlRequest.addURLQuery(parameter: urlParameters) else {
                print("Unable to add query items.")
                return nil
            }
            urlRequest.httpBody = bodyData
        case .requestCompositeParameters(let bodyParameters,let bodyEncoding,let urlParameters):
            guard urlRequest.addURLQuery(parameter: urlParameters) else {
                print("Unable to add query items.")
                return nil
            }
            switch bodyEncoding {
            case .JSONEncoded:
                do{
                    let data = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
                    urlRequest.httpBody = data
                }catch{
                    print(error)
                    return nil
                }
            case .URLEncoded:
                guard urlRequest.addURLQuery(parameter: bodyParameters) else{
                    print("Unable to add query items.")
                    return nil
                }
            }
        case .requestPlain:
            break
        case .requestCustomJSONEncodable(let body, let encoder):
            do{
                let data = try body.toJSONData(encoder)
                urlRequest.httpBody = data
            }catch{
                print(error)
                return nil
            }
        case .requestParameters(let parameters, let encoding):
            switch encoding {
            case .URLEncoded:
                guard urlRequest.addURLQuery(parameter: parameters) else{
                    print("Unable to add query items.")
                    return nil
                }
            case .JSONEncoded:
                do{
                    let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    urlRequest.httpBody = data
                }catch{
                    print(error)
                    return nil
                }
            }
        case .uploadMultipart(let array):
            urlRequest.addMultipart(multipart: array)
        case .uploadCompositeMultipart(let array,let urlParameters):
            urlRequest.addMultipart(multipart: array)
            guard urlRequest.addURLQuery(parameter: urlParameters) else{
                print("Unable to add query items.")
                return nil
            }
        }
        return urlRequest
    }
    

}
