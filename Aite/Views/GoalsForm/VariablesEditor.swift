//
//  LastActivityPicker.swift
//  Aite
//
//  Created by Jose Tlacuilo on 24/03/25.
//
import SwiftUI

struct VariablesEditor: View {
    @EnvironmentObject var vm: GoalsViewModel

    @State private var errorMessage: String? = nil
    @State private var didErrored = false

    var body: some View {
        Section("Last Activity") {
            DatePicker(
                "Date",
                selection: Binding(
                    get: { vm.lastActivityDate ?? Date() },
                    set: { newDate in
                        // Throws if future date is selected but can't select future date
                        try! vm.updateLastActivityDate(newDate)
                    }
                ), in: ...Date(), displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(CompactDatePickerStyle())
            .padding()
        }
        Section("Cost Per Month") {
            TextField(
                "Amount",
                value: Binding(
                    get: { vm.costPerMonth },
                    set: { newCost in
                        do {
                            try vm.updateCostPerMonth(newCost)
                        } catch {
                            errorMessage = error.localizedDescription
                            didErrored = true
                        }
                    }
                ),
                format: .currency(code: Locale.current.currency?.identifier ?? "USD")
            )
            .keyboardType(.decimalPad)
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
        VariablesEditor()
            .environmentObject(GoalsViewModel())
    }
}
