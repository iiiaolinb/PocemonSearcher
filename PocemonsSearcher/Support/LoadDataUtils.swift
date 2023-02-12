//
//  LoadDataUtils.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 08.02.2023.
//

import UIKit

    //метод загружает изображение по ссылке без лишних параметров
func simpleLoadImage(at urlString: String?) -> UIImage {
    guard let urlString = urlString,
          let url = URL(string: urlString),
          let data = try? Data(contentsOf: url),
          let image = UIImage(data: data)
    else {
        print("Error: image not loaded")
        return UIImage()
    }
    return image
}

    //метод асинхронно загружает изображение и вставляет
    //в нужное ImageView с анимацией
func asyncLoadImage(_ imageView: UIImageView, urlString: String, size: CGSize) {
    let queue = DispatchQueue.global(qos: .userInteractive)
    queue.async {
        DispatchQueue.main.async {
            let image = resizeImage(at: urlString, for: size)
            UIView.transition(with: imageView,
                              duration: 0.5,
                              options: [.curveEaseOut, .transitionCrossDissolve],
                              animations: {
                                imageView.image = image
                            })
        }
    }
}

    //метод перерисовывает изображение до заданных размеров
func resizeImage(at urlString: String, for size: CGSize) -> UIImage? {
    let file = urlString.removingPercentEncoding ?? Constants.DefaultURL.badConnection

    guard let url = URL(string: file),
          let data = try? Data(contentsOf: url)
    else {
        print("Error: image not loaded")
        return UIImage()
    }
    let image = UIImage(data: data) ?? UIImage()

    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
    }
}
