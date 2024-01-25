//
//  ExercisesView.swift
//  Exercises
//
//  Created by Andrey Lebedev on 24.01.2024.
//

import SwiftUI

struct ExercisesView: ViewControllable {
	var holder = NavStackHolder()
	
	class ViewModel: ObservableObject {
		@Published var isLoading = false
		@Published var exercises: [ExerciseItem] = []
	}
	
	@StateObject var viewModel: ViewModel
	let onExerciseSelect: (ExerciseItem) -> Void
	
    var body: some View {
		HStack {
			if viewModel.isLoading {
				ProgressView()
			} else {
				List(viewModel.exercises) { exercise in
					Button {
						onExerciseSelect(exercise)
					} label: {
						ExerciseRowView(
							name: exercise.name,
							imageUrl: exercise.imageUrls?.first
						)
					}
				}
			}
		}
    }
}

#Preview {
	ExercisesView(
		viewModel: ExercisesView.ViewModel(),
		onExerciseSelect: { _ in }
	)
}
