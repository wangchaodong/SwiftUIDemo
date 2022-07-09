//
//  ProfileHost.swift
//  Demo
//
//  Created by s1mple wang on 2022/7/8.
//

import SwiftUI

struct ProfileHost: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData

    @State private var defaultProfile = Profile.default

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancle", role: .cancel) {
                        defaultProfile = modelData.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            if editMode?.wrappedValue == .inactive {
                ProfileSummary(profile: modelData.profile)
            } else {
                ProfileEditor(profile: $defaultProfile)
                    .onAppear {
                        defaultProfile = modelData.profile
                    }
                    .onDisappear {
                        modelData.profile = defaultProfile
                    }
            }
        }
        .padding(20)
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
            .environmentObject(ModelData())
    }
}
