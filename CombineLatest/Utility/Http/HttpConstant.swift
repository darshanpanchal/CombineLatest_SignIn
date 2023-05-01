//
//  HttpConstant.swift
//  CombineLatest
//
//  Created by Darshan on 02/05/23.
//

import Foundation


//All API endPoint
enum URLEndPoint{
    static let login = "\(HttpUtility.shared.kBaseURL)/login"
    static let signUp = "\(HttpUtility.shared.kBaseURL)/signup"
    static let logout = "\(HttpUtility.shared.kBaseURL)/logout"
    static let forgotpass = "\(HttpUtility.shared.kBaseURL)/forgotpass"
    static let delete = "\(HttpUtility.shared.kBaseURL)/deletAccount"
}
//Total Number of API Request
enum RequestType{
    case LogIn
    case SignUp
    case LogOut
    case ForgotPass
    case DeleteAccount
}
enum HttpMethod {
    case POST
    case GET
    case PUT
    case DELETE
    case PATCH
    case OPTIONS
}
enum HTTPError:Error{
    case kNoInternet
    case kCommonError
}
extension HTTPError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .kNoInternet:
            return NSLocalizedString(
                "Please check your internet connection",
                comment: ""
            )
        case .kCommonError:
            return NSLocalizedString(
                "Something Went Wrong!",
                comment: ""
            )
        }
    }
}
