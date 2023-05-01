//
//  HttpUtility.swift
//  CombineLatest
//
//  Created by Darshan on 01/05/23.
//

import Foundation
import UIKit
//------ Read Me for Add New Request End Point -------- //
//1) Add URLEndPoint
//2) Update getRequestURL Based on endpoint
//3) Create URLRequest Based on endpoint type like post, get, delete or update

final class HttpUtility{
    static let shared:HttpUtility = {
        return HttpUtility()
    }()
    private init(){}
}
enum RequestType{
    case LogIn
    case SignUp
    case LogOut
    case ForgotPass
}
enum HttpMethod{
    static let post = "POST"
    static let get = "GET"
    static let delete = "DELETE"
    static let update = "UPDATE"
}
enum URLEndPoint{
    static let login = "\(Utill.shared.kBaseURL)/login"
    static let signUp = "\(Utill.shared.kBaseURL)/signup"
    static let logout = "\(Utill.shared.kBaseURL)/logout"
    static let forgotpass = "\(Utill.shared.kBaseURL)/forgotpass"
}

protocol HttpUtilityDelegate:AnyObject{
    //Final Request
    func createURLRequest<T:Encodable>(data:T,type:RequestType)->URLRequest?
    //URL Endpoint
    func getRequestURL(type:RequestType)->URL?
    //Request Type
    func postRequest<T:Encodable>(data:T,url:URL?)->URLRequest?
    func getRequest<T:Encodable>(data:T,url:URL?)->URLRequest?
    func deleteRequest<T:Encodable>(data:T,url:URL?)->URLRequest?
    func updateRequest<T:Encodable>(data:T,url:URL?)->URLRequest?
    
    
}
extension HttpUtility:HttpUtilityDelegate{
    
    func createURLRequest<T>(data: T, type: RequestType) -> URLRequest? where T : Encodable {
        switch type {
            case .LogIn:
                return self.postRequest(data: data, url: self.getRequestURL(type: .LogIn))
            case .LogOut:
                return self.postRequest(data: data, url: self.getRequestURL(type: .LogOut))
            case .SignUp:
                return self.postRequest(data: data, url: self.getRequestURL(type: .SignUp))
            case .ForgotPass:
                return self.postRequest(data: data, url: self.getRequestURL(type: .ForgotPass))
        }
    }
     func getRequestURL(type: RequestType) -> URL? {
        switch type {
            case .LogIn:
                return URL.init(string: URLEndPoint.login)
            case .SignUp:
                return URL.init(string: URLEndPoint.signUp)
            case .LogOut:
                return URL.init(string: URLEndPoint.logout)
            case .ForgotPass:
                return URL.init(string: URLEndPoint.forgotpass)
        }
    }
     func postRequest<T>(data:T, url: URL?) -> URLRequest? where T : Encodable{
        guard let url else {
            return nil
        }
        var postrequest = URLRequest.init(url: url)
        postrequest.httpMethod = HttpMethod.post
        do{
            let postData = try JSONEncoder().encode(data)
            postrequest.httpBody = postData
            return postrequest
        }catch{
            return nil
        }
    }
    func getRequest<T>(data: T, url: URL?) -> URLRequest? where T : Encodable {
        guard let url else {
            return nil
        }
        var getrequest = URLRequest.init(url: url)
        getrequest.httpMethod = HttpMethod.get
        do{
            let postData = try JSONEncoder().encode(data)
            getrequest.httpBody = postData
            return getrequest
        }catch{
            return nil
        }
    }
    func deleteRequest<T>(data: T,url: URL?) -> URLRequest? where T : Encodable {
        guard let url else {
            return nil
        }
        var deleterequest = URLRequest.init(url: url)
        deleterequest.httpMethod = HttpMethod.delete
        do{
            let postData = try JSONEncoder().encode(data)
            deleterequest.httpBody = postData
            return deleterequest
        }catch{
            return nil
        }
    }
    func updateRequest<T>(data: T, url: URL?) -> URLRequest? where  T : Encodable {
        guard let url else {
            return nil
        }
        var updateRequest = URLRequest.init(url: url)
        updateRequest.httpMethod = HttpMethod.update
        do{
            let postData = try JSONEncoder().encode(data)
            updateRequest.httpBody = postData
            return updateRequest
        }catch{
            return nil
        }
    }
}
