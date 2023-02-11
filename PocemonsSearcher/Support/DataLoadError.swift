//
//  DataLoadError.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 10.02.2023.
//

import Foundation

enum DataLoadError: Error {
    
    case emptyData
    
    case decodeError
    
    case imagesNotLoaded
    
    case sessionError(Error)
}
