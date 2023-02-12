//
//  CollectionViewCell.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let cellId = "CollectionViewCell"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = Constants.Sizes.cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 1
        imageView.layer.masksToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var pocemonsName: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = Constants.Font.textSmall
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(pocemonsName)
        pocemonsName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        pocemonsName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        pocemonsName.heightAnchor.constraint(equalToConstant: 15).isActive = true
        pocemonsName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: pocemonsName.topAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
