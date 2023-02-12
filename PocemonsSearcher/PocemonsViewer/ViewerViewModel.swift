//
//  ViewerViewModel.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit

final class ViewerViewModel {
    
        //выбранный покемон
    private var selectedPocemon: Model?
    
        //маркер для отображения картинки (какая картинка на экране)
    private var onTheScreen = 0
    
        //массив, который хранит ссылки на изображения покемона
    lazy private var arrayOfSprites = [String?]()
    
    init(selectedPocemon: Model) {
        self.selectedPocemon = selectedPocemon
        fillingTheArray()
    }
    
        //метод открывает экран WebView
    func openWebViewScreen(with navigationController: UINavigationController?, urlString: String?) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(Coordinator.openWebViewScreen(urlString), animated: true)
    }
    
        //метод загружает и отображает с анимацией картинку на экране
    func loadImage(to imageView: UIImageView, closure: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                guard let sprite = self.arrayOfSprites[self.onTheScreen] else { return }
                let image = simpleLoadImage(at: sprite)
                UIView.transition(with: imageView,
                                  duration: 1,
                                  options: [.curveEaseOut, .transitionCrossDissolve],
                                  animations: { imageView.image = image })
                closure(true)
            }
        }
    }
    
        //метод для перехода к следующей картинке
    func loadAndShowNextImage(to imageView: UIImageView) {
        if onTheScreen < arrayOfSprites.count - 1 { onTheScreen += 1 } else { onTheScreen = 0 }
        loadImage(to: imageView) { $0 ? print($0) : nil }
    }
    
        //метод для перехода к предыдущей картинке
    func loadAndShowPreviousImage(to imageView: UIImageView) {
        if onTheScreen > 0 { onTheScreen -= 1 } else { onTheScreen = arrayOfSprites.count - 1 }
        loadImage(to: imageView) { $0 ? print($0) : nil }
    }
    
        //заполняем массив картинками (если они есть =) )
    private func fillingTheArray() {
        if let sprite = self.selectedPocemon?.sprites?.front_default { arrayOfSprites.append(sprite) }
        if let sprite = self.selectedPocemon?.sprites?.front_female { arrayOfSprites.append(sprite) }
        if let sprite = self.selectedPocemon?.sprites?.front_shiny {arrayOfSprites.append(sprite) }
        if let sprite = self.selectedPocemon?.sprites?.front_shiny_female { arrayOfSprites.append(sprite) }
        if let sprite = self.selectedPocemon?.sprites?.back_default { arrayOfSprites.append(sprite) }
        if let sprite = self.selectedPocemon?.sprites?.back_female { arrayOfSprites.append(sprite) }
        if let sprite = self.selectedPocemon?.sprites?.back_shiny { arrayOfSprites.append(sprite) }
        if let sprite = self.selectedPocemon?.sprites?.back_shiny_female { arrayOfSprites.append(sprite) }
    }
}

