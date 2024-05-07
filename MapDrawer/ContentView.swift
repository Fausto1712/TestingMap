//
//  ContentView.swift
//  MapDrawer
//
//  Created by Fausto Pinto Cabrera on 02/05/24.
//

import SwiftUI
import MapKit
import SwiftData

struct RunMarker: Hashable {
    var id = UUID()
    var coordinates: [Double]
    var label: String
}

struct ContentView: View {
    //Default location a user manager initilization
    @State private var region : MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.8525139681341, longitude: 14.272090640839773),latitudinalMeters: 5000, longitudinalMeters: 15000)
    @State private var camera : MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.8525139681341, longitude: 14.272090640839773),latitudinalMeters: 5000, longitudinalMeters: 15000))
    @ObservedObject private var locationManager = LocationManager.shared
    
    //Logic for the shape making
    @State private var coordinates = [0.0,0.0]
    @State private var runMarkers: [RunMarker] = []
    @State private var sliderValue: Double = 100.0
    @State private var route: [MKRoute?] = []
    
    var body: some View {
        ZStack {
            Map(position: $camera){
                if !runMarkers.isEmpty {
                    ForEach(runMarkers, id: \.self) { marker in
                        Marker(marker.label, coordinate: CLLocationCoordinate2D(latitude: marker.coordinates[0], longitude: marker.coordinates[1]))
                            .tag(marker.id)
                    }
                }
                if  !route.isEmpty {
                    ForEach(route, id: \.self) { routePart in
                        if let routePart = routePart {
                            MapPolyline(routePart)
                                .stroke(randomColor(), lineWidth: 5)
                        }
                    }
                }
                UserAnnotation()
            }
            .mapControls {
                MapScaleView()
            }
            VStack{
                Spacer()
                
                HStack{
                    Text(String(coordinates[0]))
                        .foregroundStyle(.white)
                    Text(String(coordinates[1]))
                        .foregroundStyle(.white)
                }
                
                HStack{
                    Button(action: {
                        self.updateUserLocation(shapeName: "star")
                    }) {
                        Image(systemName: "star.fill")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        self.updateUserLocation(shapeName: "square")
                    }) {
                        Image(systemName: "square.fill")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        self.updateUserLocation(shapeName: "trophy")
                    }) {
                        Image(systemName: "trophy.fill")
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        self.updateUserLocation(shapeName: "heart")
                    }) {
                        Image(systemName: "heart.fill")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Text("Meters: \(Int(sliderValue))")
                Slider(value: $sliderValue, in: 100...10000, step: 100)
                    .padding()
            }
            .padding()
        }
        .onAppear{
            self.locationManager.startUpdatingLocation { _ in }
            if let location = locationManager.lastLocation {
                coordinates = [location.coordinate.latitude,location.coordinate.longitude]
                let userCL2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let userMK = MKCoordinateRegion(center: userCL2D, latitudinalMeters: 5000, longitudinalMeters: 15000)
                camera = .region(userMK)
                region = userMK
            }
        }
    }
    
    func updateUserLocation(shapeName: String) {
        if let location = locationManager.lastLocation {
            coordinates = [location.coordinate.latitude, location.coordinate.longitude]
        }
        
        runMarkers = []
        let latitudeDelta = sliderValue / 111111.0
        let longitudeDelta = sliderValue / (111111.0 * cos(coordinates[0] * .pi / 180))
        
        if shapeName == "square"{
            runMarkers.append(RunMarker(coordinates: [coordinates[0], coordinates[1]], label: "1"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + latitudeDelta, coordinates[1]], label: "2"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + latitudeDelta, coordinates[1] + longitudeDelta], label: "3"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0], coordinates[1] + longitudeDelta], label: "4"))
        }
        
        if shapeName == "star"{
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.0), coordinates[1] + (longitudeDelta * 0.0)], label: "1"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] - (latitudeDelta * 0.34), coordinates[1] + (longitudeDelta * 0.17)], label: "2"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.0), coordinates[1] + (longitudeDelta * 0.34)], label: "3"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 0.66)], label: "4"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.34), coordinates[1] + (longitudeDelta * 0.34)], label: "5"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.66), coordinates[1] + (longitudeDelta * 0.17)], label: "6"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.34), coordinates[1] + (longitudeDelta * 0.0)], label: "7"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] - (longitudeDelta * 0.34)], label: "8"))
        }
        
        if shapeName == "trophy"{
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.00), coordinates[1] + (longitudeDelta * 0.00)], label: "1"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 0.00)], label: "2"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 0.33)], label: "3"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.50), coordinates[1] + (longitudeDelta * 0.33)], label: "4"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.50), coordinates[1] + (longitudeDelta * 0.17)], label: "5"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.67), coordinates[1] + (longitudeDelta * 0.17)], label: "6"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.67), coordinates[1] + (longitudeDelta * 0.00)], label: "7"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 1.00), coordinates[1] + (longitudeDelta * 0.00)], label: "8"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 1.00), coordinates[1] + (longitudeDelta * 1.00)], label: "9"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.67), coordinates[1] + (longitudeDelta * 1.00)], label: "10"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.67), coordinates[1] + (longitudeDelta * 0.83)], label: "11"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.50), coordinates[1] + (longitudeDelta * 0.83)], label: "12"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.50), coordinates[1] + (longitudeDelta * 0.67)], label: "13"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 0.67)], label: "14"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 1.00)], label: "15"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.00), coordinates[1] + (longitudeDelta * 1.00)], label: "16"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.00), coordinates[1] + (longitudeDelta * 0.00)], label: "17"))
        }
        
        if shapeName == "heart"{
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.0), coordinates[1] + (longitudeDelta * 0.0)], label: "1"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 0.0)], label: "2"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] - (longitudeDelta * 0.17)], label: "3"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.84), coordinates[1] - (longitudeDelta * 0.17)], label: "4"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.84), coordinates[1] + (longitudeDelta * 0.17)], label: "5"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.66), coordinates[1] + (longitudeDelta * 0.17)], label: "6"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.66), coordinates[1] + (longitudeDelta * 0.5)], label: "7"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.84), coordinates[1] + (longitudeDelta * 0.5)], label: "8"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.84), coordinates[1] + (longitudeDelta * 0.84)], label: "9"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 0.84)], label: "10"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 0.66)], label: "11"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.0), coordinates[1] + (longitudeDelta * 0.66)], label: "12"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.0), coordinates[1] + (longitudeDelta * 0.5)], label: "13"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] - (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 0.5)], label: "14"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] - (latitudeDelta * 0.17), coordinates[1] + (longitudeDelta * 0.17)], label: "15"))
            runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.0), coordinates[1] + (longitudeDelta * 0.17)], label: "16"))
        }
        
        for i in 0..<runMarkers.count-1 {
            createRoute(source: runMarkers[i].coordinates, destination: runMarkers[i+1].coordinates)
        }
    }
    
    func createRoute(source: [Double], destination: [Double]) {
        route = []
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: source[0], longitude: source[1])))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destination[0], longitude: destination[1])))
        request.transportType = .walking
        
        Task{
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route.append(response?.routes.first)
        }
    }
    
    func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView()
}
