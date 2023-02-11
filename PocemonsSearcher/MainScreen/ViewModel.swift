//
//  ViewModel.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit
import Combine

final class ViewModel: NSObject {
    
    private var subscription: AnyCancellable? = nil
    var myModel = [Model]()
    
        //модель данных о именах всех покемонов получаемая от API
    @Published var pocemonsWorld: PocemonsWorld?
    
    func loadPocemonList(closure: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.DefaultURL.URLForPocemonsWorld) else { return }
        subscription = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PocemonsWorld.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { value in
                switch value {
                case .failure(let error):
                    print("Loading data from API finished with error \(error.localizedDescription)")
                    closure(false)
                case .finished:
                    closure(true)
                }
            }, receiveValue: { model in
                self.pocemonsWorld = model
            })
    }
    
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
