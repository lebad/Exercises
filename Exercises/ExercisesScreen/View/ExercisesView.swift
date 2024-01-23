//
//  ExercisesView.swift
//  Exercises
//
//  Created by Andrey Lebedev on 20.01.2024.
//

import SwiftUI
import Combine
import Kingfisher

struct ExercisesView: ViewControllable {
	@StateObject var viewModel = ExercisesViewModel(exerciseService: ExerciseService())
	
	var holder = NavStackHolder()
	
    var body: some View {
		NavigationView {
			HStack {
				if viewModel.isLoading {
					ProgressView()
				} else {
					List(viewModel.exercises) { exercise in
						Button {
							navigateToExercise(with: exercise)
						} label: {
							ExerciseView(
								name: exercise.name,
								imageUrl: exercise.imageUrls?.first
							)
						}

//						NavigationLink(
//							destination: ExerciseDetails(
//								exercsise: exercise)
//							.navigationTitle("fkj")
//						) {
//								ExerciseView(
//									name: exercise.name,
//									imageUrl: exercise.imageUrls?.first
//								)
//							}
					}
				}
			}
		}
		.navigationTitle(viewModel.screenTitle)
		.onViewDidLoad {
			viewModel.start()
		}
		.alert(isPresented: $viewModel.shouldShowAlert) {
			Alert(
				title: Text(viewModel.errorTitle),
				message: Text(viewModel.errorMessage),
				dismissButton: .default(Text(viewModel.errorOkButtonTitle), action: {
					viewModel.dismissAlertButtonAction()
				})
			)
		}
    }
	
	private func navigateToExercise(with exercise: ExerciseItem) {
		guard let viewController = holder.viewController else { return }
		let newVc = ExerciseDetailFactory().make(with: exercise)
		viewController.navigationController?.pushViewController(newVc, animated: true)
	}
}

struct ExerciseView: View {
	let name: String
	let imageUrl: URL?
	
	var body: some View {
		HStack {
			KFImage(imageUrl)
				.placeholder { _ in
					Image(systemName: "photo")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50, height: 50)
				}
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 50, height: 50)
				.clipShape(RoundedRectangle(cornerRadius: 10))
			
			Text(name)
				.font(.headline)
				.padding(.leading, 8)
		}
	}
}

struct ExerciseDetails: UIViewControllerRepresentable {
	let exercsise: ExerciseItem
	
	func makeUIViewController(context: Context) -> UIViewController {
		ExerciseDetailFactory().make(with: exercsise)
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// MARK: - Preview

class ExerciseServicePreviewFake: ExerciseServiceProtocol {
	func fetchExercises() -> AnyPublisher<[ExerciseItem], Error> {
		Empty<[ExerciseItem], Error>()
			.eraseToAnyPublisher()
	}
}

extension ExercisesViewModel {
	static var preview: ExercisesViewModel {
		let viewModel = ExercisesViewModel(exerciseService: ExerciseServicePreviewFake())
		viewModel.screenTitle = "Exercises"
		viewModel.exercises = [
			ExerciseItem(
				id: 31,
				name: "Short text",
				imageUrls: [URL(string: "https://wger.de/media/exercise-images/805/ba006cae-44ca-46a9-bb71-6f5d4fa130e9.png")!]
			),
			ExerciseItem(
				id: 32,
				name: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout",
				imageUrls: [URL(string: "https://wger.de/media/exercise-images/1022/f74644fa-f43e-46bd-8603-6e3a2ee8ee2d.jpg")!]
			)
		]
		return viewModel
	}
}

#Preview {
	ExercisesView(viewModel: .preview)
}
