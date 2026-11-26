//
//  ProfileSetupView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 02.11.26.
//

import SwiftUI

struct ProfileSetupView: View {
    
    // ViewModel holds all values and logic
    @State private var viewModel: ProfileSetupViewModel = ProfileSetupViewModel()
    
    // Shared profile - saving here updates all screens
    @Environment(ProfileStore.self) private var profileStore
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large) {
                header
                ProfileFormView(viewModel: viewModel)
            }
            .padding(.horizontal, Spacing.large)
            .padding(.top, Spacing.extraLarge)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            confirmButton
        }
        .screenBackground()
        .task {
            await viewModel.loadDateOfBirthFromHealth()
        }
    }
    
    private var header: some View {
        
        ScreenHeader(
            title: "Your Profile",
            subtitle: "A few details to personalize your training",
            systemImage: "person.crop.circle.fill"
        )
    }
    
    private var confirmButton: some View {
        Button("Continue") {
            saveProfile()
        }
        .buttonStyle(.primary)
        .disabled(!viewModel.isValid)
        .padding(.all, Spacing.large)
    }
    
    /// Saves profile, afterwards app shows main screen
    private func saveProfile() {
        let profile: UserProfile = viewModel.createProfile()
        profileStore.save(profile)
    }
}

#Preview {
    ProfileSetupView().environment(ProfileStore())
}
