//
//  Constants.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit

enum Constants {
    enum Font {
        static var textMain = UIFont.systemFont(ofSize: 18, weight: .medium)
        static var textSmall = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    enum Colors {
        static let white = UIColor.white
        static let brown = UIColor.brown
        static let black = UIColor.black
    }
    
    enum Sizes {
        static let screenHeight = UIScreen.main.bounds.height
        static let screenWidth = UIScreen.main.bounds.width
        static let collectionViewCellInsets: CGFloat = 10
        static let cellEdgeSize: CGFloat = Constants.Sizes.screenWidth / 2 - collectionViewCellInsets * 2
        static let cornerRadius: CGFloat = 10
    }
    
    enum DefaultURL {
            //URL для загрузки всех имеющихся покемонов
        static let URLForPocemonsWorld = "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0"
        
            //URL для получения данных от API
        static let baseURLAPI = "https://pokeapi.co/api/v2/pokemon/"
        
            //URL для экрана WebView
        static let baseURLPocemonsInfo = "https://www.pokemon.com/us/pokedex/"
        
            //URL для случая, если картинка от API не была получена
            //дефолтный динозаврик
        static let badConnection =  "https://storage.yandexcloud.net/printio/assets/realistic_views/round_mouse_pad/detailed/02c38a14fea7f3aea392ec09c2e32e955ad35361.jpg?1593264253"
    }
}
