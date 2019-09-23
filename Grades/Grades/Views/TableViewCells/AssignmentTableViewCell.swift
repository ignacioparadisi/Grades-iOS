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
        selectionStyle = .none
    }
    
    
    /// Configures the cell with the gradable information and adds the semi-circle that is in the front
    ///
    /// - Parameter gradable: Gradable to be displayed
    func configure(with assignment: Assignment) {
        if let view = UIHostingController(rootView: AssignmentView(assignment: assignment)).view {
            subviews.last?.removeFromSuperview()
            addSubview(view)
            view.anchor.edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 16, bottom: -8, right: -16)).activate()
        }

    }

}


struct AssignmentView: View {
    var assignment: Assignment
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy - h:mma"
        return formatter
    }()
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(assignment.name)
                HStack{
                    Divider()
                        .frame(width: 2)
                        .background(getDividerColor())
                        
                    Text(dateFormatter.string(from: assignment.deadline))
                        .font(.body)
                        .foregroundColor(getDateTextColor())
                    Spacer()
                }
            }
            GradableChartView(gradable: assignment).frame(width: 52, height: 52)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
    }
    
    private func getDividerColor() -> Color {
        return (assignment.deadline >= Date()) ? Color(UIColor.accentColor!) : Color(.systemGray3)
    }
    
    private func getDateTextColor() -> Color {
        return (assignment.deadline >= Date()) ? Color(.label) : Color(.secondaryLabel)
    }
}
