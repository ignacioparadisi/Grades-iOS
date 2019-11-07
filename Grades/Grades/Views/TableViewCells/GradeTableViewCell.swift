//
//  GradeTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 11/7/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradeView: UIView {
    
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
    private var translucentGradeImageView: UIImageView = UIImageView()
    
    init(_ gradable: Gradable) {
        super.init(frame: .zero)
        initialize()
        backgroundColor = UIColor.getColor(for: gradable.grade, maxGrade: gradable.maxGrade, minGrade: gradable.minGrade)
        motivationLabel.text = "You are doing great! Keep going."
        gradeLabel.text = "\(gradable.grade)"
        translucentGradeImageView.image = imageWith(name: gradable.grade.toString(decimals: 0), size: frame.size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        layer.cornerRadius = 10
        
        addSubview(translucentGradeImageView)
        translucentGradeImageView.backgroundColor = .yellow
        translucentGradeImageView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
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

class GradeTableViewCell: UITableViewCell, ReusableView {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        selectionStyle = .none
        backgroundColor = .none
    }
    
    func configure(with gradable: Gradable) {
        let leftView = GradeView(gradable)
        let rightView = GradeView(gradable)
        
        let stackView = UIStackView(arrangedSubviews: [leftView, rightView])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .bottomToSuperview()
            .height(to: stackView.widthAnchor, multiplier: 0.5)
            .activate()
    }

}
