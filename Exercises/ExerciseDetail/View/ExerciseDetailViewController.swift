//
//  ExerciseDetailViewController.swift
//  Exercises
//
//  Created by Andrey Lebedev on 22.01.2024.
//

import UIKit
import Combine
import CombineCocoa
import Kingfisher

class ExerciseDetailViewController: UIViewController, UIScrollViewDelegate {
	private struct Constants {
		static let scrolViewHeight: CGFloat = 300
		static let pageControlBottomOffset: CGFloat = 50
	}
	
	private let viewModel: ExerciseDetailViewModel
	private var cancellables = Set<AnyCancellable>()
	
	init(viewModel: ExerciseDetailViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
	
	private lazy var pageControl: UIPageControl = {
		let pageControl = UIPageControl()
		pageControl.currentPage = 0
		pageControl.currentPageIndicatorTintColor = .systemBlue
		pageControl.pageIndicatorTintColor = .systemGray
		return pageControl
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		setupScrollView()
		setupBinding()
		viewModel.start()
    }
	
	// MARK: Private
	
	private func setupViews() {
		view.addSubview(scrollView)
		view.addSubview(pageControl)
		
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.heightAnchor.constraint(equalToConstant: Constants.scrolViewHeight)
		])
		
		pageControl.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pageControl.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.pageControlBottomOffset)
		])
	}
	
	private func setupScrollView() {
		scrollView.didScrollPublisher
			.sink { [weak self] _ in
				guard let self else {
					return
				}
				let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
				pageControl.currentPage = Int(pageIndex)
			}
			.store(in: &cancellables)
	}
	
	private func setupBinding() {
		viewModel.$screenTitle
			.receive(on: DispatchQueue.main)
			.sink { [weak self] title in
				self?.title = title
			}
			.store(in: &cancellables)
		viewModel.$shouldShowImages
			.receive(on: DispatchQueue.main)
			.sink { [weak self] shouldShowImages in
				self?.scrollView.isHidden = !shouldShowImages
				self?.pageControl.isHidden = !shouldShowImages
			}
			.store(in: &cancellables)
		viewModel.$numberOfPages
			.receive(on: DispatchQueue.main)
			.assignWeak(to: \.numberOfPages, on: pageControl)
			.store(in: &cancellables)
		viewModel.$imageUrls
			.receive(on: DispatchQueue.main)
			.sink { [weak self] imageUrls in
				self?.setupImageUrls(imageUrls)
			}
			.store(in: &cancellables)
	}
	
	private func setupImageUrls(_ imageUrls: [URL]) {
		scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: Constants.scrolViewHeight)
		scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(imageUrls.count), height: Constants.scrolViewHeight)
		for (index, imageUrl) in imageUrls.enumerated() {
			let frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: Constants.scrolViewHeight)
			let imageView = UIImageView(frame: frame)
			imageView.contentMode = .scaleAspectFit
			imageView.kf.indicatorType = .activity
			scrollView.addSubview(imageView)
			imageView.kf.setImage(with: imageUrl)
		}
	}
}
