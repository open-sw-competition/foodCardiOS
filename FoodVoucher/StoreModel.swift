//
//  JSONModel.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/09/01.
//

import Foundation

// api 파싱
struct StoreData: Codable {
    let response: Response
    
    struct Response: Codable {
        let body: Body
        
        struct Body: Codable {
            let items: [StoreItem]
            let totalCount: String
            let numOfRows: String
            let pageNo: String
        }
    }
}

// api 파싱
struct StoreItem: Codable {
    let mrhstNm: String     //가맹점명 엄마가 차려준 떡볶이
    let mrhstCode: String   //가맹점유형코드 1
    let ctprvnNm: String    //시도명 경기도
    let signguNm: String    //시군구명 의정부시
    let signguCode: String  //시군구코드 41150
    let rdnmadr: String     //소재지도로명주소 경기도 의정부시 신촌로 59
    let lnmadr: String     //소재지지번주소 경기도 의정부시 가능동 631-9번지
    let latitude: String     //위도 37.750508
    let longitude: String     //경도 127.041113
    let phoneNumber: String     //전화번호 031-879-5394
    let weekdayOperOpenHhmm: String     //평일운영시작시간 08:00
    let weekdayOperColseHhmm: String     //평일운영종료시간 21:00
    let satOperOperOpenHhmm: String     //토요일운영시작시각 08:00
    let satOperCloseHhmm: String     //토요일운영종료시각 21:00
    let holidayOperOpenHhmm: String     //일요일운영시작시각 00:00
    let holidayCloseOpenHhmm: String     //일요일운영종료시각 00:00
    let dlvrOperOpenHhmm: String     //배달시작시각 00:00
    let dlvrCloseOpenHhmm: String     //배달종료시각 00:00
    let referenceDate: String     //데이터기준일자 2021-05-12
}



//struct Store {
//    let lat: Double
//    let long: Double
//    let location: String
//    let nameOfStore: String
//    let rating: Float
//    let user: String
//}
