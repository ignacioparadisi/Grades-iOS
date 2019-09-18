//
//  BarChartTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftUI

class BarChartTableViewCell: UITableViewCell, ReusableView {
    
    let margin: CGFloat = 16
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        selectionStyle = .none
    }

    func configure(with items: [Gradable]) {
        if let view = UIHostingController(rootView: BarChartView(gradables: items)).view {
               addSubview(view)
               view.anchor.edgesToSuperview(insets: UIEdgeInsets(top: 4, left: margin, bottom: -4, right: -margin)).activate()
        }
    }
    
}

struct BarChartView: View {
    var gradables: [Gradable]
    var body: some View {
        HStack {
            VStack {
                ForEach(0..<gradables.count, id: \.self) { index in
                    Text("\(index + 1). \(self.gradables[index].name)")
                        .padding(2)
                }
            }
            Spacer()
            HStack {
                Spacer()
                ForEach(0..<gradables.count, id: \.self) { index in
                    self.barView(gradable: self.gradables[index], index: index)
                }
            }
        }
        .frame(minHeight: 90)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
    }
    
    private func barView(gradable: Gradable, index: Int) -> some View {
        let heightFactor = CGFloat(gradable.grade / gradable.maxGrade)
        return VStack() {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 10)
                        .foregroundColor(Color(.systemGray3))
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 10, height: geometry.size.height * heightFactor)
                        .foregroundColor(Color(UIColor.getColor(for: gradable)))
                }
            }
            Text("\(index + 1)")
        }
    }
}

