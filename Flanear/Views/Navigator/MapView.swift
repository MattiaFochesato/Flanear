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
    
    public static let LANDMARKS = [
        LandmarkAnnotation(title: "Developer Academy", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.836210, longitude:  14.306480), type: .interests),
        
        
        LandmarkAnnotation(title: "Anfiteatro Campano", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 41.0843762, longitude:  14.2457775), type: .archeology),
        LandmarkAnnotation(title: "Anfiteatro Flavio", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8258836, longitude:  14.12313), type: .archeology),
        LandmarkAnnotation(title: "Catacombe di San Gaudioso", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8598015, longitude:  14.2445735), type: .archeology),
        LandmarkAnnotation(title: "Catacombe di San Gennaro", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8623398, longitude:  14.2439148), type: .archeology),
        LandmarkAnnotation(title: "Cimitero delle fontanelle", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8586733, longitude:  14.2365361), type: .archeology),
        LandmarkAnnotation(title: "Parco archeologico dei Campi Flegrei", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8163476, longitude:  14.083406), type: .archeology),
        LandmarkAnnotation(title: "Galleria Borbonica", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8329046, longitude:  14.2412065), type: .archeology),
        LandmarkAnnotation(title: "Mitreo di Santa Maria Capua Vetere", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 41.0802233, longitude:  14.2498751), type: .archeology),
        LandmarkAnnotation(title: "Parco Archeologico di Cuma", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8483884, longitude:  14.0516649), type: .archeology),
        LandmarkAnnotation(title: "Parco Archeologico di Pompei", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.7482714, longitude:  14.4798571), type: .archeology),
        LandmarkAnnotation(title: "Parco Archeologico di Ercolano", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.805878, longitude:  14.346821), type: .archeology),
        LandmarkAnnotation(title: "Scavi di Oplontis", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.7571667, longitude:  14.4503432), type: .archeology),
        LandmarkAnnotation(title: "Scavi di Stabia", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.7029848, longitude:  14.4967287), type: .archeology),
        LandmarkAnnotation(title: "Villa dei Papiri", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8066882, longitude:  14.3431347), type: .archeology),
        LandmarkAnnotation(title: "Macellum Tempio di Serapide", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8260997, longitude:  14.1182377), type: .archeology),
        
        LandmarkAnnotation(title: "Castel Sant’Elmo", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8444515, longitude: 14.2367064), type: .castle),

        LandmarkAnnotation(title: "Castel dell’Ovo", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8283157, longitude: 14.2454104), type: .castle),

        LandmarkAnnotation(title: "Castel Nuovo", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8384891, longitude: 14.2505254), type: .castle),

        LandmarkAnnotation(title: "Zoo di Napoli", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8237083, longitude: 14.1802383), type: .park),

        LandmarkAnnotation(title: "Lago D’Averno", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8388204, longitude: 14.0720213), type: .park),

        LandmarkAnnotation(title: "Villa Comunale di Napoli", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8327128, longitude: 14.231955), type: .park),

        LandmarkAnnotation(title: "Real bosco di Capodimonte", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8327074, longitude: 14.1990329), type: .park),

        LandmarkAnnotation(title: "Orto botanico di Napoli", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8614463, longitude: 14.2601225), type: .park),

        LandmarkAnnotation(title: "Parco Sommerso La Gaiola", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.7911624, longitude: 14.1845357), type: .park),

        LandmarkAnnotation(title: "Baia delle Rocce Verdi", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.7975102, longitude: 14.1966182), type: .park),

        LandmarkAnnotation(title: "Riserva Naturale Cratere degli Astroni", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8403296, longitude: 14.1571347), type: .park),

        LandmarkAnnotation(title: "Parco Nazionale del Vesuvio", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8281756, longitude: 14.4236582), type: .park),

        LandmarkAnnotation(title: "Parco Vergiliano a Piedigrotta", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.830317, longitude: 14.2157592), type: .park),

        LandmarkAnnotation(title: "Parco divertimenti Edenlandia", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8205878, longitude: 14.1803188), type: .park),

        LandmarkAnnotation(title: "Parco Archeologico del Pausilypon", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.7997699, longitude: 14.1745565), type: .park),

        LandmarkAnnotation(title: "Isola di Nisida", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.7963569, longitude: 14.1604614), type: .park),

        LandmarkAnnotation(title: "Certosa di San Martino", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.843609, longitude:  14.2385947), type: .museum),


        LandmarkAnnotation(title: "Città della scienza", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8051842, longitude:  14.1720904), type: .museum),


        LandmarkAnnotation(title: "Complesso monumentale di Santa Chiara", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8470768, longitude:  14.2504964), type: .museum),


        LandmarkAnnotation(title: "Complesso Museale Sant’Anna dei Lombardi", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.844926, longitude:  14.2485175), type: .museum),


        LandmarkAnnotation(title: "Complesso Museale Santa Maria La Nova", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8440416, longitude:  14.2508659), type: .museum),


        LandmarkAnnotation(title: "Museo Cappella Sansevero", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8492991, longitude:  14.2526897), type: .museum),


        LandmarkAnnotation(title: "Complesso monumentale San Lorenzo Maggiore", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8509218, longitude:  14.2556498), type: .museum),


        LandmarkAnnotation(title: "Palazzo Zevallos Stigliano", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8398134, longitude:  14.2464165), type: .museum),


        LandmarkAnnotation(title: "Museo Madre", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8551581, longitude:  14.2562745), type: .museum),


        LandmarkAnnotation(title: "Museo archeologico nazionale di Napoli", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8536025, longitude:  14.2483314), type: .museum),


        LandmarkAnnotation(title: "Museo civico Gaetano Filangieri", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8536025, longitude:  14.2483314), type: .museum),


        LandmarkAnnotation(title: "Museo del tesoro di San Gennaro", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8524302, longitude:  14.2573324), type: .museum),


        LandmarkAnnotation(title: "Museo di Capodimonte", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.867034, longitude:  14.248389), type: .museum),


        LandmarkAnnotation(title: "Palazzo reale di Napoli", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8365353, longitude:  14.2482471), type: .museum),


        LandmarkAnnotation(title: "Reggia di Caserta", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 41.0731682, longitude:  14.3250045), type: .museum),


        LandmarkAnnotation(title: "Museo Nazionale Ferroviario di Pietrarsa", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8217124, longitude:  14.319256), type: .museum),


        LandmarkAnnotation(title: "Museo Nazionale della Ceramica Duca di Martina", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8394614, longitude:  14.2278434), type: .museum),


        LandmarkAnnotation(title: "PAN - Palazzo delle Arti Napoli", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8368268, longitude:  14.2347497), type: .museum),


        LandmarkAnnotation(title: "Museo Pignatelli", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8344441, longitude:  14.2315285), type: .museum),


        LandmarkAnnotation(title: "Acquario di Napoli", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8327613, longitude:  14.2330797), type: .museum),


        LandmarkAnnotation(title: "Reggia di Portici", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8197559, longitude:  14.3389154), type: .museum),


        LandmarkAnnotation(title: "Borgo Marinari", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8281601, longitude: 14.246105), type: .interests),

        LandmarkAnnotation(title: "Fontana della Sirena", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.828933, longitude: 14.2178279), type: .interests),

        LandmarkAnnotation(title: "Spaccanapoli", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8500803, longitude: 14.2556051), type: .interests),

        LandmarkAnnotation(title: "San Gregorio Armeno", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8500804, longitude: 14.2556159), type: .interests),

        LandmarkAnnotation(title: "Piazza del plebiscito", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8358256, longitude: 14.2463891), type: .interests),

        LandmarkAnnotation(title: "Galleria Umberto I", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8384118, longitude: 14.2478449), type: .interests),

        LandmarkAnnotation(title: "Chiesa di San Domenico Maggiore", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: 40.8488841, longitude: 14.2522284), type: .interests),

        LandmarkAnnotation(title: "Via Toledo", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8428212, longitude:  14.2467153), type: .interests),

        LandmarkAnnotation(title: "Casina Vanvitelliana", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8196772, longitude:  14.0562193), type: .interests),

        LandmarkAnnotation(title: "Decumano Via dei Tribunali", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8515175, longitude:  14.2566386), type: .interests),

        LandmarkAnnotation(title: "Basilica Reale Pontificia San Francesco da Paola", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8351907, longitude:  14.2451203), type: .interests),

        LandmarkAnnotation(title: "Palazzo dello Spagnolo", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8567658, longitude:  14.2521248), type: .interests),

        LandmarkAnnotation(title: "Palazzo Sanfelice", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8576961, longitude:  14.2493137), type: .interests),

        LandmarkAnnotation(title: "Fontana del Gigante", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.829721, longitude:  14.2478937), type: .interests),

        LandmarkAnnotation(title: "Teatro San Carlo", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8374847, longitude:  14.2474438), type: .theater),

        LandmarkAnnotation(title: "Teatro Sannazaro", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8358838, longitude:  14.2413311), type: .theater),

        LandmarkAnnotation(title: "Teatro Politeama", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8348045, longitude:  14.2422952), type: .theater),

        LandmarkAnnotation(title: "Teatro Augusteo", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8374846, longitude:  14.247433), type: .theater),

        LandmarkAnnotation(title: "Teatro Mercadante", subtitle: "Description", coordinate: CLLocationCoordinate2D(latitude: 40.8397523, longitude:  14.251995), type: .theater),
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
        view.addAnnotations(MapView.LANDMARKS)
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
                
                #if DEBUG
                self.updateCamera(mapView)
                #endif
                
            })
        }
        
        /*#if targetEnvironment(simulator)
        if self.initialCenter == false {
            self.initialCenter = true
            self.updateCamera(mapView, updateHeading: true, forceUpdate: true)
        }
        #endif*/
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
        
        guard let annotation = view.annotation as? LandmarkAnnotation else {
            print("not our annotation")
            return
        }
        
        viewController.gotTo(place: annotation.getPlaceSearchItem())
        
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
        case castle = "castle"
    }
    
    func getPlaceSearchItem() -> PlaceSearchItem {
        return PlaceSearchItem(title: title!, description: type.rawValue, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
