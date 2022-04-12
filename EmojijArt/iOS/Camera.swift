//
//  Camera.swift
//  SwiftUIDemo
//
//  Created by s1mple on 2022/4/11.
//

import SwiftUI

struct Camera: UIViewControllerRepresentable {
	func makeCoordinator() -> Coordinator {
		Coordinator(handlePickedImage: handlePickedImage)
	}

	func makeUIViewController(context: Context) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.sourceType = .camera
		picker.allowsEditing = true
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

	}

	class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		var handlePickedImage: (UIImage?) -> Void
		init(handlePickedImage: @escaping (UIImage?) -> Void) {
			self.handlePickedImage = handlePickedImage
		}

		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			handlePickedImage(nil)
		}
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			handlePickedImage((info[.editedImage] ?? info[.originalImage]) as? UIImage)
		}
	}

	typealias UIViewControllerType = UIImagePickerController

	var handlePickedImage: (UIImage?) -> Void

	static var isAvailable: Bool {
		UIImagePickerController.isSourceTypeAvailable(.camera)
	}


}
