//
//  ExercisesView.swift
//  Exercises
//
//  Created by Andrey Lebedev on 24.01.2024.
//

import SwiftUI
import Combine

struct ExercisesView: ViewControllable {
	var holder = NavStackHolder()
	
	class ViewModel: ObservableObject {
		@Published var isLoading = false
		@Published var exercises: [ExerciseItem] = []
		let exerciseSelectSubject = PassthroughSubject<ExerciseItem, Never>()
	}
	
	@StateObject var viewModel: ViewModel
	
    var body: some View {
		HStack {
			if viewModel.isLoading {
				ProgressView()
			} else {
				List(viewModel.exercises) { exercise in
					Button {
						viewModel.exerciseSelectSubject.send(exercise)
					} label: {
						ExerciseRowView(
							name: exercise.name,
							imageUrl: exercise.imageUrls?.first,
							isVariations: exercise.variationsId != nil
						)
					}
				}
			}
		}
    }
}

#Preview {
	ExercisesView(viewModel: ExercisesView.ViewModel())
}
