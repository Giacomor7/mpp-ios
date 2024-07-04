//
//  ContentView.swift
//  mpp-ios
//
//  Created by Giacomo Rossetti on 03/07/2024.
//

import SwiftUI

struct Station: Identifiable, Hashable {
    let name: String
    let id: String
}

struct ContentView: View {
    
    var stations = [
        Station(name: "London Kings Cross", id: "KGX"),
        Station(name: "Edinburgh Waverley", id: "EDB"),
        Station(name: "Newcastle", id: "NCL"),
        Station(name: "York", id: "YRK"),
        Station(name: "Leeds", id: "LDS")
    ]
    @State private var departStation: Station? = nil
    @State private var arrivalStation: Station? = nil
    
    var body: some View {
        VStack {
            Text("Live Train Times")
                .font(.title)
                .fontWeight(.bold)
                .padding(.all)
            
            HStack {
                Picker("Select departure station", selection: $departStation) {
                    Text("Select departure...").tag(Optional<Station>(nil))
                    ForEach(stations) { station in
                        Text(station.name).tag(station as Station?)
                    }
                }
                .frame(width: 150)
                Picker("Select arrival station", selection: $arrivalStation) {
                    Text("Select arrival...").tag(Optional<Station>(nil))
                    ForEach(stations) { station in
                        Text(station.name).tag(station as Station?)
                    }
                }
                .frame(width: 150)
            }
            Button("Submit") {
                
            }
            .padding()
            .font(.title3)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
