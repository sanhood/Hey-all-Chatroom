//
//  APIRouter.swift
//  Inbook
//
//  Created by Soroush Shahi on 7/27/18.
//  Copyright © 2018 Danoosh Chamani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIRouter : URLRequestConvertible {
    
    case getUserInfo(id:Int)
    case getChatroomsByIDs(IDs:String)
    case getChatroomsByName(name:String)
    case getFavList(myID:Int)
    case signup(email:String)
    case favUser(leftID:Int,rightID:Int)
    case editProfile(dictionary:[String:Any])
    case join_LeftChatroom(id:Int,isJoined:Bool)
    
    private var method: HTTPMethod {
        switch self {
        case .getUserInfo:
            return .get
        case .getChatroomsByIDs:
            return .get
        case .getChatroomsByName:
            return .get
        case .getFavList:
            return .get
        case .signup:
            return .post
        case .favUser:
            return .post
        case .editProfile:
            return .put
        case .join_LeftChatroom:
            return .put
        }
    }
    
    private var path: String {
        switch self {
        case .getUserInfo(let id):
            return "/userInfo/\(id)"
        case .getChatroomsByIDs:
            return "/getChatroomsByID"
        case .signup:
            return "/signup"
        case .editProfile:
            return "/editProfile"
        case .getChatroomsByName:
            return "/getChatroomsByName"
        case .getFavList:
            return "/getFavList"
        case.favUser:
            return "/favUser"
        case .join_LeftChatroom:
            return "/joinChatroom"
        }
    }
    
    private var parameters: Parameters?  {
        switch self {
        case .getUserInfo:
            return nil
        case .getChatroomsByIDs(let IDs):
            return ["IDs":IDs]
        case .signup:
            return nil
        case .editProfile:
            return nil
        case .getChatroomsByName(let name):
            return ["name":name]
        case .getFavList(let id):
            return ["id":id]
        case.favUser:
            return nil
        case .join_LeftChatroom:
            return nil
        }
    }
    
    private var bodyParameters : [String : Any]? {
        switch self {
        case .signup(let email):
            return ["email" : email]
        case .getUserInfo:
            return nil
        case . getChatroomsByIDs:
            return nil
        case .editProfile(let dictionary):
            return dictionary
        case .getChatroomsByName:
            return nil
        case .getFavList:
            return nil
        case.favUser(let leftID, let rightID):
            return ["leftID":leftID,"rightID":rightID]
        case .join_LeftChatroom(let id, let isJoined):
            return ["id":id,"isJoined":isJoined]
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        var u = URLComponents(url: try baseURL.asURL().appendingPathComponent(path), resolvingAgainstBaseURL: true)
        var urlRequest = URLRequest(url: u!.url!)
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        // Common Headers
        urlRequest.setValue(contentType, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(contentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        switch self {
        case .signup: print("")
        default:
            urlRequest.setValue(myProfile.token, forHTTPHeaderField:HTTPHeaderField.authentication.rawValue )
        }
        
        // Parameters
        if let parameters = parameters {
            var items = [URLQueryItem]()
            for (key,value) in parameters {
                if let v = value as? String {
                    items.append(URLQueryItem(name: key, value: v))
                    }
                else if let v = value as? Int {
                    items.append(URLQueryItem(name: key, value: String(v)))
                }
                else if let v = value as? Double {
                    items.append(URLQueryItem(name: key, value: String(v)))
                }
            }
            items = items.filter{!$0.name.isEmpty}
            if !items.isEmpty {
                u?.queryItems = items
            }
            urlRequest.url = u?.url
        }
        
        // Body Parameters
        if let bodyParams = bodyParameters {
            if let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams) {
                urlRequest.httpBody = jsonData
            }
            else {
                print("JSON serialization failed for URL : \(urlRequest.url?.absoluteString ?? "nil")")
            }
            
        }
        
        return urlRequest
    }
    
    
    
    
    
}

extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}
