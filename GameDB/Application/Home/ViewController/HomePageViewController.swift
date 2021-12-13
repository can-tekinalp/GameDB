//
//  HomPageViewController.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import UIKit

protocol HomePageViewControllerDelegate: NSObjectProtocol {
    func didScrollTo(_ index: Int)
    func shouldRouteToDetail(_ viewModel: PageVM)
}

final class HomePageViewController: UIPageViewController {

    static let storyboard = "Main"
    static let pageCount = 3
    
    private var controllers: [UIViewController] = []
    private var homePageVM: HomePageControllerVM?
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return controllers.firstIndex(of: vc) ?? 0
    }
    
    weak var homPageViewControllerDelegate: HomePageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func scrollTo(_ index: Int) {
        setViewControllers([controllers[index]], direction: .forward, animated: true, completion: nil)
    }
    
    func setViewModel(_ viewModel: HomePageControllerVM?) {
        homePageVM = viewModel
        for (index, controller) in controllers.enumerated() {
            guard let imageViewController = controller as? ImageViewController else { return }
            imageViewController.configure(viewModel: viewModel?.pageViewModel(at: index))
        }
    }
    
    private func setup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controllers = Array(0..<HomePageViewController.pageCount).map { _ in
            let imageVC = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
            imageVC.delegate = self
            return imageVC
        }
        dataSource = self
        delegate = self
        setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
    }
}

extension HomePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            homPageViewControllerDelegate?.didScrollTo(currentIndex)
        }
    }
}

extension HomePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIntroPage = viewController as? ImageViewController,
            let index = controllers.firstIndex(of: currentIntroPage) {
            return controllers[safe: index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIntroPage = viewController as? ImageViewController,
            let index = controllers.firstIndex(of: currentIntroPage) {
            return controllers[safe: index + 1]
        }
        return nil
    }
}

extension HomePageViewController: ImageViewControllerDelegate {
    
    func didTapImage(with viewModel: PageVM) {
        homPageViewControllerDelegate?.shouldRouteToDetail(viewModel)
    }
}
