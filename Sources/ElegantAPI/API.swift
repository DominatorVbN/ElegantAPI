//
//  API.swift
//  SnapSponser
//
//  Created by dominator on 16/04/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation
import Combine

public protocol API {
    var baseURL: URL { get }
    var path: String { get }
    var method: Method { get }
    var sampleData: Data { get }
    var task: Task { get }
    var headers: [String: String]? { get }
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
