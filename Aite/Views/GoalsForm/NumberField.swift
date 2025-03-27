//
//  NumberField.swift
//  Aite
//
//  Created by Jose Tlacuilo on 25/03/25.
//
import SwiftUI

struct NumberField: View {
    let title: LocalizedStringKey
    @Binding var value: Int

    var body: some View {
        LabeledContent {
            TextField("#", value: $value, format: .number)
                .keyboardType(.numberPad)
        } label: {
            Text(title)
        }
    }
}

#Preview {
    NumberField(title: "Name", value: .constant(10))
}
