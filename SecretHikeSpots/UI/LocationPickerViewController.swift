//
//  LocationPickerViewController.swift
//  SecretHikeSpots
//
//  Created by komoot on 25.07.22.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

protocol LocationPickerNavigationDelegate: AnyObject {
  func locationPickerViewControllerWantsToGoBack(
    _ locationPickerViewController: LocationPickerViewController)
  func locationPickerViewController(
    _ locationPickerViewController: LocationPickerViewController,
    wantsToStore location: CLLocationCoordinate2D, with name: String)
}

final class LocationPickerViewController: UIViewController {

  private lazy var mapView = MapKit.MKMapView()
  weak var navigationDelegate: LocationPickerNavigationDelegate?
  var currentSelectedLocation: CLLocationCoordinate2D? {
    didSet {
      if let currentSelectedLocation = currentSelectedLocation {
        markSelection(currentSelectedLocation)
      }
    }
  }

  override func viewDidLoad() {
    setupViews()
    configureaMapStyle()
    addGestureRecognizer()
    showTutorialIfNeeded()
  }

  override var prefersStatusBarHidden: Bool { true }

  override func viewDidAppear(_ animated: Bool) {
    askForLocationPermissionIfNeeded()
  }

  private func showTutorialIfNeeded() {
    guard needsToShowTutorial else { return }
    mapView.isUserInteractionEnabled = false
    overlay.showTutorial(on: view)
    needsToShowTutorial = false
  }

  private func askForLocationPermissionIfNeeded() {
    CLLocationManager().requestWhenInUseAuthorization()
  }

  private var needsToShowTutorial: Bool {
    get {
      !UserDefaults.standard.bool(forKey: "has_seen_tutorial")
    }
    set {
      UserDefaults.standard.set(!newValue, forKey: "has_seen_tutorial")
    }
  }

  private let overlay = PickerOverlay()

  private func setupViews() {
    view.addSubview(mapView)
    mapView.translatesAutoresizingMaskIntoConstraints = false
    view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive =
      true
    view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: mapView.trailingAnchor).isActive =
      true
    view.topAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
    mapView.delegate = self
    mapView.showsUserLocation = true

    // add overlay
    overlay.addOverlay(to: view)
    overlay.delegate = self
  }

  func reverseGeocode(location: CLLocation) async -> [CLPlacemark]? {
    try? await withCheckedThrowingContinuation { continuation in
      CLGeocoder().reverseGeocodeLocation(
        location,
        completionHandler: { placemarks, error in
          if let placemarks = placemarks {
            continuation.resume(with: .success(placemarks))
          } else if let error = error {
            continuation.resume(throwing: error)
          }
        })
    }

  }

  @objc func alertTextFieldDidChange(_ sender: UITextField) {
    activeSaveAction?.isEnabled = Validator().isValidHikeSpotName(sender.text ?? "")
  }

  weak var activeSaveAction: UIAlertAction?

  func addCurrentLocation() {
    let alertController = UIAlertController(
      title: "That spot looks nice ! Give it a name", message: "", preferredStyle: .alert)
    alertController.addTextField { textField in
      textField.placeholder = "Camping in the woods"
      textField.addTarget(
        self, action: #selector(Self.alertTextFieldDidChange(_:)), for: .editingChanged)
    }

    let saveAction = UIAlertAction(
      title: "Save", style: .default,
      handler: { [weak self] alert -> Void in
        guard let self = self, let location = self.currentSelectedLocation else { return }
        guard let textField = alertController.textFields?[0] as? UITextField else {
          fatalError("could not find textField inside AlertController")
        }
        guard let name = textField.text, name.count > 3 else { return }
        self.overlay.disableButtons()
        self.navigationDelegate?.locationPickerViewController(
          self, wantsToStore: location, with: name)
      })

    activeSaveAction = saveAction

    let cancelAction = UIAlertAction(
      title: "Cancel", style: .default,
      handler: {
        (action: UIAlertAction!) -> Void in
      })

    alertController.addAction(cancelAction)
    alertController.addAction(saveAction)

    saveAction.isEnabled = false

    present(alertController, animated: true)
  }

  func addGestureRecognizer() {
    mapView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(Self.didTapMap)))
  }

  @objc func didTapMap(_ gestureRecognizer: UITapGestureRecognizer) {
    let location = mapView.convert(
      gestureRecognizer.location(in: mapView), toCoordinateFrom: mapView)
    currentSelectedLocation = location
  }

  private func markSelection(_ coordinate: CLLocationCoordinate2D) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    Task.init { [weak annotation] in
      let placemarks = await reverseGeocode(
        location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
      annotation?.title = placemarks?.first?.name
    }
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotation(annotation)
  }

  func configureaMapStyle() {
    mapView.mapType = .hybridFlyover
  }

}

extension LocationPickerViewController: PickerOverlayDelegate {

  func tappedTutorialButton() {
    self.overlay.removeTutorial()
    mapView.isUserInteractionEnabled = true
  }

  func tappedBottomButton() {
    guard currentSelectedLocation != nil else { fatalError("no location selected") }
    self.addCurrentLocation()
  }

  func tappedBackButton() {
    navigationDelegate?.locationPickerViewControllerWantsToGoBack(self)
  }

}

extension LocationPickerViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKPointAnnotation {
      let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")

      pinAnnotationView.pinTintColor = .purple
      pinAnnotationView.isDraggable = true
      pinAnnotationView.canShowCallout = true
      pinAnnotationView.animatesDrop = true

      return pinAnnotationView
    }

    return nil
  }
}

protocol PickerOverlayDelegate: AnyObject {
  func tappedBottomButton()
  func tappedBackButton()
  func tappedTutorialButton()
}
