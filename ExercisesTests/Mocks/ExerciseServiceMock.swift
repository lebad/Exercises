//
//  ExerciseServiceMock.swift
//  ExercisesTests
//
//  Created by Andrey Lebedev on 26.01.2024.
//

import Foundation
import Combine
@testable import Exercises

class ExerciseServiceMock: ExerciseServiceProtocol {
	var result: Result<[ExerciseItem], Error> = .success([])
	var fetchExercisesCalled = false
	var variationsId: Int?
	
	func fetchExercises() -> AnyPublisher<[ExerciseItem], Error> {
		fetchExercisesCalled = true
		return result.publisher.eraseToAnyPublisher()
	}
	
	func fetchExercises(with variationsId: Int?) -> AnyPublisher<[ExerciseItem], Error> {
		self.variationsId = variationsId
		return result.publisher.eraseToAnyPublisher()
	}
}
