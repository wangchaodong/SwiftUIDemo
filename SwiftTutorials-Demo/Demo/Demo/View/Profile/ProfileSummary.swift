//
//  ProfileSummary.swift
//  Demo
//
//  Created by s1mple wang on 2022/7/8.
//

import SwiftUI

struct ProfileSummary: View {
    var profile: Profile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(profile.username)
                    .bold()
                    .font(.title)

                Text("Notifications: \(profile.prefersNotifications ? "On": "Off" )")
                Text("Seasonal Photos: \(profile.seasonalPhoto.rawValue)")
                Text("Goal Date: ") + Text(profile.goalDate, style: .date)

                Divider()

                VStack(alignment: .leading) {
                    Text("Completed Badges")
                        .font(.headline)

                    ScrollView {
                        HStack {
                            HikeBadge(name: "First Badge")
                            HikeBadge(name: "Second")
                                .hueRotation(Angle(degrees: 90))
                            HikeBadge(name: "Third")
                                .hueRotation(Angle(degrees: 45))
                                .grayscale(0.5)
                        }
                    }
                }

                Divider()

                VStack(alignment: .leading) {
                    Text("Recent Hike")
                        .font(.headline)
                    HikeView(hike: ModelData().hikes[0])
                }
            }
        }
        .padding()
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: Profile.default)
    }
}
