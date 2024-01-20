//
//  ExercisesView.swift
//  Exercises
//
//  Created by Andrey Lebedev on 20.01.2024.
//

import SwiftUI

struct ExercisesView: View {
	@StateObject var viewModel = ExercisesViewModel()
	
    var body: some View {
		NavigationView {
			List(viewModel.exercises) { exercise in
				HStack {
					AsyncImage(url: exercise.imageUrl) { image in
						image
							.resizable()
//							.scaledToFit()
					} placeholder: {
						Image(systemName: "photo")
							.resizable()
//							.scaledToFit()
							.aspectRatio(contentMode: .fit)
							.frame(width: 50, height: 50)
					}
					.frame(width: 50, height: 50)
					.clipShape(RoundedRectangle(cornerRadius: 10))
					
					Text(exercise.name)
						.font(.headline)
						.padding(.leading, 8)
				}
			}
		}
		.navigationTitle(viewModel.screenTitle)
		.onAppear {
			viewModel.fetchExercises()
		}
    }
}

extension ExercisesViewModel {
	static var preview: ExercisesViewModel {
		let viewModel = ExercisesViewModel()
		viewModel.screenTitle = "Exercises"
		viewModel.exercises = [
			ExerciseItem(
				id: 31,
				name: "Short text",
				imageUrl: URL(string: "https://wger.de/media/exercise-images/805/ba006cae-44ca-46a9-bb71-6f5d4fa130e9.png")!
			),
			ExerciseItem(
				id: 32,
				name: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout",
				imageUrl: URL(string: "https://wger.de/media/exercise-images/1022/f74644fa-f43e-46bd-8603-6e3a2ee8ee2d.jpg")!
			)
		]
		return viewModel
	}
}

#Preview {
	ExercisesView(viewModel: .preview)
}
