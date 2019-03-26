//
//  UnixTime.swift
//  skirun
//
//  Created by AISLAB on 26.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import Foundation

typealias UnixTime = Int

extension UnixTime {
    private func formatType(form: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = form
        return dateFormatter
    }
    var dateFull: Date {
        return Date(timeIntervalSince1970: Double(self))
    }
    var toHour: String {
        return formatType(form: "HH:mm").string(from: dateFull)
    }
    var toDay: String {
        return formatType(form: "MM/dd/yyyy").string(from: dateFull)
    }
}

