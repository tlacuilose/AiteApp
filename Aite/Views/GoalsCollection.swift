//
//  GoalsCollection.swift
//  Aite
//
//  Created by Jose Tlacuilo on 27/03/25.
//
import SwiftUI

struct GoalsCollection: View {
    @EnvironmentObject var vm: GoalsViewModel

    var body: some View {
        if let lastActivity = vm.lastActivityDate {
            Section("Goals") {
                if !vm.goals.isEmpty {
                    ForEach(vm.goals) { goal in
                        switch goal.construction {
                        case .money:
                            GoalDetail(goal: goal, goalReference: .money(from: vm.savedAmount))
                        case .timeframe:
                            GoalDetail(
                                goal: goal,
                                goalReference: .timeframe(from: lastActivity, to: Date())
                            )
                        }
                    }
                } else {
                    Text("No goals yet")
                        .foregroundStyle(.secondary)
                        .italic()
                }
            }
        } else {
            Text("Please add a last activity date")
                .foregroundStyle(.secondary)
                .italic()
        }
    }
}

#Preview {
    List {
        GoalsCollection()
            .environmentObject(
                GoalsViewModel(goalsService: FakeGoalsServiceForUI(lastActivityDate: Date())))
    }
}

#Preview("No goals") {
    List {
        GoalsCollection()
            .environmentObject(
                GoalsViewModel(
                    goalsService: FakeGoalsServiceForUI(
                        lastActivityDate: Date(),
                        clearGoals: true
                    )
                )
            )
    }
}

#Preview("Not configured") {
    List {
        GoalsCollection()
            .environmentObject(GoalsViewModel(goalsService: FakeGoalsServiceForUI()))
    }
}
