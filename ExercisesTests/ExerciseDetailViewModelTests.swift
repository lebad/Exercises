//
//  ExerciseDetailViewModelTests.swift
//  ExercisesTests
//
//  Created by Andrey Lebedev on 26.01.2024.
//

import XCTest
@testable import Exercises

final class ExerciseDetailViewModelTests: XCTestCase {
	var serviceMock: ExerciseServiceMock!
	
	override func setUp() {
		super.setUp()
		serviceMock = ExerciseServiceMock()
	}
	
	// MARK: - start
	
	func test_start_whenExerciseFull_shouldInitializeCorrectly() {
		// arrange
		let viewModel = ExerciseDetailViewModel(exercise: TestData.exerciseFull, exerciseService: serviceMock)
		
		// act
		viewModel.start()
		
		// assert
		XCTAssertEqual(viewModel.screenTitle, TestData.exerciseFull.name)
		XCTAssertEqual(viewModel.variationsTitle, "Show Variations")
		XCTAssertEqual(viewModel.noContentTitle, "Sorry, no content is here")
		XCTAssertEqual(viewModel.numberOfPages, 1)
		XCTAssertEqual(viewModel.imageUrls, TestData.exerciseFull.imageUrls)
		XCTAssertEqual(viewModel.description, TestData.exerciseFull.description)
		XCTAssertTrue(viewModel.shouldShowImages)
		XCTAssertFalse(viewModel.shouldShowPageControl)
		XCTAssertTrue(viewModel.shouldShowVariation)
		XCTAssertFalse(viewModel.showNoContent)
	}
	
	func test_start_whenExerciseEmpty_shouldInitializeCorrectly() {
		// arrange
		let viewModel = ExerciseDetailViewModel(exercise: TestData.exerciseEmpty, exerciseService: serviceMock)
		
		// act
		viewModel.start()
		
		// assert
		XCTAssertEqual(viewModel.screenTitle, TestData.exerciseEmpty.name)
		XCTAssertEqual(viewModel.variationsTitle, "Show Variations")
		XCTAssertEqual(viewModel.noContentTitle, "Sorry, no content is here")
		XCTAssertEqual(viewModel.numberOfPages, 0)
		XCTAssertEqual(viewModel.imageUrls, [])
		XCTAssertEqual(viewModel.description, TestData.exerciseEmpty.description)
		XCTAssertFalse(viewModel.shouldShowImages)
		XCTAssertFalse(viewModel.shouldShowPageControl)
		XCTAssertFalse(viewModel.shouldShowVariation)
		XCTAssertTrue(viewModel.showNoContent)
	}
	
	// MARK: - showVariations
	
	func test_showVariations_whenServiceError_shouldShowVariationFalse() {
		// arrange
		serviceMock.result = .failure(ExerciseServiceError.undefinedError)
		let viewModel = ExerciseDetailViewModel(exercise: TestData.exerciseFull, exerciseService: serviceMock)
		
		// act
		viewModel.showVariations()
		
		// assert
		XCTAssertFalse(viewModel.shouldShowVariation)
		
		XCTAssertTrue(viewModel.shouldOpenVariation)
		XCTAssertEqual(serviceMock.variationsId, TestData.exerciseFull.variationsId)
		XCTAssertFalse(viewModel.isLoadingVariations)
	}
	
	func test_showVariations_whenSuccess_shouldShowVariationsAndFilterCurrentExercise() {
		// arrange
		serviceMock.result = .success(TestData.exercises)
		let viewModel = ExerciseDetailViewModel(exercise: TestData.exerciseFull, exerciseService: serviceMock)
		
		// act
		viewModel.showVariations()
		
		// assert
		XCTAssertTrue(viewModel.shouldShowVariation)
		XCTAssertEqual(viewModel.variationExercises, [TestData.exerciseEmpty])
		
		XCTAssertTrue(viewModel.shouldOpenVariation)
		XCTAssertEqual(serviceMock.variationsId, TestData.exerciseFull.variationsId)
		XCTAssertFalse(viewModel.isLoadingVariations)
	}
}

extension ExerciseDetailViewModelTests {
	enum TestData {
		static let exerciseFull = ExerciseItem(
			id: 31,
			name: "Short text",
			description: "Description",
			imageUrls: [URL(string: "https://wger.de/media/exercise-images/805/ba006cae-44ca-46a9-bb71-6f5d4fa130e9.png")!],
			variationsId: 1
		)
		static let exerciseEmpty = ExerciseItem(
			id: 32,
			name: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout",
			description: "",
			imageUrls: nil,
			variationsId: nil
		)
		static let exercises = [exerciseFull, exerciseEmpty]
	}
}
