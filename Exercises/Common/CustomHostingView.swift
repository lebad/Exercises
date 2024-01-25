//
//  ExercisesHostView.swift
//  Exercises
//
//  Created by Andrey Lebedev on 25.01.2024.
//

import UIKit
import SwiftUI

class CustomHostingView<Content: View>: UIView {
	private var hostingController: UIHostingController<Content>?

	init(rootView: Content) {
		super.init(frame: .zero)
		let hostingController = UIHostingController(rootView: rootView)
		self.hostingController = hostingController
		// Add the SwiftUI view to the UIKit view hierarchy
		addSubview(hostingController.view)
		hostingController.view.translatesAutoresizingMaskIntoConstraints = false

		// Setup constraints to match the hostingController's view to the CustomHostingView
		NSLayoutConstraint.activate([
			hostingController.view.topAnchor.constraint(equalTo: topAnchor),
			hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
			hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
			hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override var intrinsicContentSize: CGSize {
		// Return the intrinsic content size of the SwiftUI view
		hostingController?.view.sizeThatFits(UIView.layoutFittingCompressedSize) ?? CGSize(width: -1, height: -1)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		hostingController?.view.invalidateIntrinsicContentSize()
	}
}
