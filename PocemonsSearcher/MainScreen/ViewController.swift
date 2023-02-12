//
//  ViewController.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    private var viewModel: ViewModel!
    weak private var timer: Timer?

    lazy var collectionView = CollectionView(viewModel: viewModel, navigationController: navigationController ?? UINavigationController())
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Enter the pocemons name..."
        search.backgroundColor = .white
        search.searchTextField.backgroundColor = .white
        search.layer.cornerRadius = 16
        search.clipsToBounds = true
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    init(viewModel: ViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.brown
        searchBar.delegate = self
        setupConstraints()
    }
    
    //MARK: - search bar delegate functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            //ставим таймер, запускаем индикатор загрузки и ищем совпадения по введенной строке среди всех покемонов
            //если они есть, то отображаем их в collectionView
        timer?.invalidate()
        timer = .scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.viewModel.myModel.removeAll()
            self.activityIndicator.startAnimating()
            guard let name = searchBar.text else { return }
            self.viewModel.makePocemonMatch(with: name, activityIndicator: self.activityIndicator, collectionView: self.collectionView, navigationController: self.navigationController)
        }
        
            //если пользователь удалил все символы из поисковой строки, но обнуляем нашу модель
            //и обновляем collectionView
        if searchText.isEmpty {
            removeAndReloadData()
        }
    }
    
        //нажатие на крестик в поисковой строке
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeAndReloadData()
    }
    
    
        //нажатие на enter: запускаем индикатор загрузки и ищем совпадения по введенной
        //строке среди всех покемонов если они есть, то отображаем их в collectionView
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.activityIndicator.startAnimating()
        guard let name = searchBar.text else { return }
        viewModel.makePocemonMatch(with: name, activityIndicator: activityIndicator, collectionView: collectionView, navigationController: navigationController)
    }
    
    private func removeAndReloadData() {
        viewModel.myModel.removeAll()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    //MARK: - setup constraints
    
    private func setupConstraints() {
        let widthInset: CGFloat = 10
        let heightInset: CGFloat = 20
        
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthInset),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightInset),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthInset),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: heightInset),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

