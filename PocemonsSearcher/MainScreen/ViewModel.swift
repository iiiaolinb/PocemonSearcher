//
//  ViewModel.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit
import Combine

final class ViewModel: NSObject {
    
        //модель данных, которая содержит информацию о имени покемона и ссылках на картинки
        //получаемая от API
    var myModel = [Model]()
    
        //модель данных о именах всех покемонов получаемая от API
    @Published var pocemonsWorld: PocemonsWorld?
    private var subscription: AnyCancellable? = nil
    
        //метод загружает и парсит данные о всех покемонал
    func loadPocemonList(closure: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.DefaultURL.URLForPocemonsWorld) else { return }
        subscription = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PocemonsWorld.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { value in
                switch value {
                case .failure(let error):
                    print("Loading data from API finished with error \(DataLoadError.sessionError(error))")
                    closure(false)
                case .finished:
                    closure(true)
                }
            }, receiveValue: { model in
                self.pocemonsWorld = model
            })
    }
       
        //метод загружает и парсит данные для одного покемона
        //либо возвращает полученную ошибку
    func loadPocemonWith(_ name: String, completion: @escaping (Result<Model, DataLoadError>) -> Void) {
        guard let url = URL(string: Constants.DefaultURL.baseURLAPI + name) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.sessionError(error)))
                return
            }
            guard let data = data, !data.isEmpty else {
                completion(.failure(.emptyData))
                return
            }
            if let pocemonsInfo = try? JSONDecoder().decode(Model.self, from: data) {
                completion(.success(pocemonsInfo))
            } else {
                completion(.failure(.decodeError))
            }
        }
        task.resume()
    }
    
        //ставим таймер, запускаем индикатор загрузки и ищем совпадения по введенной строке среди всех покемонов
        //если они есть, то отображаем их в collectionView
    func makePocemonMatch(with name: String, activityIndicator: UIActivityIndicatorView, collectionView: UICollectionView, navigationController: UINavigationController?) {
        let dispatchGroup = DispatchGroup()
        activityIndicator.startAnimating()
        loadPocemonList {
            if $0 {
                self.pocemonsWorld?.results?.forEach {
                    if let fullName = $0.name, fullName.contains(name.lowercased()) {
                        dispatchGroup.enter()
                        self.loadPocemonWith(fullName) { result in
                            switch result {
                            case .success(let pocemon):
                                self.myModel.append(pocemon)
                                dispatchGroup.leave()
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                                    navigationController?.present(alert, animated: true, completion: nil)
                                    dispatchGroup.leave()
                                }
                            }
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    collectionView.reloadData()
                    activityIndicator.stopAnimating()
                }
            } else {
                print("POCEMON LIST NOT LOADED")
            }
        }
    }
    
        //метод открывает экран PocemonsViewer с выбранным покемоном
    func openPocemon(_ pocemon: Model, with navigationController: UINavigationController?) {
        navigationController?.pushViewController(Coordinator.openPocemonsViewer(pocemon), animated: true)
    }
    
        //метод конфигурирует ячейку для table view
    func configureCollectionViewCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellId, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        cell.pocemonsName.text = myModel[indexPath.row].name
        let imageSize = CGSize(width: Constants.Sizes.cellEdgeSize, height: Constants.Sizes.cellEdgeSize)
        asyncLoadImage(cell.imageView, urlString: myModel[indexPath.row].sprites?.front_default ?? Constants.DefaultURL.badConnection, size: imageSize)
        
        return cell
    }
}
