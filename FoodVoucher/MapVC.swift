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
    lazy var ref: DatabaseReference = Database.database().reference()
    var ratingsRef: DatabaseReference!
    
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ratingsRef.observe(DataEventType.value) { snapshot in
            //self.makeMarker() 와 이렇게 만들면 숫자가 제대로 안들어가는데?
        }
    }
    
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
        
        ratingsRef = ref.child("ratings")
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

    
    func makeMarker() {
        if let numOfStore = results?.count {
            for item in 0..<numOfStore {
                guard let store = results?[item] else {
                    return
                }
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(store.latitude)!, longitude: Double(store.longitude)!)
                marker.title = store.mrhstNm
                
                // 이름이 mrhstNm인 총투표자수와 총점가져오기
                var ratingContributor: String = ""
                
                ref.child("ratings").child(store.mrhstNm).observe(.value) { snapshot in
                    if let dict = snapshot.value as? [String: AnyObject] {
                        
                        let rating = dict["rating"] as? Float ?? 0
                        let contributor = dict["contributor"] as? Int ?? 0
                        ratingContributor += String(rating) + "," + String(contributor)
                        
                        if ratingContributor == "" {
                            marker.snippet = "\(store.phoneNumber)\n⭐️:0.0/5 (0명)"
                        } else {
                            if ratingContributor == "," {
                                marker.snippet = "\(store.phoneNumber)\n⭐️:0.0/5 (0명)"
                            } else {
                                let rcArray = ratingContributor.components(separatedBy: ",")
                                let rating = rcArray[0]
                                let contributor = rcArray[1]
                                marker.snippet = "\(store.phoneNumber)\n⭐️:\(rating)/5 (\(contributor)명)"
                            }
                            
                        }
                    }
                    
                }
                
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
        
        let mrhstNm = (marker.title ?? "") as String
        let latitude = marker.position.latitude
        let longitude = marker.position.longitude
        let snippet = (marker.snippet ?? "") as String
        
        let array = snippet.split(separator: "\n")
        let phoneNumber = array[0]
        
        let ratingContributor = array[1].split(separator: " ")
        let ratingArray = ratingContributor[0].split(separator: ":")
        let rating = Float(ratingArray[1].split(separator: "/")[0])!

        let contributorString = ratingContributor[1].split(separator: "명")[0]
        let startInx = contributorString.index(contributorString.startIndex, offsetBy: 1)
        let contributor = Int(contributorString[startInx...])!
        
        // 가게명 위도 경도 점수 총사람수 평점 전화번호 주소
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in

            let ratingValue = contentVC.sliderValue
            let changedContributor = contributor + 1
            let changedRating = ((rating*Float(contributor))+ratingValue) / Float(changedContributor)
            let changedSnippet = "\(phoneNumber)\n⭐️:\(changedRating)/5 (\(changedContributor)명)"
            
            if let user = Auth.auth().currentUser?.email {
                self.ref.child("ratings").child(mrhstNm).setValue(["rating":changedRating, "latitude":latitude, "longitude":longitude, "snippet":changedSnippet, "mrhstNm":mrhstNm, "contributor":changedContributor])
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
