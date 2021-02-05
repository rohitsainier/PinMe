//
//  ContentView.swift
//  PinMe
//
//  Created by Rohit Saini on 05/02/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var title: String = ""
    @State var subtitle: String = ""
    var body: some View {
        ZStack(alignment: .bottom){
            MapView(title: $title, subtitle: $subtitle).edgesIgnoringSafeArea(.all)
            if title != ""{
                HStack(spacing:12){
                    Image(systemName: "location.fill.viewfinder").font(.largeTitle).foregroundColor(.black)
                    VStack(alignment:.leading,spacing:10){
                        Text(title).fontWeight(.medium).foregroundColor(.black)
                        Text(subtitle).fontWeight(.medium).foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.bottom,30)
            }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapView:UIViewRepresentable{
    
    @Binding var title: String
    @Binding var subtitle: String
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        let coordinates = CLLocationCoordinate2D(latitude: 29.9695, longitude: 76.8783)
        map.region = MKCoordinateRegion(center:coordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        map.delegate = context.coordinator
        map.addAnnotation(annotation)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator:NSObject,MKMapViewDelegate{
        var parent: MapView
        init(parent: MapView){
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.tintColor = .yellow
            pin.animatesDrop = true
            return pin
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)) { (places, err) in
                if let err = err{
                    print(err)
                }
                else{
                    self.parent.title = places?.first?.name ?? "Loading..."
                    self.parent.subtitle = places?.first?.locality ?? "Loading..."
                }
            }
        }
        
    }
}
