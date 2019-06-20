//
//  BaseViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftMessages

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
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupView() {
        view.backgroundColor = ThemeManager.currentTheme.backgroundColor
    }
    
    func showErrorMessage(_ message: String, layout: MessageView.Layout = .tabView) {
        let view = MessageView.viewFromNib(layout: layout)
        view.configureTheme(.error)
        view.configureContent(title: "Error".localized, body: message)
        view.button?.isHidden = true
        view.configureDropShadow()
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        var config = SwiftMessages.defaultConfig
        config.duration = .seconds(seconds: 15)
        SwiftMessages.show(view: view)
    }

}
