//
//  EmojiMemoryGame.swift
//  SwiftUIDemo
//
//  Created by s1mple on 2022/4/9.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
	typealias Card = MemoryGame<String>.Card

	static let emojs = ["👻", "🤩", "🌈", "🐠", "🐢", "🐍", "🌸", "🦖", "⚽️", "🥎", "🤼", "🚘", "🚁", "🧲", "🔫", "📊", "🗂", "☯️", "🈚️", "📛", "💝", "🈁", "🆘", "♥️", "🀄️", "🔁", "🍎", "🧅", "🥠", "🍈", "☔️", "☂️", "🌳"]

	static func creatMemoryGame() -> MemoryGame<String> {
		return MemoryGame<String>(numberOfPairsOfCards: 10) { index in emojs[index] }
	}

	@Published private var model = creatMemoryGame()

	// MARK: - Access to the model

	var cards: Array<Card> {
		model.cards
	}
	
	// MARK: - Intent(s)

	func choose(card: Card) {
//		objectWillChange.send()
		model.choose(card: card)
	}

	func shuffle() {
		model.shuffle()
	}

	func restart() {
		model = EmojiMemoryGame.creatMemoryGame()
	}
}
