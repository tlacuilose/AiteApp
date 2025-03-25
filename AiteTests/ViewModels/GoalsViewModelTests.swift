//
//  GoalsViewModelTests.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//
//  The Test Target's locale should be English

import Foundation
import Testing

@testable import Aite

@Suite struct GoalsViewModelTests {
    let fakeGoalsService = FakeGoalsService()
    let viewModel: GoalsViewModel
    let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!

    init() {
        fakeGoalsService.clearThrowables()
        fakeGoalsService.clearLastActivityDate()
        fakeGoalsService.clearCostPerMonth()

        try! fakeGoalsService.setLastActivityDate(oneMonthAgo)
        viewModel = GoalsViewModel(goalsService: fakeGoalsService)
    }

    @Test func updateLastActivityDate_whenInThePast_updatesActivityAndProgress() {
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        try! viewModel.updateLastActivityDate(twoDaysAgo)

        #expect(viewModel.lastActivityDate == twoDaysAgo)
        #expect(viewModel.progress == "2 Days")
    }

    @Test func updateLastActivityDate_whenInTheFuture_throws() {
        // The service has the responsability on why it failed, that is tested there
        fakeGoalsService.enableThrowables()

        let oneDayFromNow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        #expect(throws: (any Error).self) {
            try viewModel.updateLastActivityDate(oneDayFromNow)
        }

        fakeGoalsService.clearThrowables()
    }

    @Test func didSetCostPerMonth_whenCalled_updatesCost() {
        let amount = 100.0
        viewModel.costPerMonth = amount

        #expect(fakeGoalsService.getCostPerMonth() == amount)
        #expect(viewModel.savedAmount / amount > 0.90)
    }
}

@Suite struct GoalsViewModelInitTests {
    let fakeGoalsService = FakeGoalsService()

    @Test func init_whenNoDefaultsProvided_returnsNils() {
        fakeGoalsService.clearLastActivityDate()
        fakeGoalsService.clearCostPerMonth()

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == nil)
        #expect(viewModel.costPerMonth == 0.0)
        #expect(viewModel.progress == String(localized: "No activity recorded"))
    }

    @Test func init_whenDefaultsProvided_returnsDefaults() {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let costPerMonth = 100.0

        try! fakeGoalsService.setLastActivityDate(oneMonthAgo)
        fakeGoalsService.setCostPerMonth(costPerMonth)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == oneMonthAgo)
        #expect(viewModel.costPerMonth == 100)
        #expect(viewModel.progress == "1 Month")
        // Each month will have a difference, worse is February at 10% diff
        #expect(viewModel.savedAmount / costPerMonth > 0.90)
    }

    @Test func loadProgress_whenActivityDateIsToday_returnsZeroHours() {
        let now = Date()
        try! fakeGoalsService.setLastActivityDate(now)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == now)
        #expect(viewModel.progress == "0 Hours")
    }

    @Test func loadProgress_whenActivityDateIs1HourAgo_returnsHour() {
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
        try! fakeGoalsService.setLastActivityDate(oneHourAgo)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == oneHourAgo)
        #expect(viewModel.progress == "1 Hour")
    }

    @Test func loadProgress_whenActivityDateIs2HoursAgo_returnsHours() {
        let twoHoursAgo = Calendar.current.date(byAdding: .hour, value: -2, to: Date())!
        try! fakeGoalsService.setLastActivityDate(twoHoursAgo)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == twoHoursAgo)
        #expect(viewModel.progress == "2 Hours")
    }

    @Test func loadProgress_whenActivityDateIs2DaysAgo_returnsDays() {
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        try! fakeGoalsService.setLastActivityDate(twoDaysAgo)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == twoDaysAgo)
        #expect(viewModel.progress == "2 Days")
    }

    @Test func loadProgress_whenActivityDateIs2WeeksAgo_returnsWeeks() {
        let twoWeeksAgo = Calendar.current.date(byAdding: .weekOfMonth, value: -2, to: Date())!
        try! fakeGoalsService.setLastActivityDate(twoWeeksAgo)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == twoWeeksAgo)
        #expect(viewModel.progress == "2 Weeks")
    }

    @Test func loadProgress_whenActivityDateIs2MonthsAgo_returnsMonths() {
        let twoMonthsAgo = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        try! fakeGoalsService.setLastActivityDate(twoMonthsAgo)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == twoMonthsAgo)
        #expect(viewModel.progress == "2 Months")
    }

    @Test func loadProgress_whenActivityDateIs2YearsAgo_returnsYears() {
        let twoYearsAgo = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
        try! fakeGoalsService.setLastActivityDate(twoYearsAgo)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == twoYearsAgo)
        #expect(viewModel.progress == "2 Years")
    }

    @Test func loadProgress_whenActivityDateIsComplex_returnsMultipleUnits() {
        var dateComponents = DateComponents()
        dateComponents.year = -1
        dateComponents.month = -2
        dateComponents.day = -3

        let complexDate = Calendar.current.date(byAdding: dateComponents, to: Date())!
        try! fakeGoalsService.setLastActivityDate(complexDate)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == complexDate)
        #expect(viewModel.progress == "1 Year 2 Months 3 Days")
    }
}
