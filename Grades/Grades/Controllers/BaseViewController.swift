//
//  BaseViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftUI

struct BaseViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = BaseViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<BaseViewControllerWrapper>) -> BaseViewControllerWrapper.UIViewControllerType {
        return BaseViewController()
    }
    
    func updateUIViewController(_ uiViewController: BaseViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<BaseViewControllerWrapper>) {
    }
}

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
        view.backgroundColor = .systemBackground
    }

}
