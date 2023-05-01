//
//  Request.swift
//  CombineLatest
//
//  Created by Darshan on 01/05/23.
//

import Foundation

struct SignInRequest:Codable{
    var username, password :String
}

struct SignUpRequest:Codable{
    var email, password :String
}
struct ForgotPasswordRequest:Codable{
    var email:String
}
struct DeleteAccountRequest:Codable{
    var email:String
}
