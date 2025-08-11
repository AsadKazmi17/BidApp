//
//  ViewModelFactory.swift
//  Bid
//

import Foundation
import SwiftUI

protocol ViewModelFactoryProtocol {
    func createAuctionViewModel(for auctionItem: AuctionItem) -> AuctionViewModel
}

class ViewModelFactory: ViewModelFactoryProtocol {
    private let dependencyContainer: any DependencyContainerProtocol
    
    init(dependencyContainer: any DependencyContainerProtocol) {
        self.dependencyContainer = dependencyContainer
    }
    
    func createAuctionViewModel(for auctionItem: AuctionItem) -> AuctionViewModel {
        return AuctionViewModel(
            auctionItem: auctionItem,
            auctionService: dependencyContainer.auctionService,
            auctionDataService: dependencyContainer.auctionDataService
        )
    }
}

struct ViewModelFactoryKey: EnvironmentKey {
    static let defaultValue: any ViewModelFactoryProtocol = ViewModelFactory(dependencyContainer: DependencyContainer())
}

extension EnvironmentValues {
    var viewModelFactory: any ViewModelFactoryProtocol {
        get { self[ViewModelFactoryKey.self] }
        set { self[ViewModelFactoryKey.self] = newValue }
    }
}
