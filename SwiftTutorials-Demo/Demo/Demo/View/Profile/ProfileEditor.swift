//
//  ProfileEditor.swift
//  Demo
//
//  Created by s1mple wang on 2022/7/8.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var profile: Profile
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
        return min...max
    }

    var body: some View {
        List {
//            VStack {
                HStack {
                    Text("UserName:").bold()

                    TextField("Name", text: $profile.username)
                }

                Toggle(isOn: $profile.prefersNotifications) {
                    Text("Enable Notification").bold()
                }

                VStack(alignment: .leading, spacing: 20) {
                    Text("select").bold()
                    Picker("Select Photo", selection: $profile.seasonalPhoto) {
                        ForEach(Profile.Season.allCases) { season in
                            Text(season.rawValue).tag(season)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                DatePicker(selection: $profile.goalDate, in: dateRange, displayedComponents: .date) {
                    Text("Global Date").bold()
                }
            }
//        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
