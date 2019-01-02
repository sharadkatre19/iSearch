//
//  APIUtils.swift
//  iSearch
//
//  Created by Sharad Katre on 31/12/18.
//  Copyright © 2018 Sharad Katre. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    static let APIURL = "https://api.github.com/search/users?q=/@&page=/@"
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Router.APIURL)
        let urlRequest = URLRequest(url: url!)
        return urlRequest
    }
    
    case getSearchedUserList(_ searchedText: String, offSet: Int)
    
//    var method: Alamofire.HTTPMethod {
//        switch self {
//        case .getSearchedUserList:
//            return .get
//        }
//    }
//
//    internal var path: String {
//        switch self {
//        case .getSearchedUserList(let searchedText, let offSet):
//            let url = "https://api.github.com/search/users?q=sharad&page=1"
//            let updated = String(format: Router.APIURL, searchedText, offSet)
//            return url
//        }
//    }
}
