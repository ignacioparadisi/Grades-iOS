//
//  GradableTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftUI

class GradableTableViewCell: UITableViewCell, ReusableView {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Adds all the components to the view
    private func initialize() {
        accessoryType = .disclosureIndicator
    }
    
    
    /// Configures the cell with the gradable information and adds the semi-circle that is in the front
    ///
    /// - Parameter gradable: Gradable to be displayed
    func configure(with gradable: Gradable) {
        if let view = UIHostingController(rootView: GradableView(gradable: gradable)).view {
            addSubview(view)
            view.backgroundColor = .clear
            view.anchor.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)).activate()
        }
    }
    
}

struct GradableView: View {
    var gradable: Gradable
    var body: some View {
        HStack {
            Text(gradable.name)
            Spacer()
            GradableChartView(gradable: gradable)
                .frame(width: 60, height: 60)
        }
        .padding([.horizontal])
        .padding([.vertical], 7)
    }
}

struct GradableChartView: View {
    var gradable: Gradable
    /// The start angle of the grade graph
    private let startAngle: CGFloat = 0.0
    /// The end angle of the grade graph
    private let endAngle: CGFloat = 0.66
    private let lineWidth: CGFloat = 7
    private var animation: Animation {
        Animation.easeInOut(duration: 0.7)
    }
    @State private var gradableEndAngle: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .trim(from: self.startAngle, to: self.endAngle)
                    .stroke(Color(.tertiarySystemGroupedBackground), style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase: 0))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(Angle(degrees: -210))
                    .offset(x: 0, y: 1)
                
                Circle()
                    .trim(from: self.startAngle, to: self.gradableEndAngle)
                    .stroke(Color(UIColor.getColor(for: self.gradable)), style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase: 0))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(Angle(degrees: -210))
                    .offset(x: 0, y: 1)
                    .onAppear {
                        self.animateRing(self.gradable)
                }
                
                Text(self.gradable.grade.toString(decimals: self.gradable.decimals))
            }
        }
        .padding(.top, 9)
    }
    
    func animateRing(_ gradable: Gradable) {
        withAnimation(self.animation) {
            self.gradableEndAngle = (CGFloat(self.gradable.grade) * self.endAngle) / CGFloat(self.gradable.maxGrade)
        }
    }
}
