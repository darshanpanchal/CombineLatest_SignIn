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

//Creational SingleTon Pattern
final class HttpUtility:BaseURLDelegate{
    
    var kBaseURL: String
    var kDebugBaseURL: String
    var kProductionBaseURL: String
    var isProduction: Bool = false{
        didSet{
            kBaseURL = isProduction ? kProductionBaseURL : kDebugBaseURL
        }
    }
    static let shared:HttpUtility = {
        var httputill = HttpUtility()
        return httputill
    }()
    private init(){
        kBaseURL = "https://dummyjson.com/auth"
        kDebugBaseURL = "https://dummyjson.com/auth"
        kProductionBaseURL = "https://dummyjson.com/auth"
        isProduction = false
    }
    
   
}
//Final Request Call
extension HttpUtility:HttpRequestDelegate{
    func httpRequest<T>(request: URLRequest, resultType: T.Type, completionHandler: @escaping (Result<T?, HTTPError>) -> Void) where T : Decodable, T : Encodable {
        URLSession.shared.dataTask(with: request) { (data, httpUrlResponse, error) in
            if let data{
                do{
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(response))
                }catch{
                    completionHandler(.failure(.kCommonError))
                }
            }else if let error{
                completionHandler(.failure(error as? HTTPError ?? .kCommonError))
            }
        }.resume()
    }
}

//URLRequest Configuration
extension HttpUtility:URLRequestDelegate{
   
    func createURLRequest<T>(data: T, type: RequestType,httpMethod:HttpMethod) -> URLRequest? where T : Encodable {
        guard let url = self.getURL(type: type) else {
            return nil
        }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = String.init(describing: httpMethod)
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = 60
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do{
            let urlRequestData = try JSONEncoder().encode(data)
            urlRequest.httpBody = urlRequestData
            return urlRequest
        }catch{
            return nil
        }
    }
     func getURL(type: RequestType) -> URL? {
        switch type {
            case .LogIn:
                return URL.init(string: URLEndPoint.login)
            case .SignUp:
                return URL.init(string: URLEndPoint.signUp)
            case .LogOut:
                return URL.init(string: URLEndPoint.logout)
            case .ForgotPass:
                return URL.init(string: URLEndPoint.forgotpass)
            case .DeleteAccount:
                return URL.init(string: URLEndPoint.delete)
        }
    }
}
