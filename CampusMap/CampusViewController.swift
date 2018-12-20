//
//  CampusViewController.swift
//  CampusMap
//
//  Created by Chun on 2018/11/26.
//  Copyright © 2018 Nemoworks. All rights reserved.
//

import UIKit
import MapKit


class CampusViewController: UIViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let gotoView = popupView()
    var usrAnnotation:POIAnnotation? = nil
    
    var campus = Campus(filename: "Campus")
    var selectedOptions : [MapOptionsType] = []
    var curSelected : [POIType : Bool] = [
        .misc: false,
        .schoolBuilding: false,
        .firstAid: false,
        .food: false,
        .supermarket: false,
        .ride: false,
        .library: false,
        .moutain: false,
    ]
    var dstLoc:MKPlacemark? = nil
    var curLoc:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latDelta = campus.overlayTopLeftCoordinate.latitude - campus.overlayBottomRightCoordinate.latitude
        
        // Think of a span as a tv size, measure from one corner to another
        let span = MKCoordinateSpan.init(latitudeDelta: fabs(latDelta), longitudeDelta: 0.0)
        let region = MKCoordinateRegion.init(center: campus.midCoordinate, span: span)
        
        mapView.region = region
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            print("定位不可用")
        }
        
        loadSelectedOptions()
        gotoView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        var loc = view.center
        loc.y = view.frame.height - gotoView.frame.height
        gotoView.center = loc
        gotoView.alpha = 0.7
        gotoView.Map = self
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? MapOptionsViewController)?.selectedOptions = selectedOptions
    }
    
    
    // MARK: Helper methods
    func loadSelectedOptions() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        for (x,y) in curSelected{
            curSelected[x] = false
        }
        for option in selectedOptions {
            switch (option) {
            case .mapBoundary:
                self.addBoundary()
            case .library:
                curSelected[.library] = true
            case .food:
                curSelected[.food] = true
            case .buildings:
                curSelected[.schoolBuilding] = true
            case .supermarket:
                curSelected[.supermarket] = true
            case .firstaid:
                curSelected[.firstAid] = true
            case .sport:
                curSelected[.ride] = true
            case .mountain:
                curSelected[.moutain] = true
            }
        }
        addPOIs()
    }
    
    
    @IBAction func closeOptions(_ exitSegue: UIStoryboardSegue) {
        guard let vc = exitSegue.source as? MapOptionsViewController else { return }
        selectedOptions = vc.selectedOptions
        loadSelectedOptions()
    }
    
    
    //    func addOverlay() {
    //        let overlay = ParkMapOverlay(park: park)
    //        mapView.addOverlay(overlay)
    //    }
    //
    
    func addBoundary() {
        mapView.addOverlay(MKPolygon(coordinates: campus.boundary, count: campus.boundary.count))
    }
    
    func addPOIs() {

        if(usrAnnotation != nil){
            mapView.addAnnotation(usrAnnotation!)
        }
        
        guard let pois = Campus.plist("CampusPOI") as? [[String : String]] else { return }
        
        for poi in pois {
            let coordinate = Campus.parseCoord(dict: poi, fieldName: "location")
            let title = poi["name"] ?? ""
            let typeRawValue = Int(poi["type"] ?? "0") ?? 0
            let type = POIType(rawValue: typeRawValue) ?? .misc
            if curSelected[type] ?? true{
                let subtitle = poi["subtitle"] ?? ""
                let annotation = POIAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        mapView.mapType = MKMapType.init(rawValue: UInt(sender.selectedSegmentIndex)) ?? .standard
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last ?? "default")
        curLoc = MKPlacemark(coordinate: (locations.last?.coordinate)!)
        if usrAnnotation != nil{
            mapView.removeAnnotation(usrAnnotation!)
        }
        print("update loc")
        usrAnnotation = POIAnnotation(coordinate: (locations.last?.coordinate)!, title: "我的位置", subtitle: "", type: .loc)
        mapView.addAnnotation(usrAnnotation!)
    }
    
    
    //MARK: Methods
    func Navigate(){
        if(dstLoc == nil || curLoc == nil){
            return
        }
//        locationManager.requestLocation()
//        let startlmk = MKPlacemark(coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(32.109798), CLLocationDegrees(118.961168)))
        let startItem = MKMapItem(placemark: curLoc!)
        let endItem = MKMapItem(placemark: dstLoc!)
        let request = MKDirections.Request()
        request.source = startItem
        request.destination = endItem
        let directions = MKDirections(request: request)
        directions.calculate{
            (response:MKDirections.Response?, error: Error?) in
            if error == nil{
                for route in (response?.routes)!{
                    self.mapView.addOverlay(route.polyline)
                }
            }
        }
    }
    func showGoto(_ dst:CLLocationCoordinate2D){
        dstLoc = MKPlacemark(coordinate: dst)
        view.addSubview(gotoView)
        
    }
    func removeGoto(){
        gotoView.removeFromSuperview()
        loadSelectedOptions()
    }
}


// MARK: - MKMapViewDelegate
extension CampusViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.red
            lineView.lineWidth = CGFloat(1.0)
            return lineView
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.blue
            polygonView.lineWidth = CGFloat(3.0)
            return polygonView
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = POIAnnotationView(annotation: annotation, reuseIdentifier: "POI")
        if(annotation.title == "我的位置"){
            annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        annotationView.fatherView = self
        annotationView.canShowCallout = true
        return annotationView
    }
    
}
