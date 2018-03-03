//
//  DateHelper.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/11/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

struct DateHelper {
    private init() {}
    private let dateComponentsFormatter: DateComponentsFormatter = {
        let dcf = DateComponentsFormatter()
        dcf.allowedUnits = [.hour, .minute, .second]
        dcf.unitsStyle = .positional
        dcf.zeroFormattingBehavior = .pad
        return dcf
    }()
    static let manager = DateHelper()
    func getFormattedTime(from timeInterval: TimeInterval) -> String {
        return dateComponentsFormatter.string(from: timeInterval) ?? "Error"
    }
}
