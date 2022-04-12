//
//  ItemImagesViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 12.04.22.
//

import UIKit

class ItemImagesViewController: UIPageViewController {

    private var items = [UIViewController]()
    
    var images: [UIImage?]? {
        didSet {
            setupUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        setupUI()
        decoratePageControl()
    }
    
    private func setupUI() {
        items = []
        populateViews()
        
        if let firstVC = items.first {
            setViewControllers([firstVC], direction: .forward, animated: false)
        }
    }
    
    private func decoratePageControl() {
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [ItemImagesViewController.self])
        appearance.pageIndicatorTintColor = .lightGray
        appearance.currentPageIndicatorTintColor = Constants.Colors.appPrimaryTextColor
    }
    
    private func populateViews() {
        guard let images = images else {
            return
        }

        for image in images {
            let vc = carouselItemVC(with: image)
            items.append(vc)
        }
    }
    
    private func carouselItemVC(with image: UIImage?) -> UIViewController {
        let viewController = UIViewController()
        
        let view = ItemImageView()
        view.showImage(image)
        viewController.view = view
        
        return viewController
    }
    
}

extension ItemImagesViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return items.last
        }
        
        guard items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard items.count != nextIndex else {
            return items.first
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        items.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
            return 0
        }
        
        return firstViewControllerIndex
    }
    
    
}


