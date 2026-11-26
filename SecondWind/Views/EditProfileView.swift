//
//  EditProfileView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import SwiftUI

/// Sheet for changing name and birthday
struct EditProfileView: View {
    
    // Filled with current profile, changes only saved on Save
    @State private var viewModel: ProfileSetupViewModel
    
    // Shared profile, saving here updates all screens
    @Environment(ProfileStore.self) private var profileStore
    
    // Closes sheet
    @Environment(\.dismiss) private var dismiss
    
    init(profile: UserProfile) {
        _viewModel = State(initialValue: ProfileSetupViewModel(profile: profile))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ProfileFormView(viewModel: viewModel)
                    .padding(.horizontal, Spacing.large)
                    .padding(.vertical, Spacing.large)
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollDismissesKeyboard(.interactively)
            .screenBackground()
            .navigationTitle("Edit profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!viewModel.isValid)
                }
            }
        }
    }
    
    /// Saves changes, all screens update, then closes sheet
    private func save() {
        profileStore.save(viewModel.createProfile())
        dismiss()
    }
}

#Preview {
    EditProfileView(profile: .sample)
        .environment(ProfileStore(profile: .sample))
}
