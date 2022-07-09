//
//  ContentView.swift
//  SwiftUICollection
//
//  Created by s1mple on 2022/4/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		NavigationView {
			List {
				NavigationLink {
					Text("Text")
				} label: {
					Text("Text")
				}
				Text("Button")
				Text("TextField")
			}
			.navigationTitle("Swift UI Collection")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
