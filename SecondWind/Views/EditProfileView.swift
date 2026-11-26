//
//  EditProfileView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import SwiftUI

/// Sheet for changing name, birthday and max heart rate
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
                ProfileFormView(viewModel: viewModel, showsCustomMaxHeartRate: true)
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

#Preview("Estimate") {
    EditProfileView(profile: .sample)
        .environment(ProfileStore(profile: .sample))
}

#Preview("Own max heart rate") {
    let profile: UserProfile = UserProfile(
        username: UserProfile.sample.username,
        birthDate: UserProfile.sample.birthDate,
        customMaxHeartRate: 194
    )
    
    EditProfileView(profile: profile)
        .environment(ProfileStore(profile: profile))
}
