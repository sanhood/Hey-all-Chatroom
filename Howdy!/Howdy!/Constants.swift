//
//  Constants.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/3/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import Foundation
import UIKit

let screenSize = UIScreen.main.bounds.size
var nvc:UINavigationController = UINavigationController(rootViewController: UIViewController())

let baseURL = "http://localhost:3000"
let contentType = "application/json"
var myProfile: Profile!
enum HTTPHeaderField: String {
    case authentication = "auth"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

struct NetworkError {
    static func getError(statusCode:Int) -> String{
        switch statusCode {
        case 200:
            return ""
        default:
            return ""
        }
    }
}

