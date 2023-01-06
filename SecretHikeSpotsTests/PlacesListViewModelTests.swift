//
//  PlacesListViewModelTest.swift
//  SecretHikeSpots
//
//  Created by komoot on 14.08.22.
//

import Combine
import XCTest

@testable import SecretHikeSpots

class PlacesListViewModelTests: XCTestCase {

  @MainActor func testListShowsPlaces() {
    let service = DataServiceMock()
    let viewModel = PlacesListViewModel(dataService: service)
    let predicate = NSPredicate { _, _ in
      viewModel.places.first?.name == "Berlin"
    }
    let expectation = XCTNSPredicateExpectation(predicate: predicate, object: viewModel)
    service.spots = [HikeSpot(id: UUID(), coordinates: .berlin, name: "Berlin")]
    wait(for: [expectation], timeout: 5.0)
    XCTAssertEqual(viewModel.places.count, 1)
  }

  @MainActor func testAddNewButtonCallsDelegate() {
    let service = DataServiceMock()
    let viewModel = PlacesListViewModel(dataService: service)
    let delegateMock = NavigationDelegateMock()
    viewModel.navigationDelegate = delegateMock

    viewModel.addNew()

    XCTAssertEqual(delegateMock.calls.count, 1)

    viewModel.addNew()

    XCTAssertEqual(delegateMock.calls.count, 2)
  }

}

// MARK: Support Code
class DataServiceMock: HikeSpotServiceType {

  @Published var spots: [HikeSpot] = []

  func fetchSavedHikeSpots() async -> [HikeSpot] {
    spots
  }

  func save(spot: HikeSpot) async {
    spots.append(spot)
  }

  func delete(spot: HikeSpot) async {
    spots = spots.filter { $0.id == spot.id }
  }

  func loadDataAndSubscribeToUpdates() -> AnyPublisher<[HikeSpot], Never> {
    $spots.eraseToAnyPublisher()
  }

}

class NavigationDelegateMock: PlacesListViewModelNavigationDelegate {

  var calls: [PlacesListViewModel] = []

  func addNewSpot(from viewModel: PlacesListViewModel) {
    calls.append(viewModel)
  }

}
