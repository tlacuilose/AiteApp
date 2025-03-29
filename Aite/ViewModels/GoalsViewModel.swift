//
//  GoalsViewModel.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//
import Foundation

class GoalsViewModel: ObservableObject {
    private let goalsService: GoalsServiceProtocol

    @Published private(set) var lastActivityDate: Date? {
        didSet {
            updateProgress()
            updateSavedAmount()
        }
    }
    @Published private(set) var costPerMonth: Double = 0.0 {
        didSet {
            updateSavedAmount()
        }
    }
    @Published private(set) var progress: String = ""
    @Published private(set) var savedAmount: Double = 0.0
    @Published private(set) var goals: [Goal] = []

    init(goalsService: GoalsServiceProtocol = GoalsService.shared) {
        self.goalsService = goalsService

        loadData()
    }

    func loadData() {
        lastActivityDate = goalsService.getLastActivityDate()
        costPerMonth = goalsService.getCostPerMonth() ?? 0.0
        goals = goalsService.getAllGoals()
    }

    func updateLastActivityDate(_ date: Date) throws {
        try goalsService.setLastActivityDate(date)

        lastActivityDate = date
    }

    func updateCostPerMonth(_ cost: Double) throws {
        try goalsService.setCostPerMonth(cost)

        costPerMonth = cost
    }

    func addGoal(_ goal: Goal) throws {
        try goalsService.addGoal(goal)

        loadData()
    }

    func removeGoal(_ goal: Goal) throws {
        try goalsService.removeGoal(goal)

        loadData()
    }

    func removeAllGoals() {
        goalsService.removeAllGoals()

        loadData()
    }

    func moveGoals(from: IndexSet, to: Int) throws {
        try goalsService.moveGoals(from: from, to: to)

        loadData()
    }

    private func updateProgress() {
        guard let lastActivity = lastActivityDate else {
            progress = String(localized: "No activity recorded")
            return
        }

        progress = Utils.timeIntervalToString(from: lastActivity, to: Date())
    }

    private func updateSavedAmount() {
        guard let lastActivity = lastActivityDate else {
            savedAmount = 0.0
            return
        }

        savedAmount = Utils.calculateSavedAmount(
            from: lastActivity, to: Date(), costPerMonth: costPerMonth)
    }

}
