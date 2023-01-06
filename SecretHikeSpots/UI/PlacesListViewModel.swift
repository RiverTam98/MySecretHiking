//
//  PlacesListViewModel.swift
//  SecretHikeSpots
//
//  Created by komoot on 14.08.22.
//

import Combine
import CoreLocation
import Foundation
import MapKit
import SwiftUI

protocol PlacesListViewModelNavigationDelegate: AnyObject {
  func addNewSpot(from viewModel: PlacesListViewModel)
}

@MainActor
class PlacesListViewModel: ObservableObject {

  @Published
  var places = [HikeSpot]() {
    didSet {
      sortedPlaces = places.sorted(by: { s1, s2 in
        s1.createdAt > s2.createdAt
      })
    }
  }

  @Published
  private(set) var sortedPlaces = [HikeSpot]()

  let dataService: HikeSpotServiceType

  weak var navigationDelegate: PlacesListViewModelNavigationDelegate?

  func delete(at offsets: IndexSet) {
    defer { places.remove(atOffsets: offsets) }
    let placesToDelete = offsets.compactMap { index -> HikeSpot? in
      if self.places.indices.contains(index) {
        return self.places[index]
      } else {
        return nil
      }
    }
    let _ = placesToDelete.map { place in
      Task.init {
        await self.dataService.delete(spot: place)
      }
    }
  }

  func openMapForPlace(spot: HikeSpot) {

    let regionDistance: CLLocationDistance = 10000
    let coordinates = spot.coordinates.clLocationCoordinates
    let regionSpan = MKCoordinateRegion(
      center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    let options = [
      MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
      MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
    ]
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = "\(spot.name)"
    mapItem.openInMaps(launchOptions: options)

  }

  func addNew() {
    navigationDelegate?.addNewSpot(from: self)
  }

  private var subscriptions = Set<AnyCancellable>()

  private func loadData() async {
    let places = await self.dataService.fetchSavedHikeSpots()
    self.dataService.loadDataAndSubscribeToUpdates().sink { [weak self] places in
      self?.places = places
    }.store(in: &subscriptions)
    withAnimation {
      self.places = places
    }
  }

  func viewDidAppear() {
    Task.init {
      await loadData()
    }
  }

  init(dataService: HikeSpotServiceType) {
    self.dataService = dataService
    Task.init {
      await loadData()
    }
  }

}
