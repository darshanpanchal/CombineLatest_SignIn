//
//  LogInDataResource.swift
//  CombineLatest
//
//  Created by Darshan on 01/05/23.
//

import Foundation


struct SignInDataResource:HTTPDelegate{
    
    typealias RequestType = SignInRequest
    typealias ResponseType = SignInResponse
    
    func dataRequest(request: SignInRequest, completionHandler: @escaping (Result<SignInResponse?, HTTPError>) -> Void) {
        guard let urlRequest = HttpUtility.shared.createURLRequest(data: request, type: .LogIn,httpMethod: .POST) else{
            completionHandler(.failure(.kCommonError))
            return
        }
        HttpUtility.shared.httpRequest(request: urlRequest, resultType: SignInResponse.self) { result in
            switch result{
                case .success(let response):
                    completionHandler(.success(response))
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
struct SignUpDataResource:HTTPDelegate{
    typealias RequestType = SignUpRequest
    typealias ResponseType = SignUpResponse
    
    func dataRequest(request: SignUpRequest, completionHandler: @escaping (Result<SignUpResponse?, HTTPError>) -> Void) {
        guard let urlRequest = HttpUtility.shared.createURLRequest(data: request, type: .SignUp,httpMethod: .POST) else{
            completionHandler(.failure(.kCommonError))
            return
        }
        HttpUtility.shared.httpRequest(request: urlRequest, resultType: SignUpResponse.self) { result in
            switch result{
                case .success(let response):
                    completionHandler(.success(response))
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}

struct ForgotPassDataResource:HTTPDelegate{
    typealias RequestType = ForgotPasswordRequest
    typealias ResponseType = ForgotPasswordResponse
    
    func dataRequest(request: ForgotPasswordRequest, completionHandler: @escaping (Result<ForgotPasswordResponse?, HTTPError>) -> Void) {
        guard let urlRequest = HttpUtility.shared.createURLRequest(data: request, type: .ForgotPass,httpMethod: .POST) else{
            completionHandler(.failure(.kCommonError))
            return
        }
        HttpUtility.shared.httpRequest(request: urlRequest, resultType: ForgotPasswordResponse.self) { result in
            switch result{
                case .success(let response):
                    completionHandler(.success(response))
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}

struct DeleteAccountDataResource:HTTPDelegate{
    typealias RequestType = DeleteAccountRequest
    typealias ResponseType = DeleteAccountResponse
    
    func dataRequest(request: DeleteAccountRequest, completionHandler: @escaping (Result<DeleteAccountResponse?, HTTPError>) -> Void) {
        guard let urlRequest = HttpUtility.shared.createURLRequest(data: request, type: .DeleteAccount,httpMethod: .DELETE) else{
            completionHandler(.failure(.kCommonError))
            return
        }
        HttpUtility.shared.httpRequest(request: urlRequest, resultType: DeleteAccountResponse.self) { result in
            switch result{
                case .success(let response):
                    completionHandler(.success(response))
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
