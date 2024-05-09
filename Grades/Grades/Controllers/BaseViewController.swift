//
//  BaseViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftUI

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "ellipsis", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .systemGray5
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapOptionsButton), for: .touchUpInside)
        return button
    }()

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupAddAndOptionsButton() {
        setupAddButton()
        setupOptionsButton(trailingAnchor: addButton.leadingAnchor)
    }
    
    func setupAddButton() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addSubview(addButton)
            addButton.anchor
                .trailing(to: navigationBar.trailingAnchor, constant: -16)
                .bottom(to: navigationBar.bottomAnchor, constant: -12)
                .width(constant: 30)
                .height(to: addButton.widthAnchor)
                .activate()
        }
    }
    
    func setupOptionsButton(trailingAnchor: NSLayoutXAxisAnchor? = nil) {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addSubview(optionsButton)
            optionsButton.anchor
                .trailing(to: trailingAnchor ?? navigationBar.trailingAnchor, constant: -16)
                .bottom(to: navigationBar.bottomAnchor, constant: -12)
                .width(constant: 30)
                .height(to: addButton.widthAnchor)
                .activate()
        }
    }
    
    func showAddButton(_ show: Bool) {
      UIView.animate(withDuration: 0.2) {
        self.addButton.alpha = show ? 1.0 : 0.0
        self.addButton.isEnabled = show
      }
    }
    
    func showOptionButton(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
          self.optionsButton.alpha = show ? 1.0 : 0.0
          self.optionsButton.isEnabled = show
        }
    }
    
    func showNavigationBarButtons(_ show: Bool) {
        showAddButton(show)
        showOptionButton(show)
    }
    
    @objc func didTapAddButton() {
        
    }
    
    @objc func didTapOptionsButton() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.width, y: 0, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true)
    }

}
