//
//  ViewController.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/08/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //http://api.data.go.kr/openapi/tn_pubr_public_chil_wlfare_mlsv_api
    //?serviceKey=aeePAPF%2Bf5ixjqxv%2BQqAQ4V1bBUEGdNmG1fhThQIKQt%2FjElWHaGuPd9v0MH0Vmh9psHHrcU48IeGhhUYzmYlcQ%3D%3D
    //&pageNo=0&numOfRows=1000&type=json    (얘는 필수 파라미터)
    
    let url = "http://api.data.go.kr/openapi/tn_pubr_public_chil_wlfare_mlsv_api"
    
    let key = "serviceKey=aeePAPF%2Bf5ixjqxv%2BQqAQ4V1bBUEGdNmG1fhThQIKQt%2FjElWHaGuPd9v0MH0Vmh9psHHrcU48IeGhhUYzmYlcQ%3D%3D"
    
    let param = "&pageNo=1&numOfRows=135&type=json&signguCode=28260"
    
    var storeModelList: [StoreModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 지도에 표현하기
        
        // 데이터 가져오기 및 json parsing
        let urlString = "\(url)?\(key)\(param)"
        if let url = URL(string: urlString) {
            print(url)
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("\(error?.localizedDescription ?? "세션 에러")")
                    return
                }
                
                if let safeData = data {
                    //self.parseJSON(safeData)
                }
            }
            
            task.resume()
        }
        
        
    }
    
    func parseJSON(_ safeData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData: StoreData = try decoder.decode(StoreData.self, from: safeData)
            
            let count = decodedData.response.body.items.count
            
            //print("decodedData: \(decodedData.response.body.items)")
            //print("count:\(decodedData.response.body.items.count)")
            
            for i in 0..<count {
                let storeModel = StoreModel(mrhstNm: decodedData.response.body.items[i].mrhstNm,
                                            latitude: decodedData.response.body.items[i].latitude,
                                            longitude: decodedData.response.body.items[i].longitude,
                                            phoneNumber: decodedData.response.body.items[i].phoneNumber,
                                            id: String(decodedData.response.body.items[i].latitude.suffix(5)+decodedData.response.body.items[i].longitude.suffix(5)),
                                            rating: Float(0.0))
                
//                let storeModel = StoreModel(mrhstNm: decodedData.response.body.items[i].mrhstNm,
//                                            mrhstCode: decodedData.response.body.items[i].mrhstCode,
//                                            ctprvnNm: decodedData.response.body.items[i].ctprvnNm,
//                                            signguNm: decodedData.response.body.items[i].signguNm,
//                                            signguCode: decodedData.response.body.items[i].signguCode,
//                                            rdnmadr: decodedData.response.body.items[i].rdnmadr,
//                                            lnmadr: decodedData.response.body.items[i].lnmadr,
//                                            latitude: decodedData.response.body.items[i].latitude,
//                                            longitude: decodedData.response.body.items[i].longitude,
//                                            phoneNumber: decodedData.response.body.items[i].phoneNumber,
//                                            weekdayOperOpenHhmm: decodedData.response.body.items[i].weekdayOperOpenHhmm,
//                                            weekdayOperColseHhmm: decodedData.response.body.items[i].weekdayOperColseHhmm,
//                                            satOperOperOpenHhmm: decodedData.response.body.items[i].satOperOperOpenHhmm,
//                                            satOperCloseHhmm: decodedData.response.body.items[i].satOperCloseHhmm,
//                                            holidayOperOpenHhmm: decodedData.response.body.items[i].holidayOperOpenHhmm,
//                                            holidayCloseOpenHhmm: decodedData.response.body.items[i].holidayCloseOpenHhmm,
//                                            dlvrOperOpenHhmm: decodedData.response.body.items[i].dlvrOperOpenHhmm,
//                                            dlvrCloseOpenHhmm: decodedData.response.body.items[i].dlvrCloseOpenHhmm,
//                                            referenceDate: decodedData.response.body.items[i].referenceDate,
//                                            id: String(decodedData.response.body.items[i].latitude.suffix(5)+decodedData.response.body.items[i].longitude.suffix(5)))
                
                
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(storeModel)
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
                    //print(jsonString, terminator: ", ")
                }
                
                storeModelList.append(storeModel)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

