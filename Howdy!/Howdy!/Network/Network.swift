//
//  Network.swift
//  Inbook
//
//  Created by Soroush Shahi on 7/27/18.
//  Copyright © 2018 Danoosh Chamani. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

enum ServerMethod {
    case getUserInfo(id:Int)
    case signup(email:String)
    case editProfile(dictionary:[String:Any])
    case getChatroomsByIDs(IDs:String)
    case getChatroomsByName(name:String)
    case getFavList(myID:Int)
    case favUser(leftID:Int,rightID:Int)
}

class Network {
    typealias RequestResponse = (data:JSON,status:Int,error:String?)
    typealias DownloadResponse = (data:Data,status:Int,fileIdentifier:String,error:String?)

    
    static func request(serverMethod:ServerMethod, completion: @escaping(RequestResponse)->()) {
        let urlRequest:URLRequestConvertible
        switch serverMethod {
        case .getUserInfo(let id):
            urlRequest = APIRouter.getUserInfo(id: id)
        case .signup(let email):
            urlRequest = APIRouter.signup(email: email)
        case .editProfile(let dictionary):
            urlRequest = APIRouter.editProfile(dictionary: dictionary)
        case .getChatroomsByIDs(let IDs):
            urlRequest = APIRouter.getChatroomsByIDs(IDs: IDs)
        case .getChatroomsByName(let name):
            urlRequest = APIRouter.getChatroomsByName(name: name)
        case .getFavList(let myID):
            urlRequest = APIRouter.getFavList(myID: myID)
        case .favUser(let leftID, let rightID):
            urlRequest = APIRouter.favUser(leftID: leftID, rightID: rightID)
        }
        
        Alamofire.request(urlRequest).responseJSON { (response) in
            
            switch response.result {
            case .success(let result) :
//                print(response.request?.urlRequest?.url)
                let json = JSON(result)
                let statusCode = response.response?.statusCode ?? -1
                let outputResponse:RequestResponse = (json,statusCode,NetworkError.getError(statusCode: statusCode))
                completion(outputResponse)
            case .failure(let error) :
                print(error)
                let outputResponse:RequestResponse = (JSON(),-1,error.localizedDescription)
                completion(outputResponse)
            }
        }
    }
    
}



    
    
    

