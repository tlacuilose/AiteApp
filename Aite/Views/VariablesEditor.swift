//
//  LastActivityPicker.swift
//  Aite
//
//  Created by Jose Tlacuilo on 24/03/25.
//
import SwiftUI

struct VariablesEditor: View {
    @EnvironmentObject var vm: GoalsViewModel
    
    var body: some View {
        Form {
            Section("Last Activity") {
                DatePicker("Date", selection: Binding(
                    get: { vm.lastActivityDate ?? Date() },
                    set: { newDate in
                        // Throws if future date is selected but can't select future date
                        try! vm.updateLastActivityDate(newDate)
                    }
                ), in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
            }
            Section("Cost Per Month") {
                TextField("Amount", value: $vm.costPerMonth, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .keyboardType(.decimalPad)
            }
        }
    }
}


#Preview {
    VariablesEditor()
        .environmentObject(GoalsViewModel())
}

