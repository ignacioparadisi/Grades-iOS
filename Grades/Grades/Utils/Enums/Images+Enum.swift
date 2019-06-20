//
//  Images+Enum.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

enum ImageNames: String {
    case home = "home"
    case grades = "grades"
    case calendar = "calendar"
//    case calendar2 = "calendar2"
//    case calendar3 = "calendar3"
//    case calendar4 = "calendar4"
//    case calendar5 = "calendar5"
//    case calendar6 = "calendar6"
//    case calendar7 = "calendar7"
//    case calendar8 = "calendar8"
//    case calendar9 = "calendar9"
//    case calendar10 = "calendar10"
//    case calendar11 = "calendar11"
//    case calendar12 = "calendar12"
//    case calendar13 = "calendar13"
//    case calendar14 = "calendar14"
//    case calendar15 = "calendar15"
//    case calendar16 = "calendar16"
//    case calendar17 = "calendar17"
//    case calendar18 = "calendar18"
//    case calendar19 = "calendar19"
//    case calendar20 = "calendar20"
//    case calendar21 = "calendar21"
//    case calendar22 = "calendar22"
//    case calendar23 = "calendar23"
//    case calendar24 = "calendar24"
//    case calendar25 = "calendar25"
//    case calendar26 = "calendar26"
//    case calendar27 = "calendar27"
//    case calendar28 = "calendar28"
//    case calendar29 = "calendar29"
//    case calendar30 = "calendar30"
//    case calendar31 = "calendar31"
}

extension UIImage {
    convenience init?(named imageName: ImageNames) {
        self.init(named: imageName.rawValue)
    }
}
