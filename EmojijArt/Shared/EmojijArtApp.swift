//
//  EmojijArtApp.swift
//  Shared
//
//  Created by s1mple on 2022/4/12.
//

import SwiftUI

@main
struct EmojijArtApp: App {
	@Environment(\.scenePhase) var scenePhase

	@StateObject var paletteStore = PaletteStore(named: "Default")

	var body: some Scene {
		DocumentGroup(newDocument: {
			EmoijArtDocument()
		}, editor: { config in
			EmojiArtDocumentView(document: config.document)
				.environmentObject(paletteStore)
		})
		.onChange(of: scenePhase) { newScenePhase in
			switch newScenePhase {
			case .active:
				print("App is active")
			case .inactive:
				print("App is inactive")
			case .background:
				print("App is in background")
			@unknown default:
				print("Oh - interesting: I received an unexpected new value.")
			}
		}
	}
}
