//
//  EditTermsViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol EditTermsViewControllerDelegate: class {
    func didEditTerms()
}

class EditTermsViewController: BaseViewController {
    
    weak var delegate: EditTermsViewControllerDelegate?
    var tableView: UITableView!
    var terms: [Term] = []
    private var termsToBeDeleted: [Term] = []
    var saveButton: IPButton = {
        let button = IPButton()
        button.backgroundColor = ThemeManager.currentTheme.accentColor
        button.setTitle("Save".localized, for: .normal)
        button.addTarget(self, action: #selector(editTerms), for: .touchUpInside)
        return button
    }()

    override func setupView() {
        super.setupView()
        setupTableView()
        setupSaveButton()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Edit Terms".localized
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isEditing = true
        view.addSubview(tableView)
        tableView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        tableView.register(LabelTableViewCell.self)
        tableView.reloadData()
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.anchor
            .top(to: tableView.bottomAnchor, constant: 16)
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .bottomToSuperview(constant: -16, toSafeArea: true)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .activate()
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func editTerms() {
        let termService = AbstractServiceFactory.getServiceFactory(for: .realm).termService
        termService.deleteTerms(termsToBeDeleted) { result in
            switch result {
            case .success:
                print("Successfully deleted terms")
            case .failure:
                print("Failed deleting terms")
            }
        }
        termService.updateTerms(terms) { result in
            switch result {
            case .success:
                print("Successfully updated terms")
            case .failure:
                print("Failed updating terms")
            }
        }
        
        delegate?.didEditTerms()
        dismissView()
    }
    
    private func updatePositions() {
            var aux: [Term] = []
            for (index, term) in self.terms.enumerated() {
                if let auxTerm = term.copy() as? Term {
                    auxTerm.position = index
                    aux.append(auxTerm)
                }
            }
            self.terms = aux
    }

}

extension EditTermsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let term = terms[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as LabelTableViewCell
        cell.nameLabel.text = term.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let term = terms[indexPath.row]
            termsToBeDeleted.append(term)
            terms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            // tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        terms.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        updatePositions()
    }
    
}
