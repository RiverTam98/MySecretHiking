//
//  PlacesToVisitList.swift
//  SecretHikeSpots
//
//  Created by komoot on 22.07.22.
//

import Combine
import Foundation
import MapKit
import SwiftUI

struct PlacesList: View {

  struct Constants {
    static let mapSize: CGFloat = 100
    static let mapCornerRadius: CGFloat = 16
  }

  @ObservedObject var viewModel: PlacesListViewModel

  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  let gridLayout = [GridItem(.adaptive(minimum: 200, maximum: 200))]

  var body: some View {
    VStack {
      if horizontalSizeClass == .regular {
        LazyVGrid(columns: gridLayout) {
          ForEach(viewModel.sortedPlaces) { place in
            VStack { spotCell(place) }
          }
          .onDelete(perform: { viewModel.delete(at: $0) })
        }
      } else {
        List {
          ForEach(viewModel.sortedPlaces) { place in
            HStack { spotCell(place) }
          }
          .onDelete(perform: { viewModel.delete(at: $0) })
        }
      }
      addButton()
    }
    .onAppear {
      viewModel.viewDidAppear()
    }
    .navigationTitle("My Hiking spots")
  }

  func spotCell(_ spot: HikeSpot) -> some View {
    Group {
      Button(spot.name) {
        viewModel.openMapForPlace(spot: spot)
      }
      Spacer()
      Map(coordinateRegion: .constant(spot.region), interactionModes: [], annotationItems: [spot]) {
        MapPin(coordinate: $0.coordinates.clLocationCoordinates)
      }
      .frame(width: Constants.mapSize, height: Constants.mapSize)
      .cornerRadius(Constants.mapCornerRadius)
    }
  }

  func addButton() -> some View {
    Button(action: {}) {
      HStack(spacing: 16) {
        Spacer()
        Image(systemName: "plus.diamond.fill")
          .resizable()
          .frame(width: 30, height: 30)
          .foregroundColor(Color("primary"))

        Button(
          action: {
            Task.init {
              viewModel.addNew()
            }
          },
          label: {
            Text("Add new secret hiking spot")
          })
        Spacer()
      }
    }
  }
}

extension HikeSpot {
  fileprivate var region: MKCoordinateRegion {
    MKCoordinateRegion(
      center: coordinates.clLocationCoordinates, latitudinalMeters: 500, longitudinalMeters: 500)
  }
}

struct PlacesList_Previews: PreviewProvider {
  static var previews: some View {
    PlacesList(viewModel: PlacesListViewModel(dataService: HikeSpotServiceMock()))
  }
}

class HikeSpotServiceMock: HikeSpotServiceType {

  func loadDataAndSubscribeToUpdates() -> AnyPublisher<[HikeSpot], Never> {
    Just([]).eraseToAnyPublisher()
  }

  func save(spot: HikeSpot) async {

  }

  func delete(spot: HikeSpot) async {

  }

  func fetchSavedHikeSpots() async -> [HikeSpot] {
    return [Examples.riverflow, Examples.temple]
  }

}
