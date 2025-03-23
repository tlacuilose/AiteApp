import Testing
import Foundation
@testable import Aite

@Suite
struct GoalTests {
    
    @Test
    func testGoalInitialization_withMoneyType() throws {
        let targetAmount = 1000.0
        let goal = Goal(name: "Save money", target: .money(targetAmount))
        
        #expect(goal.name == "Save money")
        if case .money(let amount) = goal.target {
            #expect(amount == targetAmount)
        } else {
            Issue.record("Goals target should be money type")
        }
    }
    
    @Test
    func testGoalInitialization_withTimeframeType() throws {
        let goal = Goal(name: "Exercise daily", target: .timeframe(days: 30, weeks: 2))
        
        #expect(goal.name == "Exercise daily")
        if case .timeframe(let days, let weeks, let months, let years) = goal.target {
            #expect(days == 30)
            #expect(weeks == 2)
            #expect(months == 0)
            #expect(years == 0)
        } else {
            Issue.record("Goal target should be timeframe type")
        }
    }
    
    @Test
    func testGoalEquality_whenSameGoal() throws {
        let goal = Goal(name: "Exercise", target: .timeframe(weeks: 4))
        let sameGoal = goal // Same instance should be equal
        
        #expect(goal == sameGoal)
    }
    
    @Test
    func testGoalEquality_whenDifferentGoals() throws {
        let goal1 = Goal(name: "Save money", target: .money(1000.0))
        let goal2 = Goal(name: "Save money", target: .money(1000.0))
        
        // Even with same properties, goals should be different due to unique IDs
        #expect(goal1 != goal2)
    }
    
    @Test
    func testGoalCoding() throws {
        let goal = Goal(name: "Long term saving", target: .timeframe(months: 6, years: 1))
        
        // Test encoding and decoding
        let encodedData = try JSONEncoder().encode(goal)
        let decodedGoal = try JSONDecoder().decode(Goal.self, from: encodedData)
        
        #expect(goal == decodedGoal)
    }
}
