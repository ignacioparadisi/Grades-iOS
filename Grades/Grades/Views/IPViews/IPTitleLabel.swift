//
//  TitleLabel.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class IPTitleLabel: UILabel {

    private var wasInitialized = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !wasInitialized {
            initialize()
            wasInitialized = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if !wasInitialized {
            initialize()
            wasInitialized = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if !wasInitialized {
            initialize()
            wasInitialized = true
        }
    }
    
    func initialize() {
        font = UIFont.metrics(style: .bold, size: 28.0, forTextSyle: .title1)
        adjustsFontForContentSizeCategory = true
    }
    
}
