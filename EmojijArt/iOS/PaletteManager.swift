//
//  PaletteManager.swift
//  SwiftUIDemo
//
//  Created by s1mple on 2022/4/11.
//

import SwiftUI

struct PaletteManager: View {
	@EnvironmentObject var store: PaletteStore
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.colorScheme) var colorScheme

	@State private var editMode: EditMode = .inactive
    var body: some View {
		NavigationView {
			List {
				ForEach(store.palettes) { palette in
					NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
						VStack(alignment: .leading) {
							Text(palette.name)
//								.font(editMode == .dark ? .largeTitle : .caption)
								.font(colorScheme == .dark ? .largeTitle : .caption)
							Text(palette.emojis)
						}
						.gesture(editMode == .active ? tap : nil) // tap when in edit
					}
				}
				.onDelete { indexSet in
					store.palettes.remove(atOffsets: indexSet)
				}
				.onMove { indexSet, newOffset in
					store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
				}
			}
			.navigationTitle("Manage Palettes")
			.navigationBarTitleDisplayMode(.inline)
			.dismissable({
				presentationMode.wrappedValue.dismiss()
			})
			.toolbar {
				ToolbarItem { EditButton() }
//				ToolbarItem(placement: .navigationBarLeading) {
//					if presentationMode.wrappedValue.isPresented,
//					   UIDevice.current.userInterfaceIdiom != .pad {
//						Button("Close") {
//							presentationMode.wrappedValue.dismiss()
//						}
//					}
//				}
			}
			.environment(\.colorScheme, .dark)
			.environment(\.editMode, $editMode)
		}
    }

	var tap: some Gesture {
		TapGesture().onEnded {
		}
	}
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager()
			.environmentObject(PaletteStore(named: "PreView"))
			.preferredColorScheme(.dark)
    }
}
