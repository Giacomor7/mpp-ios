//
//  OutboundJourneys.swift
//  mpp-ios
//
//  Created by Tasneem Kurabadwala on 05/07/2024.
//

import Foundation

struct Result: Decodable {
    let outboundJourneys: [Journey]
}

struct Journey: Decodable {
    let journeyId: String
    let originStation: Station
    let destinationStation: Station
    let departureTime: String
    let arrivalTime: String
    let departureRealTime: String?
    let arrivalRealTime: String?
    let status: String
    
}

struct Station: Decodable, Identifiable, Hashable {
    let displayName: String
    let crs: String
    var id: String { crs }
}




