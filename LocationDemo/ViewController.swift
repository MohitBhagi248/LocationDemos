

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate , UIGestureRecognizerDelegate {
    
    lazy var locationManager: CLLocationManager = {
            var manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBest
            return manager
        }()
    
    @IBOutlet weak var mapView : MKMapView! 
    var arrCoordinates = [CLLocationCoordinate2D]()
    var arrCoordinatesSecond = [CLLocationCoordinate2D]()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(tapGestureDetected(gesture:)))
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }
    
    
    
    
      
    
    
    
    
    @objc func tapGestureDetected(gesture : UITapGestureRecognizer) {
        let touchPoint = gesture.location(in:mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom:mapView)
        
        if arrCoordinates.count < 3 {
            if arrCoordinates.count == 0 {
                self.arrCoordinatesSecond.append(coordinates)
            }
            self.arrCoordinates.append(coordinates)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = self.getAnnotationTitle(count:arrCoordinates.count)
            mapView.addAnnotation(annotation)
        }
        
        if arrCoordinates.count > 1 {

            let routeLine = MKPolyline(coordinates:arrCoordinates, count:arrCoordinates.count)
            self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), animated: true)
            self.mapView.addOverlay(routeLine)
            
            if arrCoordinates.count == 3 {
                self.arrCoordinates.append(contentsOf: arrCoordinatesSecond)
                let routeLine = MKPolyline(coordinates:arrCoordinates, count:arrCoordinates.count)
                self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), animated: true)
                self.mapView.addOverlay(routeLine)
            }

        }
    }
    
    

    
    
    
    
    
    
    
    

    func getAnnotationTitle(count : Int) -> String {
        switch count {
        case 1:
            return " A"
        case 2:
            return "B"
        case 3:
            return " C"
            default:
            return  " "
        }
    }
    
    
    

    func locationManager(_ manager: CLLocationManager,
                             didChangeAuthorization status: CLAuthorizationStatus) {
            
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.first {
            let center = location.coordinate
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            
        self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
        }
        
        
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .green
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
   
    
    
}

