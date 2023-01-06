//
//  Validator.swift
//  SecretHikeSpots
//
//  Created by komoot on 25.07.22.
//

import Foundation

struct Validator {
  func isValidHikeSpotName(_ name: String) -> Bool {
    name.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
      && name.trimmingCharacters(in: .whitespacesAndNewlines).count < 225
  }
}
