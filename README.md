# ElegantAPI

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Build](https://github.com/DominatorVbN/ElegantAPI/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/DominatorVbN/ElegantAPI/actions/workflows/build.yml)

An URSessionDataTaskPublisher abstraction layer inspired by [Moya](https://github.com/Moya/Moya).

## Documentation

https://amitsamant.in/ElegantAPI/documentation/elegantapi/

## Installation

Elegant api is available through Swift Package Manager some change

add this url to `File -> Swift Packages -> Add new Dependecy`

```bash
https://github.com/DominatorVbN/ElegantAPI.git
```

or

add the following as a dependency to your Package.swift:
```swift
.package(url: "https://github.com/DominatorVbN/ElegantAPI.git", .upToNextMajor(from: "1.0.0"))
```

## Usage

import ElegentAPI

```swift
import ElegantAPI
```

You have to declare an enum representing your api endpoints

```swift
enum APIEndpoint {
    case login(emailId: String, password: String)
    case getProfile
    case updateProfile(user: User)
    case changeProfileImage(profileImage: UIImage)
}
```

Implement the enum with protocol API which contains all the requirement

```swift
extension APIEndpoint: API{

    var baseURL: URL {
        // You can provide diffrent base urls for diffrent endpoint enum cases
        URL(string: "<Your base URL>")!
    }
    
    // End point path
    var path: String {
    
        switch self {
        case login:
            return "login"
        case getProfile:
            return "get_profile"
        case updateProfile:
            return "update_profile"
        case changeProfileImage:
            return change_profile_image
        }
        
    }
    
    // HTTP method of endpoint
    var method: ElegantAPI.Method {

        switch self {
        case .login:
            return .post
        case .getProfile:
            return .get
        case .updateProfile:
            return .patch
        case changeProfileImage:
            return .put
        }

    }

    var task: Task {
        switch self {
        
        case .login(let email,let password):
            return .requestParameters(parameters: [
                "email": email,
                "password": password
            ], encoding: .JSONEncoded)
            
        case .getProfile:
            return .requestPlain
            
        case .updateProfile(let user):
            return .requestJSONEncodable(user)
            
        case .changeProfileImage(let image):
            var data: [MultipartFormData] = [
                MultipartFormData(
                    data: image.jpegData(compressionQuality: 0.4) ?? Data(),
                    name: "image",
                    fileName: "\(UUID().uuidString).png",
                    mimeType: "image/jpeg"
                )
            ]
            return .uploadMultipart(data)
            
        }
    }
    
    // Headers for request
    var headers: [String : String]? {
    
        switch self {
        case .login:
            return ["Content-Type": "application/json"]
        case .getProfile, .updateProfile, .changeProfileImage:
            return ["Authorization": "Bearer \(Persistance.shared.accessKey)"]
        }
        
    }
    
}

```

And that's it! You can define all API requests this way.

## Making Requests

### Using Async/Await

```swift
guard let request = APIEndpoint.login(emailId: "user@example.com", password: "password").getURLRequest() else { return }

// NetworkLogger is a micro library included inside Elegant API for logging network requests and responses
NetworkLogger.log(request: request)

do {
    let (data, response) = try await URLSession.shared.data(for: request)
    NetworkLogger.log(data: data, response: response as? HTTPURLResponse, error: nil)

    // Decode your response
    let result = try JSONDecoder().decode(YourResponseType.self, from: data)
    print(result)
} catch {
    print("Request failed: \(error)")
}
```

### Using Combine

```swift
guard let request = APIEndpoint.login(emailId: "user@example.com", password: "password").getURLRequest() else { return }

// NetworkLogger is a micro library included inside Elegant API for logging network requests and responses
NetworkLogger.log(request: request)

let publisher = URLSession.shared.dataTaskPublisher(for: request)

publisher
    .map { output in
        NetworkLogger.log(data: output.data, response: output.response as? HTTPURLResponse, error: nil)
        return output.data
    }
    .decode(type: YourResponseType.self, decoder: JSONDecoder())
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("Request failed: \(error)")
            }
        },
        receiveValue: { result in
            print(result)
        }
    )
```

> You can also use the URLRequest for plain dataTask too.
