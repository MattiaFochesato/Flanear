//
//  MapView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 28/02/22.
//

import SwiftUI
import MapKit
import Combine

struct MapView: UIViewRepresentable {
    @EnvironmentObject var viewController: NavigatorViewController
    
    let landmarks = [
        LandmarkAnnotation(title: "Developer Academy", subtitle: "Description todo", coordinate: CLLocationCoordinate2D(latitude: 40.836210, longitude:  14.306480), type: .interests),
        
    ]
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(mapView: self, viewController: viewController)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true
        mapView.showsBuildings = false
        mapView.isPitchEnabled = false
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
        view.delegate = context.coordinator
        
        //If you changing the Map Annotation then you have to remove old Annotations
        //mapView.removeAnnotations(mapView.annotations)
        //passing model array here
        view.addAnnotations(landmarks)
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    private var degreesCancellable: AnyCancellable? = nil
    private var locationCancellable: AnyCancellable? = nil
    
    //var mapView: MKMapView? = nil
    var mapViewController: MapView!
    var viewController: NavigatorViewController!
    var initialCenter = false
    
    init(mapView: MapView, viewController: NavigatorViewController) {
        self.mapViewController = mapView
        self.viewController = viewController
        super.init()
    }
    
    /*func mapView(_ mapView: MKMapView, viewFor
                 annotation: MKAnnotation) -> MKAnnotationView?{
        //Custom View for Annotation
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")//MapAnnotationView(annotation: annotation, reuseIdentifier: "customView")
        //annotationView.canShowCallout = true
        //annotationView.rightCalloutAccessoryView =
        //Your custom image icon
        /*if let annotation = annotation as? LandmarkAnnotation {
         annotationView.image = UIImage(named: annotation.type.rawValue)
        }*/
        return annotationView
    }*/
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        /*if self.mapView == nil {
            self.mapView = mapView
        }*/
        if self.degreesCancellable == nil {
            self.degreesCancellable = LocationUtils.shared.$degrees.sink(receiveValue: { newHeading in
                self.updateCamera(mapView)
            })
        }
        if self.locationCancellable == nil {
            self.locationCancellable = LocationUtils.shared.$currentLocation.sink(receiveValue: { newLoc in
                
                if self.initialCenter == false {
                    self.initialCenter = true
                    self.updateCamera(mapView, updateHeading: false, forceUpdate: true)
                }
                
            })
        }
    }
    
    func updateCamera(_ mapView: MKMapView, updateHeading: Bool = true, forceUpdate: Bool = false) {
        /*guard let mapView = mapView else {
            return
        }*/
        mapView.showsUserLocation = (viewController.destinationName == nil)
        
        if viewController.destinationName == nil && !forceUpdate {
            return
        }
        
        let camera = MKMapCamera()
        if let currentLocation = LocationUtils.shared.currentLocation {
            camera.centerCoordinate = currentLocation.coordinate
        }
        camera.centerCoordinateDistance = 500
        if updateHeading {
            camera.heading = LocationUtils.shared.degrees
        }
        mapView.camera = camera
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect annotation")
        mapView.deselectAnnotation(view.annotation!, animated: false)
        
        guard let _ = view.annotation as? LandmarkAnnotation else {
            print("not our annotation")
            return
        }
        
        viewController.gotTo(place: PlaceSearchItem(title: view.annotation!.title! ?? "-", description: view.annotation!.subtitle! ?? "-", latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude))
        
        self.updateCamera(mapView)
    }
}

class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let type: LandmarkType
    init(title: String?,
         subtitle: String?,
         coordinate: CLLocationCoordinate2D,
         type: LandmarkType) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.type = type
    }
    
    enum LandmarkType: String {
        case archeology = "archeology"
        case interests = "interests"
        case museum = "museum"
        case park = "park"
        case theater = "theater"
    }
    
    func getPlaceSearchItem() -> PlaceSearchItem {
        return PlaceSearchItem(title: title!, description: subtitle!, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
