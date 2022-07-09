//
//  ContentView.swift
//  WatchLandmark WatchKit Extension
//
//  Created by s1mple wang on 2022/7/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
