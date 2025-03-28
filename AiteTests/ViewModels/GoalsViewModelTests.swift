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

    @Test func init_whenNoDefaultsProvided_returnsNils() {
        let fakeGoalsService = FakeGoalsService()
        fakeGoalsService.clearLastActivityDate()
        fakeGoalsService.clearCostPerMonth()

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == nil)
        #expect(viewModel.costPerMonth == 0.0)
        #expect(viewModel.goals.isEmpty)
        #expect(viewModel.progress == String(localized: "No activity recorded"))
    }

    @Test func init_whenDefaultsProvided_returnsDefaults() {
        let fakeGoalsService = FakeGoalsService()
        let fakeGoal = Goal(name: "Test Goal", target: .money(100))
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let costPerMonth = 100.0

        try! fakeGoalsService.setLastActivityDate(oneMonthAgo)
        fakeGoalsService.setCostPerMonth(costPerMonth)
        try! fakeGoalsService.addGoal(fakeGoal)

        let viewModel = GoalsViewModel(goalsService: fakeGoalsService)
        #expect(viewModel.lastActivityDate == oneMonthAgo)
        #expect(viewModel.costPerMonth == 100)
        #expect(viewModel.goals.count == 1)
        #expect(viewModel.goals.first == fakeGoal)
        #expect(viewModel.progress == "1 Month")
        // Each month will have a difference, worse is February at 10% diff
        #expect(viewModel.savedAmount / costPerMonth > 0.90)
        #expect(viewModel.savedAmount / costPerMonth < 1.10)
    }

    @Test func loadData_whenDataChanges_refreshes() {
        let pastLastActivityDate = fakeGoalsService.getLastActivityDate()

        try! fakeGoalsService.setLastActivityDate(Date())

        viewModel.loadData()

        #expect(viewModel.lastActivityDate != pastLastActivityDate)

        try! fakeGoalsService.setLastActivityDate(pastLastActivityDate!)
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

    @Test func addGoal_whenValidGoal_updatesGoals() {
        fakeGoalsService.removeAllGoals()

        let fakeGoal = Goal(name: "Test Goal", target: .money(100))
        try! viewModel.addGoal(fakeGoal)

        #expect(viewModel.goals.count == 1)
        #expect(viewModel.goals.first == fakeGoal)

        fakeGoalsService.removeAllGoals()
    }

    @Test func addGoal_whenServiceThrows_doesNotAddGoal() {
        fakeGoalsService.enableThrowables()
        fakeGoalsService.removeAllGoals()

        let fakeGoal = Goal(name: "Test Goal", target: .money(100))
        #expect(throws: (any Error).self) {
            try viewModel.addGoal(fakeGoal)
        }

        #expect(viewModel.goals.isEmpty)

        fakeGoalsService.clearThrowables()
    }

    @Test func removeGoal_whenGoalExists_updatesGoals() {
        fakeGoalsService.removeAllGoals()

        let goalOne = Goal(name: "Goal One", target: .money(100))
        let goalTwo = Goal(name: "Goal Two", target: .money(200))

        try! viewModel.addGoal(goalOne)
        try! viewModel.addGoal(goalTwo)

        try! viewModel.removeGoal(goalOne)

        #expect(viewModel.goals.count == 1)
        #expect(viewModel.goals.first == goalTwo)

        fakeGoalsService.removeAllGoals()
    }

    @Test func removeGoal_whenGoalIsNotSaved_doesNotUpdateGoals() {
        fakeGoalsService.removeAllGoals()

        let goalOne = Goal(name: "Goal One", target: .money(100))
        let goalTwo = Goal(name: "Goal Two", target: .money(200))

        try! viewModel.addGoal(goalOne)

        try! viewModel.removeGoal(goalTwo)

        #expect(viewModel.goals.count == 1)

        fakeGoalsService.removeAllGoals()
    }

    @Test func removeGoal_whenServiceThrows_doesNotRemoveGoal() {
        fakeGoalsService.enableThrowables()
        fakeGoalsService.removeAllGoals()

        let goalOne = Goal(name: "Goal One", target: .money(100))
        let goalTwo = Goal(name: "Goal Two", target: .money(200))

        fakeGoalsService.addGoalDoNotThrow(goalOne)
        fakeGoalsService.addGoalDoNotThrow(goalTwo)

        // Using the init to load the goals in the service
        let vm = GoalsViewModel(goalsService: fakeGoalsService)

        #expect(throws: (any Error).self) {
            try vm.removeGoal(goalOne)
        }

        #expect(vm.goals.count == 2)

        fakeGoalsService.clearThrowables()
        fakeGoalsService.removeAllGoals()
    }

    @Test func removeAllGoals_whenNotEmpty_emptiesGoals() {
        fakeGoalsService.removeAllGoals()

        let goalOne = Goal(name: "Goal One", target: .money(100))
        let goalTwo = Goal(name: "Goal Two", target: .money(200))

        try! viewModel.addGoal(goalOne)
        try! viewModel.addGoal(goalTwo)

        viewModel.removeAllGoals()

        #expect(viewModel.goals.isEmpty)
    }
}
