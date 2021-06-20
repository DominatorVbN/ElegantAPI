# ``ElegantAPI/API``

## Usage

**You can use the API like:**

```swift
enum MyAPI {
   case getProfile(profileId: Int)
   case updateProfile(profileId: Int, profile: Profile)
   case getAbout
}

extesion MyAPI {

   var baseURL: URL {
       URL(string: "https://somehost.com")!
   }

   var path: String {
       switch self {
           case .getProfile(let profileId),
           .updateProfile(let profileId, _):
               return "profile/\(profileId)"
           case getAbout:
               return "about"
       }
   }

   var method: Method {
       switch self {
           case .getProfile:
               return .get
           case .updateProfile:
               return "profile/\(profileId)"
           case getAbout:
               return "about"
       }
   }

   var sampleData: Data {
       Data()
   }

   var task: Task {
       switch self {
           case .getProfile,
                .getAbout:
               return .requestPlain
           case .updateProfile(_, profile):
               return .requestJSONEncodable(profile)
       }
   }

   var headers: [String: String]? {
       switch self {
           case .getProfile,
                .getAbout:
               return nil
           case .updateProfile(_, profile):
               return ["Authorization": Authmanager.getKey]
       }
   }

}
```


- Important: ``API/getURLRequest()-86qkv`` Is not to be implemented in conforming type the default implementation is already provided

## Topics

### Creating an request

- <doc:GettingStarted>
- ``API/getURLRequest()-86qkv``

### Types

- ``Method``
- ``Task``


