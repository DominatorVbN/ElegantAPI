# ElegantAPI

An URSessionDataTaskPublisher abstraction layer inspired by [Moya](https://github.com/Moya/Moya).

## Installation

Elegant api is available through Swift Package Manager

add this url to `File -> Swift Packages -> Add new Dependecy`

```
https://github.com/DominatorVbN/ElegantAPI.git
```

or

add the following as a dependency to your Package.swift:
```
.package(url: "https://github.com/DominatorVbN/ElegantAPI.git", .upToNextMajor(from: "0.0.9"))
```

## Usage

import ElegentAPI

``` swift
import ElegantAPI
```

You have to declare an enum representing your api endpoints

``` swift
enum APIEndpoint{
    case login(emailId: String, password: String)
    case getProfile
    case updateProfile(user: User)
    case changeProfileImage(profileImage: UIImage)
}
```

Implement the enum with protocol API which contains all the requirement 

``` swift
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
    
    var sampleData: Data {
        // for mocking requests
        Data()
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
And that's define your all api requests
Now to perform this request

## Using Combine
``` swift

guard let request = APIEndpoint.login.getURLRequest() else {return}

// NetworkLogger is an micro library included inside Elegant api for logging network response and requests
NetworkLogger.log(request: request)

let publisher = URLSession.shared.dataTaskPublisher(for: req)

publisher.map { output in
    NetworkLogger.log(data: output.data, response: output.response as? HTTPURLResponse, error: nil)
    return output
}.sink(
    receiveCompletion: { },
    receiveValue: { output in
        print(output.data)
    }
)

```

> You can also you the URLRequest for plain dataTask too.

