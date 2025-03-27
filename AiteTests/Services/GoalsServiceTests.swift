//
//  GoalsServiceTests.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//

import Foundation
import Testing

@testable import Aite

@Suite struct GoalsServiceTests {
    let fakeDefaults = FakeUserDefaults()
    let goalsService: GoalsService

    init() {
        goalsService = GoalsService(defaults: fakeDefaults)
    }

    @Test func getLastActivityDate_whenValueExists_returnsDate() {
        let now = Date()
        fakeDefaults.set(now, forKey: GoalsService.DefaultsKeys.lastActivityDate)

        let result = goalsService.getLastActivityDate()
        #expect(result == now)
        fakeDefaults.clearStore()
    }

    @Test func getLastActivityDate_whenNoValueExists_returnsNil() {
        let result = goalsService.getLastActivityDate()
        #expect(result == nil)
    }

    @Test func setLastActivityDate_setsDateInDefaults() {
        let now = Date()
        try! goalsService.setLastActivityDate(now)

        let stored =
            fakeDefaults.object(forKey: GoalsService.DefaultsKeys.lastActivityDate) as? Date
        #expect(stored == now)
        fakeDefaults.clearStore()
    }

    @Test func setLastActivityDate_throwsError_whenSettingAFutureDate() {
        let oneHourFromNow = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!

        #expect(throws: TimespaceError.self) {
            try goalsService.setLastActivityDate(oneHourFromNow)
        }
    }

    @Test func getCostPerMonth_whenNoValueExists_returnsNil() {
        let result = goalsService.getCostPerMonth()
        #expect(result == nil)
    }

    @Test func getCostPerMonth_whenValueExists_returnsValue() {
        let cost = 100.0
        fakeDefaults.set(cost, forKey: GoalsService.DefaultsKeys.costPerMonth)

        let result = goalsService.getCostPerMonth()
        #expect(result == cost)
        fakeDefaults.clearStore()
    }

    @Test func setCostPerMonth_setsCostInDefaults() {
        let cost = 150.0
        goalsService.setCostPerMonth(cost)

        let stored = fakeDefaults.object(forKey: GoalsService.DefaultsKeys.costPerMonth) as? Double
        #expect(stored == cost)
        fakeDefaults.clearStore()
    }

    @Test func getAllGoals_whenNoGoalsExist_returnsEmptyArray() {
        let goals = goalsService.getAllGoals()
        #expect(goals.isEmpty)
    }

    @Test func getAllGoals_whenGoalsExist_returnsGoals() {
        let goal = Goal(name: "Test Goal", target: .timeframe(days: 30))
        let goals = [goal]
        let encoded = try? JSONEncoder().encode(goals)
        fakeDefaults.set(encoded, forKey: GoalsService.DefaultsKeys.goals)

        let result = goalsService.getAllGoals()
        #expect(result.count == 1)
        #expect(result[0].id == goal.id)
        #expect(result[0].name == goal.name)
        if case .timeframe(let days, _, _, _) = result[0].construction {
            #expect(days == 30)
        }
        fakeDefaults.clearStore()
    }

    @Test func addGoal_addsTimeframeGoalToDefaults() {
        let goal = Goal(name: "Exercise Goal", target: .timeframe(days: 30))
        try! goalsService.addGoal(goal)

        let goals = goalsService.getAllGoals()
        #expect(goals.count == 1)
        #expect(goals[0].id == goal.id)
        #expect(goals[0].name == goal.name)
        if case .timeframe(let days, _, _, _) = goals[0].construction {
            #expect(days == 30)
        }
        fakeDefaults.clearStore()
    }

    @Test func addGoal_addsMoneyGoalToDefaults() {
        let goal = Goal(name: "Savings Goal", target: .money(1000.0))
        try! goalsService.addGoal(goal)

        let goals = goalsService.getAllGoals()
        #expect(goals.count == 1)
        #expect(goals[0].id == goal.id)
        #expect(goals[0].name == goal.name)
        if case .money(let amount) = goals[0].construction {
            #expect(amount == 1000.0)
        }
        fakeDefaults.clearStore()
    }

    @Test func removeGoal_removesGoalFromDefaults() {
        let goal = Goal(name: "Exercise Goal", target: .timeframe(weeks: 4))
        try! goalsService.addGoal(goal)

        try! goalsService.removeGoal(goal)

        let goals = goalsService.getAllGoals()
        #expect(goals.isEmpty)
    }

    @Test func removeGoal_whenMultipleGoals_removesOnlySpecifiedGoal() {
        let goal1 = Goal(name: "Exercise Goal", target: .timeframe(weeks: 4))
        let goal2 = Goal(name: "Savings Goal", target: .money(500.0))
        try! goalsService.addGoal(goal1)
        try! goalsService.addGoal(goal2)

        try! goalsService.removeGoal(goal1)

        let goals = goalsService.getAllGoals()
        #expect(goals.count == 1)
        #expect(goals[0].id == goal2.id)
        #expect(goals[0].name == "Savings Goal")
        if case .money(let amount) = goals[0].construction {
            #expect(amount == 500.0)
        }
        fakeDefaults.clearStore()
    }

    @Test func removeAllGoals_removesAllGoalsFromDefaults() {
        let goal1 = Goal(name: "Exercise Goal", target: .timeframe(months: 3))
        let goal2 = Goal(name: "Savings Goal", target: .money(2000.0))
        try! goalsService.addGoal(goal1)
        try! goalsService.addGoal(goal2)

        goalsService.removeAllGoals()

        let goals = goalsService.getAllGoals()
        #expect(goals.isEmpty)
    }
}
