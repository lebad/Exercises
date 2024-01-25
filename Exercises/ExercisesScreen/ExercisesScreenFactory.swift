//
//  ExercisesScreenFactory.swift
//  Exercises
//
//  Created by Andrey Lebedev on 24.01.2024.
//

import UIKit

class ExercisesScreenFactory {
	func make() -> UIViewController {
		let viewModel = ExercisesViewModel(exerciseService: ExerciseService())
		let view = ExercisesScreenView(viewModel: viewModel)
		return view.viewController
	}
}
