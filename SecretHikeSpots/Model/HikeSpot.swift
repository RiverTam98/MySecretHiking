//
//  HikeSpot.swift
//  SecretHikeSpots
//
//  Created by komoot on 22.07.22.
//

import CoreLocation
import Foundation

struct HikeSpot: Codable, Identifiable {
  var id = UUID()
  let coordinates: Coordinates
  let name: String
  var createdAt = Date()
}

struct Coordinates: Codable {
  let lat, long: Double

  var clLocationCoordinates: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: lat, longitude: long)
  }

  init(from clLocationCoordinates: CLLocationCoordinate2D) {
    self.init(lat: clLocationCoordinates.latitude, long: clLocationCoordinates.longitude)
  }

  init(lat: Double, long: Double) {
    self.lat = lat
    self.long = long
  }
}

struct Examples {
  static let temple = HikeSpot(
    coordinates: Coordinates(lat: 50.5336505, long: 6.7031338), name: "Roman Temple")
  static let riverflow = HikeSpot(
    coordinates: Coordinates(lat: 50.5794624, long: 4.1865565),
    name: "Sentier le long de la Sennette")
}

extension Coordinates {
  static let berlin = Self(lat: 52.520008, long: 13.404954)
}
