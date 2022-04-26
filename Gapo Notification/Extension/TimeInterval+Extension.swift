//
//  TimeInterval+Extension.swift
//  Gapo Notification
//
//  Created by Nguyen Huu Tien on 26/04/2022.
//

import Foundation

extension Int {
    
    func getNotiTimeString(format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval.init(self))
        return date.stringFromDateFormat(format)
    }
}
