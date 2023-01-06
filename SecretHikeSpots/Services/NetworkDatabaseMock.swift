//
//  DatabaseService.swift
//  SecretHikeSpots
//
//  Created by komoot on 11.08.22.
//

import Foundation

protocol UserDefaultsType {
  func data(forKey key: Keys) async -> Data?
  func store(data: Data, forKey key: Keys) async
}

struct NetworkDatabaseMock: UserDefaultsType {

  func data(forKey key: Keys) async -> Data? {
    return await withUnsafeContinuation { continuation in
      DispatchQueue.main.asyncAfter(deadline: .now() + readDelay()) {
        let data = UserDefaults.standard.data(forKey: defaultsKey(for: key))
        continuation.resume(returning: data)
      }
    }
  }

  func store(data: Data, forKey key: Keys) async {
    UserDefaults.standard.set(data, forKey: defaultsKey(for: key))
  }

  private func defaultsKey(for key: Keys) -> String {
    "hikespots.\(key.rawValue)"
  }

  private func readDelay() -> TimeInterval {
    TimeInterval.random(in: 0...4)
  }
}
