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
    
    /// Configures the cell with the subject information and adds the semi-circle that is in the front
    ///
    /// - Parameter subject: Subject to be displayed
    func configure(with subject: Subject) {
        if let view = UIHostingController(rootView: SubjectCardView(subject: subject)).view {
            subviews.last?.removeFromSuperview()
            addSubview(view)
            view.backgroundColor = .clear
            view.anchor.edgesToSuperview(insets: UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)).activate()
        }
    }
}

struct SubjectCardView: View {
    let subject: Subject
    var body: some View {
        VStack {
            HStack {
                Text(subject.name)
                Spacer()
                GradableChartView(gradable: subject).frame(width: 60, height: 60)
            }
            Spacer()
            Rectangle().fill(Color(.systemGray3)).frame(height: 1)
        }
        .padding()
    }
}
