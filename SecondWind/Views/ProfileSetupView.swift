//
//  ProfileSetupView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 02.11.26.
//

import SwiftUI
import SwiftData

struct ProfileSetupView: View {
    
    // Needed to save profile into database
    @Environment(\.modelContext) private var modelContext
    
    // ViewModel holds all values and logic
    @State private var viewModel: ProfileSetupViewModel = ProfileSetupViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                
                // Username section
                Section("Username") {
                    TextField(
                        "Your name",
                        text: $viewModel.username).textInputAutocapitalization(.words).autocorrectionDisabled()
                }
                
                // Date of birth
                Section {
                    DatePicker(
                        "Date of birth",
                        selection: $viewModel.birthDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                } footer: {
                    Text(viewModel.birthDateInfo)
                }
                
                // Confirm
                Section {
                    Button("Confirm") {
                        saveProfile()
                    }.disabled(!viewModel.isValid)
                }
            }.navigationTitle("Your Profile").task {
                await viewModel.loadDateOfBirthFromHealth()
            }
        }
    }
    
    /// Saves profile, afterwards app shows main screen
    private func saveProfile() {
        let profile: UserProfile = viewModel.createProfile()
        modelContext.insert(profile)
    }
}
