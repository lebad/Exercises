//
//  ExerciseService.swift
//  Exercises
//
//  Created by Andrey Lebedev on 21.01.2024.
//

import Foundation
import Combine

enum ExerciseServiceError: Error {
	case undefinedError
	case serverError(String)
}

protocol ExerciseServiceProtocol {
	func fetchExercises() -> AnyPublisher<[ExerciseItem], Error>
}

class ExerciseService: ExerciseServiceProtocol {
	// didn't find the way to request exercises only with desirable language
	// so have to request all the data and filter here
	private static let languageId = 2
	
	func fetchExercises() -> AnyPublisher<[ExerciseItem], Error> {
		guard var urlComponents = URLComponents(string: "https://wger.de/api/v2/exercisebaseinfo/") else {
			return Fail<[ExerciseItem], Error>(error: ExerciseServiceError.undefinedError)
				.eraseToAnyPublisher()
		}
		urlComponents.queryItems = [
//			URLQueryItem(name: "variations", value: "5"),
//			URLQueryItem(name: "license_author", value: "trzr23"),
			URLQueryItem(name: "limit", value: "100")
		]
		guard let url = urlComponents.url else {
			return Fail<[ExerciseItem], Error>(error: ExerciseServiceError.undefinedError)
				.eraseToAnyPublisher()
		}
		return URLSession
			.shared
			.dataTaskPublisher(for: url)
			.receive(on: DispatchQueue.main)
			.tryMap { result in
				print(result.data.prettyString)
				let decoder = JSONDecoder()
				guard let urlResponse = result.response as? HTTPURLResponse,
					  (200...299).contains(urlResponse.statusCode) else {
					do {
						let apiError = try decoder.decode(APIError.self, from: result.data)
						throw ExerciseServiceError.serverError(apiError.detail)
					} catch {
						throw ExerciseServiceError.undefinedError
					}
				}
				do {
					let response = try decoder.decode(ResponseModel.self, from: result.data)
					let items: [ExerciseItem] = response.results.compactMap { exerciseBase in
						guard let exerciseItem = exerciseBase.mapToExerciseItem(for: Self.languageId) else {
							return nil
						}
						return exerciseItem
					}
					return items
				} catch {
					throw ExerciseServiceError.undefinedError
				}
			}
			.eraseToAnyPublisher()
	}
}

private struct APIError: Decodable {
	let detail: String
}

private struct ResponseModel: Decodable {
	let results: [ExerciseBase]
}

private struct ExerciseBase: Decodable {
	struct Exercise: Decodable {
		let id: Int
		let name: String
		let language: Int
	}
	struct ExerciseImage: Decodable {
		let id: Int
		let image: String
	}
	
	let id: Int
	let exercises: [Exercise]
	let images: [ExerciseImage]
	
	enum CodingKeys: CodingKey {
		case id
		case exercises
		case images
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int.self, forKey: CodingKeys.id)
		exercises = try container.decode([Exercise].self, forKey: CodingKeys.exercises)
		images = (try? container.decode([ExerciseImage].self, forKey: CodingKeys.images)) ?? []
	}
	
	func mapToExerciseItem(for languageId: Int) -> ExerciseItem? {
		guard let exercise = exercises.first(where: { $0.language == languageId }) else {
			return nil
		}
		let imageUrls = images.compactMap { URL(string: $0.image) }
		return ExerciseItem(
			id: id,
			name: exercise.name,
			imageUrls: imageUrls
		)
	}
}
