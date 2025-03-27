//
//  Utils.swift
//  Aite
//
//  Created by Jose Tlacuilo on 26/03/25.
//
import Foundation

struct Utils {
    static func timeIntervalToString(from: Date, to: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .weekOfMonth, .day, .hour], from: from, to: to)

        let timeComponents: [(component: Int?, writer: (Int) -> String)] = [
            (components.year, { (value: Int) -> String in String(localized: "\(value) Year") }),
            (components.month, { (value: Int) -> String in String(localized: "\(value) Month") }),
            (
                components.weekOfMonth,
                { (value: Int) -> String in String(localized: "\(value) Week") }
            ),
            (components.day, { (value: Int) -> String in String(localized: "\(value) Day") }),
            (components.hour, { (value: Int) -> String in String(localized: "\(value) Hour") }),
        ]

        let progressParts =
            timeComponents
            .compactMap { component, writer -> String? in
                guard let value = component, value > 0 else { return nil }
                return writer(value)
            }

        if progressParts.isEmpty {
            return String(localized: "0 Hours")
        }

        return progressParts.joined(separator: " ")
    }

    static func calculateSavedAmount(from: Date, to: Date, costPerMonth: Double) -> Double {
        let timeInterval = to.timeIntervalSince(from)
        let daysInMonth = 30.44  // Average days in a month
        let secondsInMonth = daysInMonth * 24 * 60 * 60

        let monthsPassed = timeInterval / secondsInMonth
        return costPerMonth * monthsPassed
    }
}
