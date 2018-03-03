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
    var averageRecordedTime: TimeInterval? {
        var finalTime: Double = 0
        for component in sortedComponents {
            guard let avgTime = component.averageRecordedDuration else { return nil }
            finalTime += avgTime
        }
        return finalTime
    }
}
