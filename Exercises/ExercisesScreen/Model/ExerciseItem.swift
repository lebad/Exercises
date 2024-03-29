//
//  ExerciseItem.swift
//  Exercises
//
//  Created by Andrey Lebedev on 20.01.2024.
//

import Foundation

struct ExerciseItem: Identifiable, Equatable {
	let id: Int
	let name: String
	let description: String
	let imageUrls: [URL]?
	let variationsId: Int?
}
