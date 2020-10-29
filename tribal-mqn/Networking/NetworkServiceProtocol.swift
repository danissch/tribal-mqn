//
//  NetworkServiceProtocol.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation
import Alamofire

enum ServiceResult<T> {
    case Success(T, Int)
    case Error(String, Int?)
}

protocol NetworkServiceProtocol {
    func request(url:String,
                 method:HTTPMethod,
                 parameters:Parameters?,
                 complete: @escaping(ServiceResult<String?>) -> Void)
}
