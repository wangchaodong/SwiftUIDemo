//
//  iOS.swift
//  SwiftUIDemo (macOS)
//
//  Created by s1mple on 2022/4/12.
//

import SwiftUI

extension UIImage {
	var imageData: Data? {
		jpegData(compressionQuality: 1.0)
	}
}

struct Pasteboard {
	static var imageData: Data? {
		UIPasteboard.general.image?.imageData
	}
	static var imageURL: URL? {
		UIPasteboard.general.url?.imageURL
	}
}

extension View {
	@ViewBuilder
	func wrappedInNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
		if UIDevice.current.userInterfaceIdiom != .pad,
		   let dismiss = dismiss {
			NavigationView {
				self
					.navigationBarTitleDisplayMode(.inline)
					.dismissable(dismiss)
			}
			.navigationViewStyle(.stack)
		} else {
			self
		}
	}

	@ViewBuilder
	func dismissable(_ dismiss: (() -> Void)?) -> some View {
		if UIDevice.current.userInterfaceIdiom != .pad,
		   let dismiss = dismiss {
			self.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Close") {
						dismiss()
					}
				}
			}
		} else {

		}
	}

	func paletteControlButtonStyle() -> some View {
		self
	}

	func popoverPadding() -> some View {
		self
	}

}
