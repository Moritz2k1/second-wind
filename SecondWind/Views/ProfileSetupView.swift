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
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large) {
                header
                nameSection
                birthDateSection
                maxHeartRateTile
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
    
    private var nameSection: some View {
        ProfileSection(title: "Name") {
            TextField("Your name", text: $viewModel.username)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .foregroundStyle(ColorToken.inputText)
        }
    }
    
    private var birthDateSection: some View {
        ProfileSection(title: "Birthday", footer: viewModel.birthDateInfo) {
            DatePicker(
                "Date of birth",
                selection: $viewModel.birthDate,
                in: ...Date(),
                displayedComponents: .date
            )
                .foregroundStyle(ColorToken.inputText)
        }
    }
    
    private var maxHeartRateTile: some View {
        MetricTile(title: "Estimated max heart rate",
                   value: "\(viewModel.estimatedMaxHeartRate)",
                   unit: "bpm"
        )
        .contentTransition(.numericText())
        .animation(.default, value: viewModel.estimatedMaxHeartRate)
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
        profile.saveProfile()
    }
    
}

/// Title above card
private struct ProfileSection<Content: View>: View {
    
    let title: String
    var footer: String? = nil
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(ColorToken.secondaryText)
            
            content.cardStyle()
            
            if let footer {
                Text(footer)
                    .font(.footnote)
                    .foregroundStyle(ColorToken.secondaryText)
            }
        }
    }
}

#Preview {
    ProfileSetupView()
}
