//
//  AssignmentTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import SwiftUI

class AssignmentTableViewCell: UITableViewCell, ReusableView {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Adds all the components to the view
    private func initialize() {
    }
    
    
    /// Configures the cell with the gradable information and adds the semi-circle that is in the front
    ///
    /// - Parameter gradable: Gradable to be displayed
    func configure(with assignment: Assignment) {
        if let view = UIHostingController(rootView: AssignmentView(assignment: assignment)).view {
            view.backgroundColor = .clear
            subviews.last?.removeFromSuperview()
            addSubview(view)
            view.anchor.edgesToSuperview().activate()
        }

    }

}


struct AssignmentView: View {
    var assignment: Assignment
    private let dateFormatter: DateFormatter = DateFormatter()
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(assignment.name)
                HStack{
                    Divider()
                        .frame(width: 2)
                        .background(getDividerColor())
                        
                    Text(dateFormatter.string(from: assignment.deadline, format: .dateAndTime))
                        .font(.body)
                        .foregroundColor(getDateTextColor())
                    Spacer()
                }
            }
            GradableChartView(gradable: assignment).frame(width: 60, height: 60)
        }
        .padding()
    }
    
    private func getDividerColor() -> Color {
        return (assignment.deadline >= Date()) ? Color(UIColor.accentColor) : Color(.systemGray3)
    }
    
    private func getDateTextColor() -> Color {
        return (assignment.deadline >= Date()) ? Color(.label) : Color(.secondaryLabel)
    }
}
