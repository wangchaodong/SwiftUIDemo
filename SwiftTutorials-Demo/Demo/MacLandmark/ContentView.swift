//
//  ContentView.swift
//  MacLandmark
//
//  Created by s1mple wang on 2022/7/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
            .frame(minWidth: 700,
                   minHeight: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            .frame(width: 850, height: 700)
    }
}
