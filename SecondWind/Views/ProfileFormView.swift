//
//  ProfileFormView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import SwiftUI

/// Name, birthday and max heart rate used by setup and edit screen
struct ProfileFormView: View {
    
    // Owned by screen that shows form
    @Bindable var viewModel: ProfileSetupViewModel
    
    var body: some View {
        VStack(spacing: Spacing.large) {
            nameSection
            birthDateSection
            maxHeartRateTile
        }
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
    ProfileFormView(viewModel: ProfileSetupViewModel())
        .padding()
        .screenBackground()
}

