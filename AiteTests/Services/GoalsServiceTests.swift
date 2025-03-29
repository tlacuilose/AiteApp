//
//  GoalsServiceTests.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//

import Foundation
import Testing

@testable import Aite

@Suite
struct GoalsServiceTests {
    let fakeDefaults = FakeUserDefaults()
    let goalsService: GoalsService

    init() {
        goalsService = GoalsService(defaults: fakeDefaults)
    }

    @Test
    func getLastActivityDate_whenValueExists_returnsDate() {
        let now = Date()
        fakeDefaults.set(now, forKey: GoalsService.DefaultsKeys.lastActivityDate)

        let result = goalsService.getLastActivityDate()
        #expect(result == now)
        fakeDefaults.clearStore()
    }

    @Test
    func getLastActivityDate_whenNoValueExists_returnsNil() {
        let result = goalsService.getLastActivityDate()
        #expect(result == nil)
    }

    @Test
    func setLastActivityDate_setsDateInDefaults() {
        let now = Date()
        try! goalsService.setLastActivityDate(now)

        let stored =
            fakeDefaults.object(forKey: GoalsService.DefaultsKeys.lastActivityDate) as? Date
        #expect(stored == now)
        fakeDefaults.clearStore()
    }

    @Test
    func setLastActivityDate_whenSettingAFutureDate_throwsError() {
        let oneHourFromNow = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!

        #expect(throws: TimespaceError.self) {
            try goalsService.setLastActivityDate(oneHourFromNow)
        }
    }

    @Test
    func getCostPerMonth_whenNoValueExists_returnsNil() {
        let result = goalsService.getCostPerMonth()
        #expect(result == nil)
    }

    @Test
    func getCostPerMonth_whenValueExists_returnsValue() {
        let cost = 100.0
        fakeDefaults.set(cost, forKey: GoalsService.DefaultsKeys.costPerMonth)

        let result = goalsService.getCostPerMonth()
        #expect(result == cost)
        fakeDefaults.clearStore()
    }

    @Test
    func setCostPerMonth_setsCostInDefaults() {
        let cost = 150.0
        try! goalsService.setCostPerMonth(cost)

        let stored = fakeDefaults.object(forKey: GoalsService.DefaultsKeys.costPerMonth) as? Double
        #expect(stored == cost)
        fakeDefaults.clearStore()
    }

    @Test
    func setCostPerMonth_whenIsNegative_throwsError() {
        #expect(throws: TimespaceError.self) {
            try goalsService.setCostPerMonth(-100.0)
        }
    }

    @Test
    func getAllGoals_whenNoGoalsExist_returnsEmptyArray() {
        let goals = goalsService.getAllGoals()
        #expect(goals.isEmpty)
    }

    @Test
    func getAllGoals_whenGoalsExist_returnsGoals() {
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

    @Test
    func addGoal_addsTimeframeGoalToDefaults() {
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

    @Test
    func addGoal_addsMoneyGoalToDefaults() {
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

    @Test func addGoal_whenAmountNegative_throwsError() {
        goalsService.removeAllGoals()

        let moneyGoal = Goal(name: "Money goal", target: .money(-100))
        #expect(throws: TimespaceError.negativeValue) {
            try goalsService.addGoal(moneyGoal)
        }

        let timeframeGoal = Goal(
            name: "Time goal",
            target: .timeframe(days: -1, weeks: -2, months: -3, years: -4)
        )
        #expect(throws: TimespaceError.negativeValue) {
            try goalsService.addGoal(timeframeGoal)
        }

        #expect(goalsService.getAllGoals().isEmpty)
    }

    @Test
    func removeGoal_removesGoalFromDefaults() {
        let goal = Goal(name: "Exercise Goal", target: .timeframe(weeks: 4))
        try! goalsService.addGoal(goal)

        try! goalsService.removeGoal(goal)

        let goals = goalsService.getAllGoals()
        #expect(goals.isEmpty)
    }

    @Test
    func removeGoal_whenMultipleGoals_removesOnlySpecifiedGoal() {
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

    @Test
    func removeAllGoals_removesAllGoalsFromDefaults() {
        let goal1 = Goal(name: "Exercise Goal", target: .timeframe(months: 3))
        let goal2 = Goal(name: "Savings Goal", target: .money(2000.0))
        try! goalsService.addGoal(goal1)
        try! goalsService.addGoal(goal2)

        goalsService.removeAllGoals()

        let goals = goalsService.getAllGoals()
        #expect(goals.isEmpty)
    }

    @Test
    func moveGoals_whenCanBeSaved_moveGoals() {
        let goalOne = Goal(name: "First Goal", target: .money(1))
        let goalTwo = Goal(name: "Second Goal", target: .money(2))
        let goalThree = Goal(name: "Third Goal", target: .money(3))
        let goalFour = Goal(name: "Four Goal", target: .money(4))

        try! goalsService.addGoal(goalOne)
        try! goalsService.addGoal(goalTwo)
        try! goalsService.addGoal(goalThree)
        try! goalsService.addGoal(goalFour)

        try! goalsService.moveGoals(from: IndexSet(integer: 0), to: 2)

        // 1. Remove the element at index 0 (goalOne):
        //    Array becomes: [goalTwo, goalThree, goalFour]
        // 2. The 'toOffset' parameter (1 in this case) is interpreted as an index in the final array
        //    after the removal. Because the removal shifts the array, the effective insertion index
        //    is computed as: 1 - 1 (since the source index 0 is less than the destination) = 0.
        // 3. Thus, goalOne is reinserted at index 0:
        //    Final array becomes: [goalOne, goalTwo, goalThree, goalFour]

        let goals = goalsService.getAllGoals()

        #expect(goals[0].id == goalTwo.id)
        #expect(goals[1].id == goalOne.id)
        #expect(goals[2].id == goalThree.id)
        #expect(goals[3].id == goalFour.id)

    }
}
