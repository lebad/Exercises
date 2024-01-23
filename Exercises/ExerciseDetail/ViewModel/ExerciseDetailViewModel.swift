//
//  ExerciseDetailViewModel.swift
//  Exercises
//
//  Created by Andrey Lebedev on 22.01.2024.
//

import Foundation

class ExerciseDetailViewModel {
	@Published var screenTitle = ""
	@Published var shouldShowImages = false
	@Published var numberOfPages: Int = 0
	@Published var imageUrls: [URL] = []
	
	private let exercise: ExerciseItem
	
	init(exercise: ExerciseItem) {
		self.exercise = exercise
	}
	
	func start() {
		screenTitle = exercise.name
		shouldShowImages = (exercise.imageUrls?.count ?? 0) > 0
		numberOfPages = exercise.imageUrls?.count ?? 0
		imageUrls = exercise.imageUrls ?? []
	}
}
