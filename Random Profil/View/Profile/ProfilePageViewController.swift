//
//  ProfilePageViewController.swift
//  Random Profil
//
//  Created by Jaehwa Noh on 2023/03/30.
//

import Foundation
import SwiftUI

struct ProfilePageViewController: UIViewControllerRepresentable {
    var pages: [ProfilePage]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let profilePageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        profilePageViewController.dataSource = context.coordinator
        return profilePageViewController
    }
    
    func updateUIViewController(_ profilePageViewController: UIPageViewController, context: Context) {
        profilePageViewController.setViewControllers([context.coordinator.controllers[0]], direction: .forward, animated: true)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource {
        var parent: ProfilePageViewController
        var controllers = [UIViewController]()
        
        init(_ profilePageViewController: ProfilePageViewController) {
            parent = profilePageViewController
            controllers = parent.pages.map {
                page in
                switch page {
                case is MaleView:
                    return UIHostingController(rootView: page as! MaleView)
                case is FemaleView:
                    return UIHostingController(rootView:page as! FemaleView)
                default:
                    return UIHostingController(rootView:page as! FemaleView)
                    
                }
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            
            if index + 1 == controllers.count {
                return nil
            }
            
            return controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            
            if index == 0 {
                return nil
            }
            
            return controllers[index - 1]
        }
    }
}
