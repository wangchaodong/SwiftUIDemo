//
//  EmojiMemoryGameView.swift
//  SwiftUIDemo
//
//  Created by s1mple on 2022/4/9.
//

import SwiftUI

struct EmojiMemoryGameView: View {
	@ObservedObject var game: EmojiMemoryGame

	@Namespace private var dealingNameSpace
    var body: some View {
		ZStack(alignment: .bottom) {
			VStack {
				gameBody
				HStack {
					restart
					Spacer()
					shuffle
				}
				.padding(.vertical)
			}
			deckBody

		}
		.padding()
    }

	@State private var dealt = Set<Int>()
	private func deal(_ card: EmojiMemoryGame.Card) {
		dealt.insert(card.id)
	}
	private func isUnDealt(_ card: EmojiMemoryGame.Card) -> Bool {
		!dealt.contains(card.id)
	}

	private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
		var delay = 0.0
		if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
			delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
		}
		return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
	}

	private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
		-Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
	}

	var gameBody: some View {
		AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
			//				cardView(for: card)
			if isUnDealt(card) || card.isMatched && !card.isFaceUp {
//				Rectangle().opacity(0)
				Color.clear
			} else {
				CardView(card)
					.matchedGeometryEffect(id: card.id, in: dealingNameSpace)
					.padding(4)
//					.transition(AnyTransition.scale.animation(Animation.easeInOut(duration: 2)))
					.transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
					.zIndex(zIndex(of: card))
					.onTapGesture {
						withAnimation {
							game.choose(card: card)
						}
					}
			}
		}
//		.onAppear(perform: {
//			withAnimation(.easeInOut(duration: 3)) {
//				for card in game.cards {
//					deal(card)
//				}
//			}
//		})
		.foregroundColor(.orange)
	}

	var deckBody: some View {
		ZStack {
			ForEach(game.cards.filter(isUnDealt)) { card in
				CardView(card)
					.matchedGeometryEffect(id: card.id, in: dealingNameSpace)
					.transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
					.zIndex(zIndex(of: card))
			}
		}
		.frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
		.foregroundColor(CardConstants.color)
		.onTapGesture {
			for card in game.cards {
				withAnimation(dealAnimation(for: card)) {
					deal(card)
				}
			}
		}
	}

	private struct CardConstants {
		static let color = Color.orange
		static let aspectRatio: CGFloat = 2/3
		static let dealDuration: Double = 0.5
		static let totalDealDuration: Double = 2
		static let undealtHeight: CGFloat = 90
		static let undealtWidth = undealtHeight * aspectRatio
	}

	var shuffle: some View {
		Button {
			withAnimation {
				game.shuffle()
			}
		} label: {
			Image(systemName: "shuffle.circle")
		}
	}

	var restart: some View {
		Button {
			withAnimation {
				dealt = []
				game.restart()
			}
		} label: {
			Image(systemName: "restart.circle")
		}
	}

	@ViewBuilder
	func cardView(for card: EmojiMemoryGame.Card) -> some View {
		if card.isMatched && !card.isFaceUp {
			Rectangle().opacity(0)
		} else {
			CardView(card)
				.padding(4)
				.onTapGesture {
					game.choose(card: card)
				}
		}
	}

}

struct CardView: View {
	private let card: EmojiMemoryGame.Card

	init(_ card: EmojiMemoryGame.Card) {
		self.card = card
	}

	@State private var animatedBonusRemaining: Double = 0

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				Group {
					if card.isConsumingBonusTime {
						Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90), clockwise: false)
							.onAppear {
								animatedBonusRemaining = card.bonusRemaining
								withAnimation(.linear(duration: card.bonusTimeRemaining)) {
									animatedBonusRemaining = 0
								}
							}
					} else {
						Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90), clockwise: false)
					}
				}
				.padding(5)
				.opacity(0.5)
				Text(card.content)
					.rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
					.animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
					.font(.system(size: DrawingConstants.fontSize))
					.scaleEffect(scale(thatFits: geometry.size))
			}
			.cardify(isFaceUp: card.isFaceUp)
		}
	}

	private func scale(thatFits size: CGSize) -> CGFloat {
		min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
	}

	private func font(in size: CGSize) -> Font {
		Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
	}

	private struct DrawingConstants {
		static let fontScale: CGFloat = 0.7
		static let fontSize: CGFloat = 32
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		let game = EmojiMemoryGame()
		game.choose(card: game.cards.first!)
		return EmojiMemoryGameView(game: game)
			.preferredColorScheme(.dark)
//		EmojiMemoryGameView(game: EmojiMemoryGame())
//			.previewInterfaceOrientation(.portraitUpsideDown)
//			.preferredColorScheme(.light)
	}
}
