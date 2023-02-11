//
//  CollectionView.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit

class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellEdgeSize = CGSize(width: Constants.Sizes.cellEdgeSize,
                                      height: Constants.Sizes.cellEdgeSize)
    private let inset = Constants.Sizes.collectionViewCellInsets

    private var viewModel: ViewModel?
    private var navigationController: UINavigationController?
    
    init(viewModel: ViewModel, navigationController: UINavigationController) {
        let layout = UICollectionViewFlowLayout()
        
        super.init(frame: .zero, collectionViewLayout: layout)
        self.viewModel = viewModel
        self.navigationController = navigationController
        
        backgroundColor = .clear
        
        delegate = self
        dataSource = self
        register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellId)
        
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = viewModel?.myModel else { return 0 }
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        return viewModel.configureCollectionViewCell(collectionView, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellEdgeSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let pocemon = viewModel?.myModel[indexPath.row] else { return }
        viewModel?.openPocemon(pocemon, with: navigationController)
    }
}
