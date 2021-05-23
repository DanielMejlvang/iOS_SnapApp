//
//  Snap.swift
//  SnapApp
//
//  Created by Daniel Mejlvang Rasmussen on 20/05/2021.
//

import Foundation
import MapKit

class Snap {
    var id: String
    var from: String?
    var latitude: Double?
    var longitude: Double?
    var message: String?
    
    init(id: String, from: String, latitude: Double, longitude: Double, message: String) {
        self.id = id
        self.from = from
        self.latitude = latitude
        self.longitude = longitude
        self.message = message
    }
}
