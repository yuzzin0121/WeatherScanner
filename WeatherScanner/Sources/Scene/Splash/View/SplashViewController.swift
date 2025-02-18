//
//  SplashViewController.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import UIKit
import Lottie
import Then

final class SplashViewController: UIViewController {
    private var animationView = LottieAnimationView(name: "splashAnimation.json").then {
        $0.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        $0.contentMode = .scaleAspectFit
    }
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        configureHierarchy()
        configureLayout()
        configureView()
        playSplashAnimation()
    }
    
    private func playSplashAnimation() {
        // 애니메이션 재생
        dispatchGroup.enter()
        animationView.play { [weak self] completed in
            guard let self else { return }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            CityManager.shared.saveToCityList { isSuccess in
                if isSuccess {
                    self.dispatchGroup.leave()
                } else {
                    // TODO: 에러 처리
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.showWeatherVC()
        }
    }
    
    private func showWeatherVC() {
        let weatherVC = WeatherViewController(viewModel: WeatherViewModel())
        weatherVC.modalTransitionStyle = .crossDissolve
        weatherVC.modalPresentationStyle = .fullScreen
//        present(weatherVC, animated: false)
        UIView.transition(with: self.view.window!, duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self else { return }
            self.present(weatherVC, animated: false, completion: nil)
        }, completion: nil)
    }
    
    private func configureHierarchy() {
        view.addSubview(animationView)
    }
    
    private func configureLayout() {
        animationView.center = view.center
    }
    
    private func configureView() {
        view.backgroundColor = Color.backgroundBlue
    }
}
