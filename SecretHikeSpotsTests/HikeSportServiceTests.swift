//
//  HikeSportServiceTests.swift
//  SecretHikeSpotsTests
//
//  Created by komoot on 03.08.22.
//

import Combine
import XCTest

@testable import SecretHikeSpots

final class HikeSportServiceTests: XCTestCase {

  func testSavedHikeSpotsListIsEmptyOnInitialization() async {
    let service: HikeSpotServiceType = HikeSpotService(defaults: mockDefaults)
    let spots = await service.fetchSavedHikeSpots()
    XCTAssert(spots.isEmpty)
  }

  func testSpotIsSuccessfullyAdded() async {
    let service: HikeSpotServiceType = HikeSpotService(defaults: mockDefaults)
    let spot = HikeSpot(coordinates: .berlin, name: "Berlin")
    await service.save(spot: spot)

    let savedSpots = await service.fetchSavedHikeSpots()
    XCTAssertEqual(savedSpots.first?.name, "Berlin")
    XCTAssertEqual(savedSpots.first?.coordinates.lat, Coordinates.berlin.lat)
    XCTAssertEqual(savedSpots.first?.coordinates.long, Coordinates.berlin.long)
    XCTAssertEqual(savedSpots.count, 1)
  }

  func testCreatingSpot() {
    let uuid = UUID()
    let spot = HikeSpot(id: uuid, coordinates: .berlin, name: "Berlin")
    XCTAssertEqual(spot.id, uuid)
    XCTAssertNotNil(spot.id as UUID?)
    XCTAssertNotEqual(spot.name, "Hamburg")
    XCTAssertEqual(spot.coordinates.lat, Coordinates.berlin.lat)
    XCTAssertEqual(spot.coordinates.long, Coordinates.berlin.long)
    XCTAssertEqual(spot.name, "Berlin")
  }

  func testCreatingSpotWithDifferentName() {
    let uuid = UUID()
    let spot = HikeSpot(id: uuid, coordinates: .berlin, name: "Berlin2")
    XCTAssertEqual(spot.id, uuid)
    XCTAssertEqual(spot.coordinates.lat, Coordinates.berlin.lat)
    XCTAssertEqual(spot.coordinates.long, Coordinates.berlin.long)
    XCTAssertEqual(spot.name, "Berlin2")
  }

  func testSpotIsSuccessfullyDeleted() async throws {
    let service: HikeSpotServiceType = HikeSpotService(defaults: mockDefaults)
    let spot = HikeSpot(coordinates: .berlin, name: "Berlin")
    await service.save(spot: spot)
    let savedSpots = await service.fetchSavedHikeSpots()
    let firstSpot = try XCTUnwrap(savedSpots.first)
    await service.delete(spot: firstSpot)
    let spotsAfterDeletion = await service.fetchSavedHikeSpots()
    XCTAssert(spotsAfterDeletion.isEmpty)
  }

  private var subscription: AnyCancellable?
  private lazy var savedValues: [[HikeSpot]] = []

  func testLoadDataAndSubscribeToUpdates() async {
    let service: HikeSpotServiceType = HikeSpotService(defaults: mockDefaults)
    let expectation1 = expectation(description: "expect initial value from cache")
    let expectation2 = expectation(description: "expect inserted spot value from cache")

    //let expectation3 = expectation(description: "expect deleted spot value from cache")

    //expectation.assertForOverFulfill = true

    subscription = service.loadDataAndSubscribeToUpdates().sink(receiveValue: { spots in
      XCTAssertEqual(spots.count, 0)
      expectation1.fulfill()
    })

    wait(for: [expectation1], timeout: 10.0)

    let spot = HikeSpot(coordinates: .berlin, name: "Berlin")
    Task.detached {
      await service.save(spot: spot)
    }

    expectation2.assertForOverFulfill = false

    subscription = service.loadDataAndSubscribeToUpdates().sink(receiveValue: { spots in
      if spots.count == 1 {
        expectation2.fulfill()
      }
    })
    wait(for: [expectation2], timeout: 10.0)
  }

  // MARK: support code
  fileprivate var mockDefaults = MockDefaults()

  override func setUp() {
    mockDefaults = MockDefaults()
  }

  override func tearDown() async throws {
    subscription = nil
    savedValues = []
  }

}

private final class MockDefaults: UserDefaultsType {

  private var defaults = [Keys: Data]()

  func data(forKey key: Keys) -> Data? {
    defaults[key]
  }

  func store(data: Data, forKey key: Keys) {
    defaults[key] = data
  }

}
