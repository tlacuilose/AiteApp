//
//  UtilsTests.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//

import Foundation
import Testing

@testable import Aite

@Suite struct UtilsTests {
    @Test func calculateSavedAmount_whenSameDate_returnsZero() {
        let now = Date()
        let result = Utils.calculateSavedAmount(from: now, to: now, costPerMonth: 100.0)
        #expect(result == 0.0)
    }

    @Test func calculateSavedAmount_whenOneMonthApart_returnsCostPerMonth() {
        let now = Date()
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        let costPerMonth = 100.0
        let result = Utils.calculateSavedAmount(
            from: oneMonthAgo, to: now, costPerMonth: costPerMonth)
        // Due to average month length calculation (30.44 days), we allow for small difference
        #expect(result / costPerMonth > 0.90)
        #expect(result / costPerMonth < 1.10)
    }

    @Test func calculateSavedAmount_whenTwoMonthsApart_returnsDoubleCostPerMonth() {
        let now = Date()
        let twoMonthsAgo = Calendar.current.date(byAdding: .month, value: -2, to: now)!
        let costPerMonth = 100.0
        let result = Utils.calculateSavedAmount(
            from: twoMonthsAgo, to: now, costPerMonth: costPerMonth)
        // Due to average month length calculation (30.44 days), we allow for small difference
        #expect(result / (costPerMonth * 2) > 0.90)
        #expect(result / (costPerMonth * 2) < 1.10)
    }

    @Test func timeIntervalToString_whenCurrentDate_returnsZeroHours() {
        let now = Date()
        let result = Utils.timeIntervalToString(from: now, to: now)
        #expect(result == "0 Hours")
    }

    @Test func timeIntervalToString_when1HourAgo_returnsHour() {
        let now = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: now)!
        let result = Utils.timeIntervalToString(from: oneHourAgo, to: now)
        #expect(result == "1 Hour")
    }

    @Test func timeIntervalToString_when2HoursAgo_returnsHours() {
        let now = Date()
        let twoHoursAgo = Calendar.current.date(byAdding: .hour, value: -2, to: now)!
        let result = Utils.timeIntervalToString(from: twoHoursAgo, to: now)
        #expect(result == "2 Hours")
    }

    @Test func timeIntervalToString_when2DaysAgo_returnsDays() {
        let now = Date()
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: now)!
        let result = Utils.timeIntervalToString(from: twoDaysAgo, to: now)
        #expect(result == "2 Days")
    }

    @Test func timeIntervalToString_when2WeeksAgo_returnsWeeks() {
        let now = Date()
        let twoWeeksAgo = Calendar.current.date(byAdding: .weekOfMonth, value: -2, to: now)!
        let result = Utils.timeIntervalToString(from: twoWeeksAgo, to: now)
        #expect(result == "2 Weeks")
    }

    @Test func timeIntervalToString_when2MonthsAgo_returnsMonths() {
        let now = Date()
        let twoMonthsAgo = Calendar.current.date(byAdding: .month, value: -2, to: now)!
        let result = Utils.timeIntervalToString(from: twoMonthsAgo, to: now)
        #expect(result == "2 Months")
    }

    @Test func timeIntervalToString_when2YearsAgo_returnsYears() {
        let now = Date()
        let twoYearsAgo = Calendar.current.date(byAdding: .year, value: -2, to: now)!
        let result = Utils.timeIntervalToString(from: twoYearsAgo, to: now)
        #expect(result == "2 Years")
    }

    @Test func timeIntervalToString_whenComplexDate_returnsMultipleUnits() {
        let now = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -1
        dateComponents.month = -2
        dateComponents.day = -3

        let complexDate = Calendar.current.date(byAdding: dateComponents, to: now)!
        let result = Utils.timeIntervalToString(from: complexDate, to: now)
        #expect(result == "1 Year 2 Months 3 Days")
    }
}
