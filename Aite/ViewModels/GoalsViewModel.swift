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

        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .weekOfMonth, .day, .hour], from: lastActivity, to: now)

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
            progress = String(localized: "0 Hours")
            return
        }

        progress = progressParts.joined(separator: " ")
    }

    private func updateSavedAmount() {
        guard let lastActivity = lastActivityDate else {
            savedAmount = 0.0
            return
        }

        let now = Date()
        let timeInterval = now.timeIntervalSince(lastActivity)
        let daysInMonth = 30.44  // Average days in a month
        let secondsInMonth = daysInMonth * 24 * 60 * 60

        let monthsPassed = timeInterval / secondsInMonth
        savedAmount = costPerMonth * monthsPassed
    }

}
