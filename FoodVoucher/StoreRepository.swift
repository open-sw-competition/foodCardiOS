//
//  StoreRepository.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/08/26.
//

import Foundation

class StoreRepository: NSObject {
    /**
     * 공공API
     * http://api.data.go.kr/openapi/tn_pubr_public_chil_wlfare_mlsv_api
     * http://api.data.go.kr/openapi/tn_pubr_public_chil_wlfare_mlsv_api?serviceKey=aeePAPF%2Bf5ixjqxv%2BQqAQ4V1bBUEGdNmG1fhThQIKQt%2FjElWHaGuPd9v0MH0Vmh9psHHrcU48IeGhhUYzmYlcQ%3D%3D&pageNo=0&numOfRows=100&type=xml&signguCode=45180
     *
     */

    
    
    private let httpClient = HttpClient(baseUrl: "http://api.data.go.kr/openapi/tn_pubr_public_chil_wlfare_mlsv_api")
    private let serviceKey =
        "aeePAPF%2Bf5ixjqxv%2BQqAQ4V1bBUEGdNmG1fhThQIKQt%2FjElWHaGuPd9v0MH0Vmh9psHHrcU48IeGhhUYzmYlcQ%3D%3D"
    
//    func list(completed: @escaping (StoreList) -> Void) {
//        httpClient.getJson(params: ["serviceKey": serviceKey, "numOfRows": 100, "pageNO": 1, "type": "json", "signguCode": "45180"]
//        ) { result in
//            if let json = try? result.get() {
//                completed(self.parseLectureList(jsonObject: self.JSONObject(json)))
//            }
//        }
//    }

//    func next(currentPage: StoreList, completed: @escaping (LectureList) -> Void) {
//        let nextPageUrl = currentPage.next
//        httpClient.getJson(path: nextPageUrl, params: [:]) { result in
//            if let json = try? result.get() {
//                completed(self.parseLectureList(jsonObject: self.JSONObject(json)))
//            }
//        }
//    }

//    func detail(courseId: String, completed: @escaping (Store) -> Void) {
//        httpClient.getJson(params: ["serviceKey": serviceKey, "numOfRows": 10, "pageNO": 1, "type": "json"]) { result in
//            if let json = try? result.get() {
//                print("detail:\(json)")
//                //completed(self.parseStore(jsonObject: self.JSONObject(json)))
//            }
//        }
//    }

    private func JSONObject(_ json: String) -> [String: Any] {
        let data = json.data(using: .utf8)!
        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return jsonObject
    }

//    private func parseLectureList(jsonObject: [String: Any]) -> StoreList {
//        return StoreList(count: (jsonObject["pagination"] as! [String: Any])["count"] as! Int,
//                           numPages: (jsonObject["pagination"] as! [String: Any])["num_pages"] as! Int,
//                           previous: (jsonObject["pagination"] as! [String: Any])["previous"] as? String ?? "",
//                           next: (jsonObject["pagination"] as! [String: Any])["next"] as? String ?? "",
//                           lectures: (jsonObject["results"] as! [[String: Any]]).map(parseStore))
//    }

//    private func parseStore(jsonObject: [String: Any]) -> Store {
//        return Store(mrhstNm: jsonObject["mrhstNm"] as? String,
//                     mrhstCode: jsonObject["mrhstCode"] as? String,
//                     ctprvnNm: jsonObject["ctprvnNm"] as? String,
//                     signguNm: jsonObject["signguNm"] as? String,
//                     signguCode: jsonObject["signguCode"] as? String,
//                     latitude: jsonObject["latitude"] as? Double,
//                     longitude: jsonObject["longitude"] as? Double,
//                     phoneNumber: jsonObject["phoneNumber"] as? String)
//    }
}
