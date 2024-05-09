//
//  TermGradeTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 11/2/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermGradeTableViewCell: UITableViewCell, ReusableView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Grade".localized
        return label
    }()
    private var motivationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 3
        return label
    }()
    private var gradeLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    private var translucentGradeLabel: UILabel =  {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.2)
        label.textAlignment = .right
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
        
        addSubview(translucentGradeLabel)
        translucentGradeLabel.anchor
            .topToSuperview()
            .trailingToSuperview(constant: -16)
            .bottomToSuperview()
            .leadingToSuperview(constant: 16)
            .activate()
        
        let stackView: UIStackView = UIStackView(arrangedSubviews: [gradeLabel, titleLabel, motivationLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.anchor
            .leadingToSuperview(constant: 16)
            .trailingToSuperview(constant: -16)
            .centerToSuperview()
            .activate()
    }
    
    func configure(with grade: Float) {
        backgroundColor = UIColor.getColor(for: grade, maxGrade: 20, minGrade: 10)
        motivationLabel.text = "You are doing great! Keep going."
        gradeLabel.text = "\(grade)"
        translucentGradeLabel.font = UIFont.boldSystemFont(ofSize: frame.size.width / 2 * 0.9)
        translucentGradeLabel.text = grade.toString(decimals: 0)
    }
    
    func imageWith(name: String?, size: CGSize) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: size.width * 0.84, height: size.height)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.lineBreakMode = .byClipping
        nameLabel.font = UIFont.boldSystemFont(ofSize: size.width * 0.9)
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }

}
