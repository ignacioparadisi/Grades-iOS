//
//  HomeViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, ScrollableView {
    
    /// View within Scroll View that creates ScrollableView protocol.
    /// Needs to be initialized to conform ScrollableView protocol
    var contentView: UIView = UIView()
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Home".localized
    }
    
    override func setupView() {
        super.setupView()
        addScrollView()
        
        let notificationsLabel = TitleLabel()
        notificationsLabel.textColor = ThemeManager.currentTheme.textColor
        notificationsLabel.text = "Notifications".localized
        
        contentView.addSubview(notificationsLabel)
        notificationsLabel.anchor.topToSuperview(constant: 20).activate()
        notificationsLabel.anchor.leadingToSuperview(constant: 16).activate()
        notificationsLabel.anchor.trailingToSuperview(constant: -16).activate()
    }

}
