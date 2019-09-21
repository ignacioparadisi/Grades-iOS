//
//  SubjectCardCollectionViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftUI

class SubjectCardCollectionViewCell: UICollectionViewCell, ReusableView {
    
    /// The radius of the graph
    private let circleRadius: CGFloat = 26
    /// Margin for leading and trailing
    private let margin: CGFloat = 16
    /// Label for the subject's name
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.text = "Subject Name"
        return label
    }()
    private var progressRingView: ProgressRingView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Adds all the components to the view
    private func initialize() {
//        let bottomLine = UIView()
//        bottomLine.backgroundColor = .systemGray3
//        addSubview(bottomLine)
//        bottomLine.anchor
//            .trailing(to: trailingAnchor)
//            .bottom(to: bottomAnchor)
//            .leading(to: leadingAnchor, constant: margin)
//            .height(constant: 1)
//            .activate()
//
//        addSubview(nameLabel)
//        nameLabel.anchor
//            .top(to: topAnchor)
//            .leading(to: leadingAnchor, constant: margin)
//            .bottom(to: bottomAnchor, constant: -10)
//            .centerY(to: centerYAnchor)
//            .activate()
//
//        progressRingView = ProgressRingView(radius: circleRadius)
//        addSubview(progressRingView)
//        progressRingView.anchor
//            .leading(to: nameLabel.trailingAnchor, constant: 8)
//            .trailing(to: trailingAnchor, constant: -margin)
//            .centerY(to: centerYAnchor)
//            .activate()
    }
    
    
    /// Configures the cell with the subject information and adds the semi-circle that is in the front
    ///
    /// - Parameter subject: Subject to be displayed
    func configure(with subject: Subject) {
        if let view = UIHostingController(rootView: SubjectCardView(subject: subject)).view {
            addSubview(view)
            view.backgroundColor = .clear
            view.anchor.edgesToSuperview().activate()
        }
//        nameLabel.text = subject.name
//
//        progressRingView.removeFromSuperview()
//        progressRingView = ProgressRingView(radius: circleRadius)
//        addSubview(progressRingView)
//        progressRingView.anchor
//            .leading(to: nameLabel.trailingAnchor, constant: 8)
//            .trailing(to: trailingAnchor, constant: -margin)
//            .centerY(to: centerYAnchor)
//            .activate()
//        progressRingView.configure(with: subject)
    }
}

struct SubjectCardView: View {
    let subject: Subject
    var body: some View {
        VStack {
            HStack {
                Text(subject.name)
                Spacer()
                GradableCharView(gradable: subject).frame(width: 52, height: 52)
            }
            Spacer()
            Rectangle().fill(Color(.systemGray3)).frame(height: 1)
        }
        
        .padding()
    }
}
