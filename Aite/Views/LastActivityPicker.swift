//
//  LastActivityPicker.swift
//  Aite
//
//  Created by Jose Tlacuilo on 24/03/25.
//
import SwiftUI

struct LastActivityPicker: View {
    @EnvironmentObject var vm: GoalsViewModel
    
    var body: some View {
        Form {
            DatePicker("Last Activity", selection: Binding(
                get: { vm.lastActivityDate ?? Date() },
                set: { newDate in
                    // Throws if future date is selected but can't select future date
                    try! vm.updateLastActivityDate(newDate)
                }
            ), in: ...Date(), displayedComponents: [.date, .hourAndMinute])
            .datePickerStyle(CompactDatePickerStyle())
            .padding()
        }
    }
}


#Preview {
    LastActivityPicker()
        .environmentObject(GoalsViewModel())
}

