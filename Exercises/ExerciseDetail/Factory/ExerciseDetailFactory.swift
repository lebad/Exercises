//
//  ExerciseDetailFactory.swift
//  Exercises
//
//  Created by Andrey Lebedev on 23.01.2024.
//

import UIKit

class ExerciseDetailFactory {
	func make(with exercise: ExerciseItem) -> UIViewController {
		let viewModel = ExerciseDetailViewModel(exercise: exercise, exerciseService: ExerciseService())
		return ExerciseDetailViewController(viewModel: viewModel)
	}
}
