//
//  AFSessionManager.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation
import Alamofire

class AFSessionManager:AFSessionManagerProtocol {
    
    var manager: Alamofire.SessionManager
    
    init(){
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        manager = Alamofire.SessionManager(configuration:URLSessionConfiguration.default)
    }
    
    func responseString(_ url: String,
                        method: HTTPMethod,
                        parameters: Parameters?,
                        enconding: ParameterEncoding,
                        completionHandler: @escaping (DataResponse<String>) -> Void) {
        manager.request(url,
                        method: method,
                        parameters: parameters,
                        encoding: enconding).responseString(completionHandler: completionHandler)
    }
    
}
