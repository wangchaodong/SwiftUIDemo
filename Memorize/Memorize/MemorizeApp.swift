//
//  MemorizeApp.swift
//  Memorize
//
//  Created by s1mple on 2022/4/12.
//

import SwiftUI

@main
struct MemorizeApp: App {
	private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
			EmojiMemoryGameView(game: game)
        }
    }
}
