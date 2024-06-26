//
//  TermDateTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 8/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftUI

class TermDateTableViewCell: UITableViewCell, ReusableView {

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
    }
    
    func configure(startDate: Date, endDate: Date) {
        if let view = UIHostingController(rootView: TermDatesView(startDate: startDate, endDate: endDate)).view {
            subviews.last?.removeFromSuperview()
            addSubview(view)
            view.anchor.edgesToSuperview().activate()
        }
    }
}

struct TermDatesView: View {
    var startDate: Date
    var endDate: Date
    private let dateFormatter: DateFormatter = DateFormatter()
    
    var body: some View {
        HStack {
            Spacer()
            Text(dateFormatter.string(from: startDate, format: .shortDate))
            Spacer()
            Divider().frame(width: 2)
            Spacer()
            Text(dateFormatter.string(from: endDate, format: .shortDate))
            Spacer()
        }
        .padding()
    }
}
