//
//  HttpClient.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/08/26.
//

import Foundation

class HttpClient {
    private let baseUrl: String

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    //func getJson(path: String, params: [String: Any], completed: @escaping (Result<String, Error>) -> Void) {
//    func getJson(params: [String: Any], completed: @escaping (Result<String, Error>) -> Void) {
//        DispatchQueue.global(qos: .background).async {
//            let queryParams = params.map { k, v in "\(k)=\(v)" }.joined(separator: "&")
//
//            var fullPath = self.baseUrl
//            if !queryParams.isEmpty {
//                fullPath += "?" + queryParams
//            }
//
//            do {
//                //let json = try String(contentsOf: url!, encoding: .utf8)
//                if let url = URL(string: fullPath) {
//                    let json = try String(contentsOf: url)
//                    DispatchQueue.main.async {
//                        completed(Result.success(json))
//                    }
//                }
//            } catch {
//                print(error.localizedDescription)
//                DispatchQueue.main.async {
//                    completed(Result.failure(error))
//                }
//            }
//            
//
//            
//        }
//    }
}
