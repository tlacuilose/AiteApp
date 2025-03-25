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
        }
    }
    @Published var progress: String = ""
    
    init(goalsService: GoalsServiceProtocol = GoalsService.shared) {
        self.goalsService = goalsService
        
        loadData()
    }
    
    private func loadData() {
        lastActivityDate = goalsService.getLastActivityDate()
    }
    
    private func updateProgress() {
        guard let lastActivity = lastActivityDate else {
            progress = String(localized: "No activity recorded")
            return
        }
        
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfMonth, .day, .hour], from: lastActivity, to: now)
        
        let timeComponents: [(component: Int?, writer: (Int) -> String)] = [
            (components.year,  {(value: Int) -> String in String(localized: "\(value) Year")}),
            (components.month,  {(value: Int) -> String in String(localized: "\(value) Month")}),
            (components.weekOfMonth,  {(value: Int) -> String in String(localized: "\(value) Week")}),
            (components.day,  {(value: Int) -> String in String(localized: "\(value) Day")}),
            (components.hour,  {(value: Int) -> String in String(localized: "\(value) Hour")}),
        ]
        
        let progressParts = timeComponents
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
    
    func updateLastActivityDate(_ date: Date) throws {
        try goalsService.setLastActivityDate(date)
        
        lastActivityDate = date
    }
}
