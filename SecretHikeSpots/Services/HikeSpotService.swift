//
//  HikeSpotService.swift
//  SecretHikeSpots
//
//  Created by komoot on 25.07.22.
//

import Combine
import Foundation

protocol HikeSpotServiceType: AnyObject {
  /// fetches the list of stored hiking spots
  func fetchSavedHikeSpots() async -> [HikeSpot]
  /// saves a new spot to the store
  func save(spot: HikeSpot) async
  /// deleting a spot from the store
  func delete(spot: HikeSpot) async
  /// load data once and subscribe to updates
  func loadDataAndSubscribeToUpdates() -> AnyPublisher<[HikeSpot], Never>

}

enum Keys: String {
  case savedPlaces
}

final class HikeSpotService: HikeSpotServiceType {

  // MARK: Internal API

  /// saves a spot to the local storage from a data model
  func save(spot: HikeSpot) async {
    let currentSpots = await fetchSavedHikeSpots(updateCache: false)
    let newSpots = currentSpots + [spot]
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(newSpots)
      await defaults.store(data: data, forKey: .savedPlaces)
      Task.detached {
        await self.fetchSavedHikeSpots()
      }
    } catch {
      fatalError("could not encode new data")
    }
  }

  func delete(spot: HikeSpot) async {
    let newSpots = await self.fetchSavedHikeSpots(updateCache: false).filter { $0.id != spot.id }
    await defaults.store(data: Self.data(from: newSpots), forKey: .savedPlaces)
    Task.init {
      await self.fetchSavedHikeSpots()
    }
  }

  /// returns the list of locally saved hike spots asynchronously
  @discardableResult @MainActor func fetchSavedHikeSpots(updateCache: Bool) async -> [HikeSpot] {
    let task = FetchTask()
    activeTasks.append(task)
    let hikeSpots =
      await self.defaults.data(forKey: .savedPlaces).map { Self.hikeSpots(from: $0) } ?? []
    if updateCache {
      Task.detached {
        if task.id == self.activeTasks.last?.id {
          await self.updateCache(with: hikeSpots)
        }
      }
    } else {
      self.activeTasks.removeAll(where: { $0.id == task.id })
    }
    return hikeSpots
  }

  func loadDataAndSubscribeToUpdates() -> AnyPublisher<[HikeSpot], Never> {
    Task.detached {
      await self.fetchSavedHikeSpots()
    }
    // start with initial value if available
    return $cache.compactMap { $0 }.eraseToAnyPublisher()
  }

  @discardableResult func fetchSavedHikeSpots() async -> [HikeSpot] {
    await fetchSavedHikeSpots(updateCache: true)
  }

  // MARK: Private API

  @Published private var cache: [HikeSpot]? = nil

  @MainActor private func updateCache(with data: [HikeSpot]) {
    self.cache = data
  }

  private let defaults: UserDefaultsType

  private var activeTasks = [FetchTask]()

  private static func hikeSpots(from data: Data) -> [HikeSpot] {
    let jsonDecoder = JSONDecoder()
    do {
      return try jsonDecoder.decode([HikeSpot].self, from: data)
    } catch {
      fatalError("could not decode saved data")
    }
  }

  private static func data(from hikespots: [HikeSpot]) -> Data {
    let jsonEncoder = JSONEncoder()
    do {
      return try jsonEncoder.encode(hikespots)
    } catch {
      fatalError("could not encode new data")
    }
  }

  init(defaults: UserDefaultsType) {
    self.defaults = defaults
  }
}

struct FetchTask: Identifiable {
  let id = UUID()
}
