//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 01/06/2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var onButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Вот это технологии!", for: .normal)
        button.addTarget(self, action: #selector(didTapControllers), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .black
        
        return pageControl
    }()
    
    var controllers: (() -> Void)?
    private let pages: [UIViewController] = [
        OnboardingPageViewController(
            text: "Отслеживайте только то, что хотите",
            backgroundImage: UIImage(named: "onboardingBlue")
        ),
        OnboardingPageViewController(
            text: "Даже если это не литры воды и йога",
            backgroundImage: UIImage(named: "onboardingRed")
        )
    ]
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        setupConstraints()
    }
    
 
    @objc
    private func didTapControllers() {
        controllers?()
    }
}

private extension OnboardingViewController {
    func setupContent() {
        dataSource = self
        delegate = self
        
        if let firstPage = pages.first {
            setViewControllers(
                [firstPage],
                direction: .forward,
                animated: true
            )
        }
        
        view.addSubview(pageControl)
        view.addSubview(onButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // pageControl
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: onButton.topAnchor, constant: -24),
            // confirmButton
            onButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
           onButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let prevIndex = currentIndex - 1
        
        guard prevIndex >= 0 else { return nil }
        
        return pages[prevIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = currentIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentViewController)
        else { return }
        
        pageControl.currentPage = currentIndex
    }
}
