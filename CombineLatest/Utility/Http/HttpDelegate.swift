//
//  HttpDelegate.swift
//  CombineLatest
//
//  Created by Darshan on 02/05/23.
//

import Foundation

protocol HTTPDelegate{
    associatedtype RequestType
    associatedtype ResponseType
    func dataRequest(request:RequestType,completionHandler:@escaping (Result<ResponseType?,HTTPError>)->Void)
}
protocol HttpRequestDelegate:AnyObject{
    func httpRequest<T:Codable>(request:URLRequest,resultType:T.Type,completionHandler:@escaping (Result<T?,HTTPError>) -> Void)
}
protocol URLRequestDelegate:AnyObject{
    //Final Request
    func createURLRequest<T:Encodable>(data:T, type: RequestType,httpMethod:HttpMethod)->URLRequest?
    //URL Endpoint
    func getURL(type:RequestType)->URL?
}
protocol BaseURLDelegate:AnyObject{
    var kBaseURL:String {get}
    var isProduction : Bool {get}
    var kDebugBaseURL : String {get}
    var kProductionBaseURL : String {get}
}
