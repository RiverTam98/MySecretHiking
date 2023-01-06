//
//  Coordinator.swift
//  SecretHikeSpots
//
//  Created by komoot on 25.07.22.
//

import CoreLocation
import Foundation
import SwiftUI
import UIKit

class Coordinator {

  let rootNavigationController: UINavigationController

  init(rootNavigationController: UINavigationController) {
    self.rootNavigationController = rootNavigationController
  }

  @MainActor func start() {
    showSpotList()
  }

  let databaseMock = NetworkDatabaseMock()

  lazy var dataService = HikeSpotService(defaults: databaseMock)

  @MainActor func showSpotList() {
    let viewModel = PlacesListViewModel(dataService: dataService)
    viewModel.navigationDelegate = self
    let hostingController = UIHostingController(rootView: PlacesList(viewModel: viewModel))
    rootNavigationController.viewControllers = [hostingController]
    rootNavigationController.navigationBar.prefersLargeTitles = true

  }

}

extension Coordinator: PlacesListViewModelNavigationDelegate {
  func addNewSpot(from viewModel: PlacesListViewModel) {
    let pickerViewControler = LocationPickerViewController()
    pickerViewControler.navigationDelegate = self
    rootNavigationController.present(pickerViewControler, animated: true)
  }
}

extension Coordinator: LocationPickerNavigationDelegate {
  func locationPickerViewController(
    _ locationPickerViewController: LocationPickerViewController,
    wantsToStore location: CLLocationCoordinate2D, with name: String
  ) {
    let spot = HikeSpot(coordinates: Coordinates(from: location), name: name)
    Task.init {
      await dataService.save(spot: spot)
      await self.rootNavigationController.dismiss(animated: true)
    }
  }

  func locationPickerViewControllerWantsToGoBack(
    _ locationPickerViewController: LocationPickerViewController
  ) {
    rootNavigationController.dismiss(animated: true)
  }
}
