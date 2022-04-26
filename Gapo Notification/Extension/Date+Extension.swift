//
//  Date+Extension.swift
//  Gapo Notification
//
//  Created by Nguyen Huu Tien on 26/04/2022.
//

import Foundation

extension Date {
    
    func stringFromDateFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
