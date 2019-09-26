//
//  IPDatePickerButton.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class IPDatePickerTextField: IPTextField {
    
    private var wasInitialized = false
    private let dateFormatter = DateFormatter()
    private let datePicker: UIDatePicker =  {
        let picker = UIDatePicker()
        return picker
    }()
    var datePickerMode: UIDatePicker.Mode = .date {
        didSet {
            datePicker.datePickerMode = datePickerMode
        }
    }
    var dateFormat: DateFormat = .shortDate {
        didSet {
            dateFormatter.dateFormat = DateFormat.shortDate.rawValue
        }
    }
    var date: Date? {
        didSet {
            if let date = date {
                datePicker.date = date
                text = dateFormatter.string(from: date)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !wasInitialized {
            initialize()
            wasInitialized = true
        }
    }
    
    internal override func initialize() {
        super.initialize()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickDate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(named: "accentColor")
        toolbar.sizeToFit()
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        inputAccessoryView = toolbar
        inputView = datePicker
        
    }
    
    @objc private func pickDate() {
        date = datePicker.date
        _ = resignFirstResponder()
    }
    
}
