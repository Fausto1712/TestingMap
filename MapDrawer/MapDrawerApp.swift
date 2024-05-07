//
//  MapDrawerApp.swift
//  MapDrawer
//
//  Created by Fausto Pinto Cabrera on 02/05/24.
//

import SwiftUI

@main
struct MapDrawerApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
                ContentView()
                    .tabItem {
                        Label("Menu", systemImage: "map.fill")
                    }
                
                GridPlotter()
                    .tabItem {
                        Label("Menu", systemImage: "mappin")
                    }
            }
        }
    }
}
