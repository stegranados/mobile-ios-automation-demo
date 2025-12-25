//
//  NewItemView.swift
//  ItemApp
//
//  Created by Karin Prater on 24/05/2025.
//
import SwiftUI

struct NewItemView: View {
    
    @ObservedObject var viewModel: ItemViewModel
    @State private var newItemName = ""
    @Environment(\.dismiss) var dismiss
    
  private let testingID = UIIdentifiers.AddNewItemScreen.self
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Item name", text: $newItemName)
                .padding()
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier(testingID.itemNameTextField)
            
            Button("Add Item") {
                if !newItemName.isEmpty {
                    viewModel.addItem(name: newItemName)
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(newItemName.isEmpty)
            .accessibilityIdentifier(testingID.addButton)
        }
        .padding()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(testingID.sheet)
        
    }
}

#Preview {
    NewItemView(viewModel: .init())
}
