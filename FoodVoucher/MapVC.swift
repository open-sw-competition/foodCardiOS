import UIKit
import GoogleMaps
import Firebase

struct Item {
    let rating: Int
    let nameOfStore: String
    let long: Double
    let lat: Double
    let location: Int
}

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var defaultmapView: GMSMapView!
    let locationManager = CLLocationManager()
    var result: Result?     // json 결과
    var stores: [Item] = []    // 파이어베이스 결과(별점)
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
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
        defaultmapView.settings.myLocationButton = true
        defaultmapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        defaultmapView.isMyLocationEnabled = true

        // 위치 업데이트할때까지 기본 지도 보여주기
        view.addSubview(defaultmapView)
        mapView.isHidden = true
        
        defaultmapView.delegate = self
        
        readFile()
        
        updateRanking()
        
        makeMarker()
    }
    
    // 리스너
    func updateRanking() {
        db.collection("rating").addSnapshotListener { querysnapshot, error in
            self.stores = []
            
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snapShotDocuments = querysnapshot?.documents {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        
                        if let rating = data["rating"] as? Int,
                           let nameOfStore = data["nameOfStore"] as? String,
                           let long = data["long"] as? Double,
                           let lat = data["lat"] as? Double,
                           let location = data["location"] as? Int {
                            let newItem = Item(rating: rating, nameOfStore: nameOfStore, long: long, lat: lat, location: location)
                            self.stores.append(newItem)
                            
                            DispatchQueue.main.async {
                                self.makeMarker(self.stores)
                            }
                        }
                           
                    }
                }
            }
        }
        print(#function)
    }
    
    func makeMarker(_ stores: [Item]) {
        // 마커 만들기
        if let numOfStore = result?.data.count {
            for item in 0..<numOfStore {
                guard let store = result?.data[item] else {
                    return
                }
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(store.latitude)!, longitude: Double(store.longitude)!)
                marker.title = store.mrhstNm
                marker.snippet = "\(store.phoneNumber)\n⭐️:\(store.rating)/5 (\(stores.count)명)"
                marker.map = defaultmapView
            }
        }
        print(#function)
    }
    
    func makeMarker() {
        // 마커 만들기
        if let numOfStore = result?.data.count {
            for item in 0..<numOfStore {
                guard let store = result?.data[item] else {
                    return
                }
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(store.latitude)!, longitude: Double(store.longitude)!)
                marker.title = store.mrhstNm
                marker.snippet = "\(store.phoneNumber)\n⭐️:\(store.rating)/5 (\(stores.count)명)"
                marker.map = defaultmapView
            }
        }
        print(#function)
    }
    
    func readFile() {
        guard let path = Bundle.main.path(forResource: "seogu", ofType: "json") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode(Result.self, from: jsonData)
        } catch {
            print(error)
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
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let rating = contentVC.sliderValue
            let nameOfStore = (marker.title ?? "") as String
            let lat = marker.position.latitude
            let long = marker.position.longitude
            let id = String(lat).suffix(5)+String(long).suffix(5)
            if let user = Auth.auth().currentUser?.email {
                self.db.collection("rating").addDocument(data: [
                    "user":user,
                    "nameOfStore":nameOfStore,
                    "rating":rating,
                    "lat":lat,
                    "long":long,
                    "location":id
                ]) { error in
                    if let a  = error {
                        print("데이터입력에러: \(a.localizedDescription)")
                    } else {
                        let alert = UIAlertController(title: nil, message: "별점을 매겼습니다", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: false)
                    }
                }
            }
            
        }
        alert.addAction(okAction)
        present(alert, animated: false)
    }
    
    // 나의 위치 눌렀을 때
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        print("버튼 눌렀을 때 실행되나?")
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

////
////  MapVC.swift
////  FoodVoucher
////
////  Created by 임명심 on 2021/09/05.
////
//
//import UIKit
//import GoogleMaps
//import GooglePlaces
//
//class MapVC: UIViewController {
//
//    let locationManager = CLLocationManager()
//    @IBOutlet weak var mapView: GMSMapView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        locationManager.delegate = self     //현재위치
//        mapView.delegate = self
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestLocation()
//
//            mapView.isMyLocationEnabled = true
//            mapView.settings.myLocationButton = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//
//        let sydney = GMSCameraPosition.camera(
//            withLatitude: 37.55,
//            longitude: 126.67,
//            zoom: 6
//        )
//        mapView.camera = sydney
//
//        // 마커
//        //        let marker = GMSMarker()
//        //        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        //        marker.title = "Sydney"
//        //        marker.snippet = "Australia"
//        //        marker.map = mapView
//
//
//    }
//
//}
//
//// 이벤트
//extension MapVC: GMSMapViewDelegate {
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        //reverseGeocode(coordinate: position.target)
//    }
//
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
//    }
//}
//
//extension MapVC: CLLocationManagerDelegate {
//    // 권한
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        guard status == .authorizedWhenInUse else {
//            return
//        }
//
//        locationManager.requestLocation()
//
//        // 현재 위치 버튼
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            return
//        }
//
//        mapView.camera = GMSCameraPosition(
//            target: location.coordinate,
//            zoom: 6,
//            bearing: 0,
//            viewingAngle: 0
//        )
//    }
//
//    // Handle location manager errors.
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        print("Error: \(error)")
//    }
//}
