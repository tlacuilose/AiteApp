//
//  GoalsViewModel.swift
//  Aite
//
//  Created by Jose Tlacuilo on 23/03/25.
//
import Foundation

class GoalsViewModel: ObservableObject {
    private let goalsService: GoalsServiceProtocol

    @Published var lastActivityDate: Date? {
        didSet {
            updateProgress()
            updateSavedAmount()
        }
    }
    @Published var costPerMonth: Double = 0.0 {
        didSet {
            goalsService.setCostPerMonth(costPerMonth)
            updateSavedAmount()
        }
    }
    @Published var progress: String = ""
    @Published var savedAmount: Double = 0.0
    @Published var goals: [Goal] = []

    init(goalsService: GoalsServiceProtocol = GoalsService.shared) {
        self.goalsService = goalsService

        loadData()
    }

    func updateLastActivityDate(_ date: Date) throws {
        try goalsService.setLastActivityDate(date)

        lastActivityDate = date
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

    private func loadData() {
        lastActivityDate = goalsService.getLastActivityDate()
        costPerMonth = goalsService.getCostPerMonth() ?? 0.0
        goals = goalsService.getAllGoals()
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

        savedAmount = Utils.calculateSavedAmount(from: lastActivity, to: Date(), costPerMonth: costPerMonth)
    }

}
