//
//  PickerOverlay.swift
//  SecretHikeSpots
//
//  Created by komoot on 03.08.22.
//

import Foundation
import UIKit

@objc class PickerOverlay: NSObject {

  weak var delegate: PickerOverlayDelegate?
  var bottomButton: UIButton?
  var closeButton: UIButton?

  func addOverlay(to parent: UIView) {
    addBottomButton(to: parent)
    addBackButton(to: parent)
  }

  func addBottomButton(to parent: UIView) {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(tappedBottomButton), for: .touchUpInside)
    parent.addSubview(button)
    button.setTitle("Save this spot", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    parent.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
    parent.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8)
      .isActive = true
    button.configuration = UIButton.Configuration.borderedProminent()
    self.bottomButton = button
  }

  func addBackButton(to parent: UIView) {
    let button = UIButton(type: .close)
    parent.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: 8)
      .isActive = true
    button.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 16)
      .isActive = true
    button.configuration = UIButton.Configuration.borderless()
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
    button.setImage(
      UIImage(systemName: "xmark.circle.fill", withConfiguration: largeConfig), for: .normal)
    button.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
    self.closeButton = button
  }

  @objc func tappedBottomButton(_ button: UIButton) {
    delegate?.tappedBottomButton()
  }

  @objc func tappedBackButton(_ button: UIButton) {
    delegate?.tappedBackButton()
  }

  @objc func tappedTutprialButton(_ button: UIButton) {
    enableButtons()
    delegate?.tappedTutorialButton()
  }

  func disableButtons() {
    self.closeButton?.isEnabled = false
    self.bottomButton?.isEnabled = false
  }

  func enableButtons() {
    self.closeButton?.isEnabled = true
    self.bottomButton?.isEnabled = true
  }

  func showTutorial(on parent: UIView) {
    disableButtons()
    addTutorial(to: parent)
  }

  func removeTutorial() {
    tutorialContainer?.removeFromSuperview()
  }

  // MARK: Private API

  private weak var tutorialContainer: UIView?

  private func addTutorial(to parent: UIView) {
    let container = UIView()
    parent.addSubview(container)
    container.translatesAutoresizingMaskIntoConstraints = false
    let label = UILabel()
    label.text =
      "Pick a location on the map in order to favorize it 📍. You can drag the pin to another location if you change your mind."
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 20)
    let button = UIButton(type: .system)
    button.configuration = .borderedProminent()
    button.setTitle("Let´s go", for: .normal)
    button.addTarget(self, action: #selector(Self.tappedTutprialButton), for: .touchUpInside)

    let vStack = UIStackView(arrangedSubviews: [label, button])
    vStack.translatesAutoresizingMaskIntoConstraints = false

    vStack.axis = .vertical

    vStack.distribution = .equalSpacing
    container.addSubview(vStack)

    container.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
    container.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
    container.widthAnchor.constraint(equalTo: parent.widthAnchor, constant: -16).isActive = true
    container.heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor, constant: 32).isActive =
      true
    container.backgroundColor = .white
    container.layer.cornerRadius = 12.0
    vStack.layoutMargins = .init(top: 16, left: 8, bottom: 16, right: 8)

    vStack.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
    vStack.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
    vStack.widthAnchor.constraint(equalTo: container.widthAnchor, constant: -32.0).isActive = true
    vStack.heightAnchor.constraint(equalTo: container.heightAnchor, constant: -32.0).isActive = true
    vStack.spacing = 16.0

    tutorialContainer = container

  }
}
