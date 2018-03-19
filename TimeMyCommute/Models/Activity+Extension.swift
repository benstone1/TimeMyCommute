//
//  Activity+Extension.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/11/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

extension Activity {
    var sortedComponents: [Component] {
        return (self.components?.allObjects as! [Component]).sorted{$0.index < $1.index}
    }
    var averageRecordedTimeInSeconds: TimeInterval? {
        var finalTime: Double = 0
        for component in sortedComponents {
            guard let avgTime = component.averageRecordedDurationInSeconds else { return nil }
            finalTime += avgTime
        }
        return finalTime
    }
    var averageRecordedTimeInMinutes: Int? {
        guard let avTime = averageRecordedTimeInSeconds else {return nil }
        return Int(avTime) / 60
    }
    func toCellFormattedString() -> String {
        var str = "\(self.name ?? "No name")\n"
        for component in self.sortedComponents {
            str +=
            """
            \(component.name ?? "no name")
                Estimated time: \(component.estimatedTimeInMinutes)
                Actual time: \(component.averageRecordedDurationInSeconds?.description ?? "No data yet!")
            """
        }
        return str
    }
}
