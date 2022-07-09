//
//  EmoijArtDocument.swift
//  SwiftUIDemo
//
//  Created by s1mple on 2022/4/10.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

extension UTType {
	static let emojiart = UTType(exportedAs: "com.cd.swiftuidemo")
}

class EmoijArtDocument: ReferenceFileDocument {
	static var readableContentTypes = [UTType.emojiart]
	static var writableContentTypes = [UTType.emojiart]

	required init(configuration: ReadConfiguration) throws {
		if let data = configuration.file.regularFileContents {
			emojiArt = try EmojiArtModel(json: data)
			fetchBackgroundImageDataIfNecessary()
		} else {
			throw CocoaError(.fileReadCorruptFile)
		}
	}

	func snapshot(contentType: UTType) throws -> Data {
		try emojiArt.json()
	}

	func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
		FileWrapper(regularFileWithContents: snapshot)
	}

	typealias Snapshot = Data

	@Published private(set) var emojiArt: EmojiArtModel {
		didSet {
//			scheduleAutoSave()
			if emojiArt.background != oldValue.background {
				fetchBackgroundImageDataIfNecessary()
			}
		}
	}
//	private var autoSaveTimer: Timer?
//
//	private func scheduleAutoSave() {
//		autoSaveTimer?.invalidate()
//		autoSaveTimer = Timer.scheduledTimer(withTimeInterval: AutoSave.coalescingInterval, repeats: false) { _ in
//			self.autoSave()
//		}
//	}
//	private struct AutoSave {
//		static let filename = "Autosaved.emojart"
//		static var url: URL? {
//			let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//			return documentDirectory?.appendingPathComponent(filename)
//		}
//		static let coalescingInterval = 5.0
//	}
//	private func autoSave() {
//		if let url = AutoSave.url {
//			save(to: url)
//		}
//	}
//	private func save(to url: URL) {
//		let thisFunction = "\(String(describing: self)).\(#function)"
//		do {
//			let data: Data = try emojiArt.json()
//			print("\(thisFunction) json = \(String(data: data, encoding: .utf8) ?? "nil")")
//			try data.write(to: url)
//			print("\(thisFunction) success!")
//		} catch let encodingError where encodingError is EncodingError {
//			print("\(thisFunction) couldn't encode EmojiArt as JSON because \(encodingError.localizedDescription)")
//		} catch {
//			print("\(thisFunction) error=\(error)")
//		}
//	}

//	init() {
//		if let url = AutoSave.url,
//		   let autosavedEmojiArt = try? EmojiArtModel(url: url) {
//			emojiArt = autosavedEmojiArt
//			fetchBackgroundImageDataIfNecessary()
//		} else {
//			emojiArt = EmojiArtModel()
//		}
//	}

	init() {
		emojiArt = EmojiArtModel()
	}
	
	var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
	var background: EmojiArtModel.Background { emojiArt.background }

	@Published var backgroundImage: UIImage?
	@Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle

	private var backgroundImageFetchCancellable: AnyCancellable?

	enum BackgroundImageFetchStatus: Equatable {
		case idle
		case fetching
		case failed(URL)
	}
	private func fetchBackgroundImageDataIfNecessary() {
		backgroundImage = nil
		switch emojiArt.background {
		case .url(let url):
			// fetch url
			backgroundImageFetchStatus = .fetching
			backgroundImageFetchCancellable?.cancel()

			let session = URLSession.shared
			let publisher = session.dataTaskPublisher(for: url)
				.map { (data, urlResponse) in UIImage(data: data) }
//				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)

			backgroundImageFetchCancellable = publisher
//				.assign(to: \.backgroundImage, on: self)
//				.sink(receiveValue: { [weak self] image in
//					self?.backgroundImage = image
//					self?.backgroundImageFetchStatus = image != nil ? .idle : .failed(url)
//				})
				.sink(receiveCompletion: { result in
					switch result {
					case .finished:
						print("success")
					case .failure(let error):
						print("failed error: \(error)")
					}
				}, receiveValue: { [weak self] image in
					self?.backgroundImage = image
					self?.backgroundImageFetchStatus = image != nil ? .idle : .failed(url)
				})


//			DispatchQueue.global(qos: .userInitiated).async {
//				print("download url image: \(url)")
//				let imageData = try? Data(contentsOf: url)
//				DispatchQueue.main.async { [weak self] in
//					if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
//						self?.backgroundImageFetchStatus = .idle
//						print("url image downloaded: \(url)")
//						if imageData != nil {
//							self?.backgroundImage = UIImage(data: imageData!)
//						}
//						if self?.backgroundImage == nil {
//							self?.backgroundImageFetchStatus = .failed(url)
//						}
//					}
//				}
//			}
		case .imageData(let data):
			backgroundImage = UIImage(data: data)
		case .blank:
			break
		}
	}
	// MARK: - Intent(s)

	func setBackground(_ background: EmojiArtModel.Background, undoManager: UndoManager?) {
		undoablyPerform(operation: "setBackground", with: undoManager) {
			emojiArt.background = background
		}
		print("background set to \(background)")
	}

	func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat, undoManager: UndoManager?) {
		undoablyPerform(operation: "addEmoji \(emoji)", with: undoManager) {
			emojiArt.addEmoij(emoji, at: location, size: Int(size))
		}
	}

	func moveEmoij(_ emoji: EmojiArtModel.Emoji, by offset: CGSize, undoManager: UndoManager?) {
		undoablyPerform(operation: "moveEmoij", with: undoManager) {
			if let index = emojiArt.emojis.index(matching: emoji) {
				emojiArt.emojis[index].x += Int(offset.width)
				emojiArt.emojis[index].y += Int(offset.height)
			}
		}
	}

	func scaleEmoij(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat, undoManager: UndoManager?) {
		undoablyPerform(operation: "scaleEmoij", with: undoManager) {
			if let index = emojiArt.emojis.index(matching: emoji) {
				emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
			}
		}
	}

	// MARK: - Undo
	private func undoablyPerform(operation: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
		let oldEmojiArt = emojiArt
		doit()
		undoManager?.registerUndo(withTarget: self, handler: { myself in
			myself.undoablyPerform(operation: operation, with: undoManager) {
				myself.emojiArt = oldEmojiArt
			}
		})
		undoManager?.setActionName(operation)
	}
}
