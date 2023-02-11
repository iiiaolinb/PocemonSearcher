//
//  Coordinator.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit

class Coordinator {
    
    static func buildMainScreen() -> UIViewController {
        let viewModel = ViewModel()
        let viewController = ViewController(viewModel: viewModel)
        return viewController
    }
    
    static func openPocemonsViewer(_ selectedPocemon: Model) -> UIViewController {
        let viewModel = ViewerViewModel(selectedPocemon: selectedPocemon)
        let viewController = ViewerViewController(viewModel: viewModel, selectedPocemon: selectedPocemon)
        return viewController
    }
    
    static func openWebViewScreen(_ stringUrl: String?) -> UIViewController {
        let viewController = WebViewScreen(stringUrl: stringUrl)
        return viewController
    }
}
