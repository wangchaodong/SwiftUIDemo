//
//  ModelData.swift
//  Demo
//
//  Created by s1mple wang on 2022/7/6.
//

import Foundation
import Combine

class ModelData: ObservableObject {
    @Published var landmarks: [Landmark] = load(filename: "landmarkData.json")
    var hikes: [Hike] = load(filename: "hikeData.json")
    @Published var profile = Profile.default

    var categories: [String: [Landmark]] {
        Dictionary(grouping: landmarks, by: { $0.category.rawValue })
    }

    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }
}


func load<T: Decodable>(filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
