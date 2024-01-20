//
//  ExercisesViewModel.swift
//  Exercises
//
//  Created by Andrey Lebedev on 20.01.2024.
//

import Foundation

class ExercisesViewModel: ObservableObject {
	@Published var screenTitle = ""
	@Published var exercises: [ExerciseItem] = []
	
	func fetchExercises() {
		
	}
}
