//
//  ExercisesView.swift
//  Exercises
//
//  Created by Andrey Lebedev on 20.01.2024.
//

import SwiftUI
import Combine
import Kingfisher

struct ExercisesScreenView: ViewControllable {
	@StateObject var viewModel: ExercisesViewModel
	@StateObject private var exercisesViewModel = ExercisesView.ViewModel()
	@State var cancellables = Set<AnyCancellable>()
	
	var holder = NavStackHolder()
	
    var body: some View {
		NavigationView {
			ExercisesView(viewModel: exercisesViewModel) { exercise in
				navigateToExercise(with: exercise)
			}
			.onAppear {
				bindViewModels()
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
				dismissButton: .default(Text(viewModel.errorOkButtonTitle))
			)
		}
    }
	
	private func bindViewModels() {
		viewModel.$isLoading
			.assign(to: \.isLoading, on: exercisesViewModel)
			.store(in: &cancellables)
		
		viewModel.$exercises
			.assign(to: \.exercises, on: exercisesViewModel)
			.store(in: &cancellables)
	}
	
	private func navigateToExercise(with exercise: ExerciseItem) {
		guard let viewController = holder.viewController else { return }
		let newVc = ExerciseDetailFactory().make(with: exercise)
		viewController.navigationController?.pushViewController(newVc, animated: true)
	}
}

struct ExerciseRowView: View {
	let name: String
	let imageUrl: URL?
	let isVariations: Bool
	
	var body: some View {
		HStack {
			KFImage(imageUrl)
				.placeholder { _ in
					Image(systemName: "photo")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50, height: 50)
						.foregroundColor(.gray)
				}
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 50, height: 50)
				.clipShape(RoundedRectangle(cornerRadius: 10))
			
			VStack(alignment: .leading, spacing: 5) {
				Text(name)
					.font(.headline)
					.padding(.leading, 8)
					.foregroundColor(.black)
				if isVariations {
					HStack {
						Text("Variations")
							.padding(.leading, 8)
							.foregroundColor(.black)
						Image(systemName: "circle.fill")
							.foregroundColor(.green)
					}
					.font(.system(size: 10))
				}
			}
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
	
	func fetchExercises(with variationsId: Int?) -> AnyPublisher<[ExerciseItem], Error> {
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
				description: "Description",
				imageUrls: [URL(string: "https://wger.de/media/exercise-images/805/ba006cae-44ca-46a9-bb71-6f5d4fa130e9.png")!],
				variationsId: nil
			),
			ExerciseItem(
				id: 32,
				name: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout", 
				description: "Description",
				imageUrls: [URL(string: "https://wger.de/media/exercise-images/1022/f74644fa-f43e-46bd-8603-6e3a2ee8ee2d.jpg")!],
				variationsId: nil
			)
		]
		return viewModel
	}
}

#Preview {
	ExercisesScreenView(viewModel: ExercisesViewModel.preview)
}
