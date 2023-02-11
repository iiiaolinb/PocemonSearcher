//
//  ViewerViewController.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit

final class ViewerViewController: UIViewController {
    
    private var selectedPocemon: Model?
    private var viewModel: ViewerViewModel?
    
    init(viewModel: ViewerViewModel, selectedPocemon: Model) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.selectedPocemon = selectedPocemon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "next"), for: .normal)
        button.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var previousButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(onPreviousButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var openButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Open full info", for: .normal)
        button.setTitleColor(Constants.Colors.brown, for: .normal)
        button.addTarget(self, action: #selector(onOpenButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupConstraints()
        viewModel?.loadImage(to: imageView, closure: { print($0) })
    }
    
    @objc private func onNextButtonTapped() {
        viewModel?.loadAndShowNextImage(to: imageView)
    }
    
    @objc private func onPreviousButtonTapped() {
        viewModel?.loadAndShowPreviousImage(to: imageView)
    }
    
    @objc private func onOpenButtonTapped() {
        guard let name = self.selectedPocemon?.name else { return }
        viewModel?.openWebViewScreen(with: navigationController, urlString: Constants.DefaultURL.baseURLPocemonsInfo + name)
    }
    
//    private func loadImage() {
//        DispatchQueue.global(qos: .userInteractive).async {
//            DispatchQueue.main.async {
//                guard let sprites = self.selectedPocemon?.sprites?.front_default else { return }
//                let image = simpleLoadImage(at: sprites)
//                UIView.transition(with: self.imageView,
//                                  duration: 1,
//                                  options: [.curveEaseOut, .transitionCrossDissolve],
//                                  animations: { self.imageView.image = image })
//            }
//        }
//    }
    
        //MARK: - setup constraints
    
    private func setupConstraints() {
        let buttonWidth: CGFloat = 40
        let buttonHeight: CGFloat = 80
        
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -buttonHeight)
        ])
        
        view.addSubview(previousButton)
        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previousButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            previousButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -buttonHeight)
        ])
        
        view.addSubview(openButton)
        NSLayoutConstraint.activate([
            openButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            openButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            openButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            openButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: openButton.topAnchor)
        ])
    }
}
