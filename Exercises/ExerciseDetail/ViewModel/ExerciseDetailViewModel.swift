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
	@Published var shouldShowPageControl = false
	@Published var numberOfPages: Int = 0
	@Published var imageUrls: [URL] = []
	
	private let exercise: ExerciseItem
	
	init(exercise: ExerciseItem) {
		self.exercise = exercise
	}
	
	func start() {
		let imageUrlsCount = exercise.imageUrls?.count ?? 0
		screenTitle = exercise.name
		shouldShowImages = imageUrlsCount > 0
		shouldShowPageControl = imageUrlsCount > 1
		numberOfPages = exercise.imageUrls?.count ?? 0
		imageUrls = exercise.imageUrls ?? []
	}
}
