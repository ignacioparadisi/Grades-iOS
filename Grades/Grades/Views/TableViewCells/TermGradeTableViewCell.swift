//
//  TermGradeTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 11/2/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermGradeTableViewCell: UITableViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        selectionStyle = .none
    }
    
    func configure(with term: Gradable) {
        backgroundColor = UIColor.getColor(for: term)
    }

}
