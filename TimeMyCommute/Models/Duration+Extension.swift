//
//  Duration+Extension.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/11/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

extension Duration {
    func populate(with seconds: Double, in component: Component) {
        self.dateRecorded = Date()
        self.seconds = seconds
        self.component = component
    }
    var minutes: Int {
        return Int(seconds) / 60
    }
}
