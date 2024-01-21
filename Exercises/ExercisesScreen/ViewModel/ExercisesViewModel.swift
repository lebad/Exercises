//
//  ExercisesViewModel.swift
//  Exercises
//
//  Created by Andrey Lebedev on 20.01.2024.
//

import Foundation
import Combine

class ExercisesViewModel: ObservableObject {
	@Published var screenTitle = "Exercises"
	@Published var exercises: [ExerciseItem] = []
	@Published var isLoading = false
	
	@Published var shouldShowAlert = false
	@Published var errorTitle = "Error"
	@Published var errorMessage = ""
	@Published var errorOkButtonTitle = "OK"
	
	private var cancellables = Set<AnyCancellable>()
	private let exerciseService: ExerciseServiceProtocol
	
	init(exerciseService: ExerciseServiceProtocol) {
		self.exerciseService = exerciseService
	}
	
	func fetchExercises() {
		isLoading = true
		exerciseService.fetchExercises()
			.sink { [weak self] completion in
				self?.isLoading = false
				if case .failure(let error) = completion, 
					let serviceError = error as? ExerciseServiceError {
					self?.shouldShowAlert = true
					switch serviceError {
					case .undefinedError:
						self?.errorMessage = "Something went wrong. Please try again later"
					case let .serverError(errorText):
						self?.errorMessage = errorText
					}
				}
			} receiveValue: { [weak self] exercises in
				self?.exercises = exercises
			}
			.store(in: &cancellables)
	}
	
	func dismissAlertButtonAction() {
		shouldShowAlert = false
	}
}
