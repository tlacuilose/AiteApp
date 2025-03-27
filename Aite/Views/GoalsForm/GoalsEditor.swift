//
//  GoalsEditor.swift
//  Aite
//
//  Created by Jose Tlacuilo on 24/03/25.
//

import SwiftUI

struct GoalsEditor: View {
    @EnvironmentObject private var vm: GoalsViewModel
    @State private var errorMessage: String? = nil
    @State private var didErrored = false
    @State private var bounceTrigger: CGFloat = 0

    var body: some View {
        Section(
            header:
                HStack {
                    Text("Current Goals")
                    Spacer()
                    Button(action: {
                        vm.removeAllGoals()
                        withAnimation(Animation.linear(duration: 0.6)) {
                            bounceTrigger += 1
                        }
                    }) {
                        Text("Remove All").textCase(nil)
                    }
                    .disabled(vm.goals.isEmpty)
                }
                .modifier(BounceEffect(animatableData: bounceTrigger))
        ) {
            ForEach(vm.goals) { goal in
                HStack {
                    VStack(alignment: .leading) {
                        Text(goal.name)
                            .font(.headline)

                        switch goal.target {
                        case .money(let amount):
                            Text(
                                amount,
                                format: .currency(
                                    code: Locale.current.currency?.identifier ?? "USD")
                            )
                            .font(.subheadline)
                        case .timeframe(let days, let weeks, let months, let years):
                            Text("\(years)y \(months)m \(weeks)w \(days)d")
                                .font(.subheadline)
                        }
                    }

                    Spacer()

                    Button(action: {
                        do {
                            try vm.removeGoal(goal)
                        } catch {
                            errorMessage = error.localizedDescription
                            didErrored = true
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }

            if vm.goals.isEmpty {
                Text("No goals added yet")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .alert(
            "Error", isPresented: $didErrored,
            actions: {
                Button("Ok", role: .cancel) {}
            },
            message: {
                Text(errorMessage ?? "Unknown error")
            })
    }
}

#Preview {
    Form {
        GoalsEditor()
            .environmentObject(GoalsViewModel(goalsService: FakeGoalsServiceForUI()))
    }
}
