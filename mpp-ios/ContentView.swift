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
    @State private var showingAlert = false
    
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
              stationPicker(title: "Select departure...", selection: $departStation)
              stationPicker(title: "Select arrival...", selection: $arrivalStation)
            }
            submitButton
            Spacer()
        }
        .padding()
    }
    
    func getUrl(_ departStation: Station, _ arrivalStation: Station) -> String {
        return "https://www.lner.co.uk/travel-information/travelling-now/live-train-times/depart/\(departStation.id)/\(arrivalStation.id)/#LiveDepResults"
    }
    
    private func stationPicker(title: String, selection: Binding<Station?>) -> some View {
        Picker(title, selection: selection) {
            Text(title).tag(Optional<Station>(nil))
            ForEach(stations) { station in
                Text(station.name).tag(station as Station?)
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity
        )
    }
    
    private var submitButton: some View {
        Button("Submit") {
            if departStation == nil || arrivalStation == nil {
                showingAlert = true
            } else {
                let urlString = getUrl(departStation!, arrivalStation!)
                if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
        .alert("Select departure and arrival stations", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .padding()
        .font(.title3)
    }
}

#Preview {
    ContentView()
}
