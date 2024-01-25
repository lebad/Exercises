//
//  ExercisesViewModelTests.swift
//  ExercisesTests
//
//  Created by Andrey Lebedev on 26.01.2024.
//

import XCTest
@testable import Exercises

final class ExercisesViewModelTests: XCTestCase {
	var serviceMock: ExerciseServiceMock!
	
	override func setUp() {
		super.setUp()
		serviceMock = ExerciseServiceMock()
	}
	
	override func tearDown() {
		super.tearDown()
		serviceMock = nil
	}
	
	func test_start_whenUndefinedError_shouldErrorMessage() {
		// arrange
		serviceMock.result = .failure(ExerciseServiceError.undefinedError)
		let viewModel = ExercisesViewModel(exerciseService: serviceMock)
		
		// act
		viewModel.start()
		
		// assert
		XCTAssertTrue(viewModel.shouldShowAlert)
		XCTAssertEqual(viewModel.errorMessage, "Something went wrong. Please try again later")
		XCTAssertEqual(viewModel.errorTitle, "Error")
		XCTAssertEqual(viewModel.errorOkButtonTitle, "OK")
		
		XCTAssertFalse(viewModel.isLoading)
		XCTAssertEqual(viewModel.screenTitle, "Exercises")
	}
	
	func test_start_whenServerError_shouldErrorServerMessage() {
		// arrange
		let serverMessage = "Server is not available"
		serviceMock.result = .failure(ExerciseServiceError.serverError(serverMessage))
		let viewModel = ExercisesViewModel(exerciseService: serviceMock)
		
		// act
		viewModel.start()
		
		// assert
		XCTAssertTrue(viewModel.shouldShowAlert)
		XCTAssertEqual(viewModel.errorMessage, serverMessage)
		XCTAssertEqual(viewModel.errorTitle, "Error")
		XCTAssertEqual(viewModel.errorOkButtonTitle, "OK")
		
		XCTAssertFalse(viewModel.isLoading)
		XCTAssertEqual(viewModel.screenTitle, "Exercises")
	}
	
	func test_start_whenSuccess_shouldShowExercises() {
		// arrange
		serviceMock.result = .success(TestData.exercises)
		let viewModel = ExercisesViewModel(exerciseService: serviceMock)
		
		// act
		viewModel.start()
		
		// assert
		XCTAssertEqual(viewModel.exercises, TestData.exercises)
		
		XCTAssertFalse(viewModel.isLoading)
		XCTAssertEqual(viewModel.screenTitle, "Exercises")
	}
}

extension ExercisesViewModelTests {
	enum TestData {
		static let exercises = [
			ExerciseItem(
				id: 31,
				name: "Short text",
				description: "Description",
				imageUrls: [URL(string: "https://wger.de/media/exercise-images/805/ba006cae-44ca-46a9-bb71-6f5d4fa130e9.png")!],
				variationsId: 1
			),
			ExerciseItem(
				id: 32,
				name: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout",
				description: "",
				imageUrls: nil,
				variationsId: nil
			)
		]
	}
}
