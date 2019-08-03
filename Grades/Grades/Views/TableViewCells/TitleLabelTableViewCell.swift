//
//  TitleLabelTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TitleLabelTableViewCell: UITableViewCell, ReusableView {
    
    var titleLabel: IPTitleLabel = IPTitleLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        selectionStyle = .none
        isUserInteractionEnabled = false
        addSubview(titleLabel)
        titleLabel.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 10, left: 16, bottom: -8, right: -16))
            .activate()
    }

}
