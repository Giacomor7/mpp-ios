//
//  ContentView.swift
//  mpp-ios
//
//  Created by Giacomo Rossetti on 03/07/2024.
//

import SwiftUI

struct ContentView: View {
    
    let stations = [
        Station(displayName: "London Kings Cross", crs: "KGX"),
        Station(displayName: "Edinburgh Waverley", crs: "EDB"),
        Station(displayName: "Newcastle", crs: "NCL"),
        Station(displayName: "York", crs: "YRK"),
        Station(displayName: "Leeds", crs: "LDS")
    ]
    // Enter API key
    let API_KEY = "hahauwish"
    
    @State private var showingAlert = false
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
                Text(station.displayName).tag(station as Station?)
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity
        )
    }
    
    private var submitButton: some View {
        Button {
            if departStation == nil || arrivalStation == nil {
                showingAlert = true
            }
            else {
                Task {
                    var urlStringBuilder = "https://mobile-api-softwire2.lner.co.uk/v1/fares?originStation="
                    urlStringBuilder += departStation!.id
                    urlStringBuilder += "&destinationStation="
                    urlStringBuilder += arrivalStation!.id
                    urlStringBuilder += "&outboundDateTime="
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    urlStringBuilder += formatter.string(from: Date())
                    
                    urlStringBuilder += "&numberOfChildren=0&numberOfAdults=1"
                    
                    if let url = URL(string: urlStringBuilder) {
                        var request = URLRequest(url: url)
                        request.addValue(API_KEY, forHTTPHeaderField: "x-api-key")
                        
                        let config = URLSessionConfiguration.default
                        let session = URLSession(configuration: config)
                        
                        let task = session.dataTask(with: request) { (data, response, error) in
                            
                            do{
                                let decodedResponse = try JSONDecoder().decode(Result.self, from: data!)
                                let depart = decodedResponse.outboundJourneys[0]
                                    .originStation.displayName
                                print(depart)
                            }catch {
                                print("error: ", error)
                            }
                        }
                        task.resume()
                    }
                }
            }
        } label: {
            Text("Submit")
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
