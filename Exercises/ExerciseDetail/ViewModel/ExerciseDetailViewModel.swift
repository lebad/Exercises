//
//  ExerciseDetailViewModel.swift
//  Exercises
//
//  Created by Andrey Lebedev on 22.01.2024.
//

import Foundation
import SwiftUI
import Combine

class ExerciseDetailViewModel: ObservableObject {
	@Published var screenTitle = ""
	@Published var variationsTitle = "Variations:"
	@Published var shouldShowImages = false
	@Published var shouldShowPageControl = false
	@Published var numberOfPages: Int = 0
	@Published var imageUrls: [URL] = []
	
	@Published var shouldShowVariation = false
	@Published var isLoadingVariations = false
	@Published var variationExercises: [ExerciseItem] = []
	
	private let exercise: ExerciseItem
	private let exerciseService: ExerciseServiceProtocol
	
	private var cancellables = Set<AnyCancellable>()
	
	init(
		exercise: ExerciseItem,
		exerciseService: ExerciseServiceProtocol
	) {
		self.exercise = exercise
		self.exerciseService = exerciseService
	}
	
	func start() {
		let imageUrlsCount = exercise.imageUrls?.count ?? 0
		screenTitle = exercise.name
		shouldShowImages = imageUrlsCount > 0
		shouldShowPageControl = imageUrlsCount > 1
		numberOfPages = exercise.imageUrls?.count ?? 0
		imageUrls = exercise.imageUrls ?? []
		shouldShowVariation = exercise.variationsId != nil
		
		fetchVariationExercises()
	}
	
	private func fetchVariationExercises() {
		isLoadingVariations = true
		exerciseService.fetchExercises(with: exercise.variationsId)
			.sink { [weak self] completion in
				self?.isLoadingVariations = false
			} receiveValue: { [weak self] exercises in
				self?.variationExercises = exercises
			}
			.store(in: &cancellables)
	}
}
