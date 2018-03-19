//
//  Component+Extension.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/11/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

enum ComponentValidity {
    case valid
    case invalidName
    case invalidDuration
}

extension Component {
    var averageRecordedDurationInSeconds: TimeInterval? {
        guard let durations = self.recordedDurations?.allObjects as? [Duration], !durations.isEmpty else { return nil }
        return durations.reduce(0){$0 + $1.seconds} / Double(durations.count)
    }
    var averageRecordedDurationInMinutes: Int? {
        guard let av = averageRecordedDurationInSeconds else { return nil }
        return Int(av) / 60
    }
    var validity: ComponentValidity {
        guard self.name != "" else { return .invalidName }
        guard self.estimatedTimeInMinutes != 0 else { return .invalidDuration }
        print(estimatedTimeInMinutes, "It is \(estimatedTimeInMinutes != 0) that the estimatedTimeInMinutes is not 0")
        return .valid
    }
}
