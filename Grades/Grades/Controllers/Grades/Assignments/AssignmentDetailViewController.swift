//
//  AssignmentDetailViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/22/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol AssignmentDetailViewControllerDelegate: class {
    func didEditAssignment()
}

class AssignmentDetailViewController: BaseViewController {
    
    weak var delegate: AssignmentDetailViewControllerDelegate?
    var assignment: Assignment = Assignment()
    var circularSlider: CircularSlider!
    var incrementBySegmentedControl: UISegmentedControl!

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = assignment.name
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAssignment))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func setupView() {
        super.setupView()
        setupIncrementBySection()
        setupCircularSlider()
    }
    
    private func setupIncrementBySection() {
        let label = IPLabel()
        label.text = "Increment by"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        view.addSubview(label)
        label.anchor
            .topToSuperview(constant: 20, toSafeArea: true)
            .leadingToSuperview(constant: 16)
            .trailingToSuperview(constant: -16)
            .activate()
        
        let items = ["1", "0.1", "0.01"]
        incrementBySegmentedControl = UISegmentedControl(items: items)
        incrementBySegmentedControl.selectedSegmentIndex = 0
        incrementBySegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(incrementBySegmentedControl)
        incrementBySegmentedControl.anchor
            .top(to: label.bottomAnchor, constant: 20)
            .trailingToSuperview(constant: -16)
            .leadingToSuperview(constant: 16)
            .activate()
    }
    
    private func setupCircularSlider() {
        circularSlider = CircularSlider(frame: .zero)
        circularSlider.title = "Grade".localized
        circularSlider.gradable = assignment
        circularSlider.radiansOffset = 0.8
        circularSlider.lineWidth = 20
        circularSlider.knobRadius = 30
        
        view.addSubview(circularSlider)
        circularSlider.anchor
            .top(to: incrementBySegmentedControl.bottomAnchor, constant: 20)
            .trailingToSuperview(constant: -50)
            .leadingToSuperview(constant: 50)
            .height(to: circularSlider.widthAnchor)
            .activate()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        circularSlider.numberOfDecimals = sender.selectedSegmentIndex
    }
    
    @objc private func saveAssignment() {
        assignment.update(grade: circularSlider.value)
        delegate?.didEditAssignment()
        dismiss(animated: true)
    }

}
