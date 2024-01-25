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
	@Published var variationsTitle = "Show Variations"
	@Published var noContentTitle = "Sorry, no content is here"
	@Published var description = ""
	@Published var shouldShowImages = false
	@Published var shouldShowPageControl = false
	@Published var numberOfPages: Int = 0
	@Published var imageUrls: [URL] = []
	
	@Published var shouldShowVariation = false
	@Published var shouldOpenVariation = false
	@Published var isLoadingVariations = false
	@Published var variationExercises: [ExerciseItem] = []
	@Published var showNoContent = false
	
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
		numberOfPages = imageUrlsCount
		imageUrls = exercise.imageUrls ?? []
		description = exercise.description
		
		shouldShowImages = imageUrlsCount > 0
		shouldShowPageControl = imageUrlsCount > 1
		shouldShowVariation = exercise.variationsId != nil
		showNoContent = exercise.description.isEmpty && imageUrlsCount == 0 && exercise.variationsId == nil
	}
	
	func showVariations() {
		shouldOpenVariation = true
		fetchVariationExercises()
	}
	
	private func fetchVariationExercises() {
		isLoadingVariations = true
		exerciseService.fetchExercises(with: exercise.variationsId)
			.sink { [weak self] completion in
				self?.isLoadingVariations = false
				if case .failure(let error) = completion,
					let _ = error as? ExerciseServiceError {
					self?.shouldShowVariation = false
				}
			} receiveValue: { [weak self] exercises in
				guard let self else {
					return
				}
				self.shouldShowVariation = true
				self.variationExercises = exercises.filter { $0.id != self.exercise.id }
			}
			.store(in: &cancellables)
	}
}
