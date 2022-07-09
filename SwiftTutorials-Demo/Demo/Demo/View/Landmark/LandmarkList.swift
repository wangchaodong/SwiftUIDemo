//
//  LandmarkList.swift
//  Demo
//
//  Created by s1mple wang on 2022/7/7.
//

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoriteOnly = false
    @State private var filter = FilterCategory.all
    @State private var selectedLandmark: Landmark?

    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (landmark.isFavorite || !self.showFavoriteOnly)
            && (filter == .all || filter.rawValue == landmark.category.rawValue)
        }
    }
    enum FilterCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"

        var id: FilterCategory { self }
    }
    var title: String {
        let title = filter == .all ? "Landmarks" : filter.rawValue
        return showFavoriteOnly ? "Favorite \(title)" : title
    }
    var index: Int? {
        modelData.landmarks.firstIndex(where: { $0.id == selectedLandmark?.id })
    }

    var body: some View {
        NavigationView {
            List(selection: $selectedLandmark) {
                Toggle(isOn: $showFavoriteOnly) {
                    Text("filter favorite")
                }
                
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                    .tag(landmark)
                }
            }
            .navigationTitle(title)
            .frame(minWidth: 300)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Category", selection: $filter) {
                            ForEach(FilterCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.inline)

                        Toggle(isOn: $showFavoriteOnly) {
                            Label("Favorites only", systemImage: "star.fill")
                        }
                    } label: {
                        Label("Filter", systemImage: "slider.horizontal.3")
                    }
                }
            }
            Text("Select a Landmark")

        }
        .focusedValue(\.selectedLandmark, $modelData.landmarks[index ?? 0])

    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone XS Max", "iPhone SE (2nd generation)"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
                .environmentObject(ModelData())
        }
//        LandmarkList()
//            .preferredColorScheme(.light)
//            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
    }
}
