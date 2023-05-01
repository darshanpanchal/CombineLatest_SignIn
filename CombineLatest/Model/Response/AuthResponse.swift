//
//  LogInResponse.swift
//  CombineLatest
//
//  Created by Darshan on 01/05/23.
//

import Foundation

struct SignInResponse:Codable{
        let id : CustomType?
        let username : String?
        let email : String?
        let firstName : String?
        let lastName : String?
        let gender : String?
        let image : String?
        let token : String?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case username = "username"
            case email = "email"
            case firstName = "firstName"
            case lastName = "lastName"
            case gender = "gender"
            case image = "image"
            case token = "token"
        }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(CustomType.self, forKey: .id)
            username = try values.decodeIfPresent(String.self, forKey: .username)
            email = try values.decodeIfPresent(String.self, forKey: .email)
            firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
            lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
            gender = try values.decodeIfPresent(String.self, forKey: .gender)
            image = try values.decodeIfPresent(String.self, forKey: .image)
            token = try values.decodeIfPresent(String.self, forKey: .token)
        }
    
}
enum CustomType:Codable{
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        if let intValue = try? decoder.singleValueContainer().decode(Int.self){
            self = .int(intValue)
            return
        }
        if let stringvalue = try? decoder.singleValueContainer().decode(String.self){
            self = .string(stringvalue)
            return
        }
        throw TypeError.missingvalue
    }
    enum TypeError:Error{
        case missingvalue
    }
}
struct SignUpResponse:Codable{
    
}
struct ForgotPasswordResponse:Codable{
    
}
struct DeleteAccountResponse:Codable{
    
}
