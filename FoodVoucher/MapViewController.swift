//
//  MapViewController.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/08/27.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    var result: Result?
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // json 파일 읽어오기
        readFile()
        
        //지금 보여지고 있는 지도
        let camera = GMSCameraPosition.camera(withLatitude: 37.55, longitude: 126.67, zoom: 11.5)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: self.view.frame.height/2), camera: camera)
        self.view.addSubview(mapView)
//        
//        // 현재 위치 가져오기
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        
//        // 앱이 실행될 때 위치 추적 권한 요청
//        locationManager.requestWhenInUseAuthorization()
//        // 배터리에 맞게 권장되는 최적의 정확도
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 50
//        // 위치 업데이트
//        locationManager.startUpdatingLocation()
//        
//        let coor = locationManager.location?.coordinate
//        
//        let latitude = (coor?.latitude ?? 37.566508) as Double
//        let longitude = (coor?.longitude ?? 126.977945) as Double
//        
        // 마커 만들기
        if let numOfStore = result?.data.count {
            for item in 0..<numOfStore {
                guard let store = result?.data[item] else {
                    return
                }
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(store.latitude)!, longitude: Double(store.longitude)!)
                marker.title = store.mrhstNm
                marker.snippet = "스니펫영역\n별점"
                marker.map = mapView
            }
        }

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

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location: CLLocation = locations.last!
      //print("Location: \(location)")

      //let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
      //let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude,zoom: zoomLevel)
//
//      if mapView.isHidden {
//        mapView.isHidden = false
//        mapView.camera = camera
//      } else {
//        mapView.animate(to: camera)
//      }
//
//      listLikelyPlaces()
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      // Check accuracy authorization
      let accuracy = manager.accuracyAuthorization
      switch accuracy {
      case .fullAccuracy:
          print("Location accuracy is precise.")
      case .reducedAccuracy:
          print("Location accuracy is not precise.")
      @unknown default:
        fatalError()
      }
      
      // Handle authorization status
      switch status {
      case .restricted:
        print("Location access was restricted.")
      case .denied:
        print("User denied access to location.")
        // Display the map using the default location.
        //mapView.isHidden = false
      case .notDetermined:
        print("Location status not determined.")
      case .authorizedAlways: fallthrough
      case .authorizedWhenInUse:
        print("Location status is OK.")
      @unknown default:
        fatalError()
      }
    }

    // Handle location manager errors.
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//      locationManager.stopUpdatingLocation()
//      print("엥?Error: \(error)")
//    }
}
