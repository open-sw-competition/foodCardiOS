import UIKit
import GoogleMaps
import Firebase
import FirebaseDatabase //실시간 데이터베이스

//struct Item {
//    let rating: Int
//    let nameOfStore: String
//    let long: Double
//    let lat: Double
//    let location: Int
//}

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var defaultmapView: GMSMapView!
    let locationManager = CLLocationManager()
    var results: [StoreItem]? = []
    //var stores: [Item] = []    // 파이어베이스 결과(별점)
    var ref: DatabaseReference!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        ref = Database.database().reference()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
//            mapView.isMyLocationEnabled = true
//            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // 위치 접근 허가가 되지 않았을 때 디폴트 위도 경도 (인천 서구)
        let defaultLocation = CLLocation(latitude: 37.5655, longitude: 126.6773)
        
        // 지도 생성하기
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 14)
        defaultmapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        //defaultmapView.settings.myLocationButton = true
        defaultmapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        defaultmapView.isMyLocationEnabled = true

        // 위치 업데이트할때까지 기본 지도 보여주기
        view.addSubview(defaultmapView)
        mapView.isHidden = true
        
        defaultmapView.delegate = self
        
        // json 파일에서 데이터 가져오고 마커 생성하기
        if readFile() {
            makeMarker()
        }
        
        //updateRanking()
        
    }
    
    func readFile() -> Bool {
        guard let path = Bundle.main.path(forResource: "seogu", ofType: "json") else {
            return false
        }

        let url = URL(fileURLWithPath: path)

        do {
            let jsonData = try Data(contentsOf: url)
            let decodeddata: StoreData = try JSONDecoder().decode(StoreData.self, from: jsonData)
            let count = decodeddata.response.body.items.count
            let items = decodeddata.response.body.items

            for i in 0..<count {
                let storeItem = StoreItem(mrhstNm: items[i].mrhstNm, mrhstCode: items[i].mrhstCode, ctprvnNm: items[i].ctprvnNm,
                          signguNm: items[i].signguNm, signguCode: items[i].signguCode, rdnmadr: items[i].rdnmadr,
                          lnmadr: items[i].lnmadr, latitude: items[i].latitude, longitude: items[i].longitude,
                          phoneNumber: items[i].phoneNumber, weekdayOperOpenHhmm: items[i].weekdayOperOpenHhmm, weekdayOperColseHhmm: items[i].weekdayOperColseHhmm, satOperOperOpenHhmm: items[i].satOperOperOpenHhmm, satOperCloseHhmm: items[i].satOperCloseHhmm, holidayOperOpenHhmm: items[i].holidayOperOpenHhmm, holidayCloseOpenHhmm: items[i].holidayCloseOpenHhmm, dlvrOperOpenHhmm: items[i].dlvrOperOpenHhmm, dlvrCloseOpenHhmm: items[i].dlvrOperOpenHhmm, referenceDate: items[i].referenceDate)
                results?.append(storeItem)
            }
            return true
            
        } catch {
            print(error)
            return false
        }
    }
    
    // 리스너
//    func updateRanking() {
//        db.collection("rating").addSnapshotListener { querysnapshot, error in
//            self.stores = []
//
//            if let e = error {
//                print(e.localizedDescription)
//            } else {
//                if let snapShotDocuments = querysnapshot?.documents {
//                    for doc in snapShotDocuments {
//                        let data = doc.data()
//
//                        if let rating = data["rating"] as? Int {
//                            //print(rating)
//                            //print("점수")
//                        }
//
//                    }
//                }
//            }
//        }
//        //print(#function)
//    }
    
//    func makeMarker(_ stores: [Item]) {
//        // 마커 만들기
//        if let numOfStore = result?.data.count {
//            for item in 0..<numOfStore {
//                guard let store = result?.data[item] else {
//                    return
//                }
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: Double(store.latitude)!, longitude: Double(store.longitude)!)
//                marker.title = store.mrhstNm
//                marker.snippet = "\(store.phoneNumber)\n⭐️:\(store.rating)/5 (명)"
//                marker.map = defaultmapView
//            }
//        }
//        //print(#function)
//        //print("안오지?")
//    }
    
    func makeMarker() {
        if let numOfStore = results?.count {
            for item in 0..<numOfStore {
                guard let store = results?[item] else {
                    return
                }
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(store.latitude)!, longitude: Double(store.longitude)!)
                marker.title = store.mrhstNm
                marker.snippet = "\(store.phoneNumber)\n⭐️:/5 (명)"
                marker.map = defaultmapView
            }
        }
    }
    

}

// 이벤트
extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let contentVC = ControlVC()
        let alert = UIAlertController(title: nil, message: "별점을 입력해주세요", preferredStyle: .alert)
        alert.setValue(contentVC, forKey: "contentViewController")
        
        // 가게명 위도 경도 점수 총사람수 평점 전화번호 주소
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let rating = contentVC.sliderValue
            let latitude = marker.position.latitude
            let longitude = marker.position.longitude
            let snippet = marker.snippet
            let mrhstNm = (marker.title ?? "") as String
            
            if let user = Auth.auth().currentUser?.email {
                self.ref.child("ratings").child(mrhstNm).setValue(["rating":rating, "latitude":latitude, "longitude":longitude, "snippet":snippet, "mrhstNm":mrhstNm])
                let alert = UIAlertController(title: nil, message: "별점을 매겼습니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: false)
            }
        }
        alert.addAction(okAction)
        present(alert, animated: false)
    }
    
}

extension MapVC: CLLocationManagerDelegate {
    // 권한
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.requestLocation()

        // 현재 위치 버튼
        //mapView.isMyLocationEnabled = true
        //mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
