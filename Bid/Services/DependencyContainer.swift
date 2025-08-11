//
//  DependencyContainer.swift
//  Bid
//

import Foundation
import SwiftUI

protocol DependencyContainerProtocol {
    var auctionDataService: any AuctionDataServiceProtocol { get }
    var auctionService: any AuctionServiceProtocol { get }
}

class DependencyContainer: DependencyContainerProtocol {
    let auctionDataService: any AuctionDataServiceProtocol
    let auctionService: any AuctionServiceProtocol

    init(
        auctionDataService: any AuctionDataServiceProtocol = AuctionDataService(),
        auctionService: any AuctionServiceProtocol = AuctionService()
    ) {
        self.auctionDataService = auctionDataService
        self.auctionService = auctionService
    }
}

struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: any DependencyContainerProtocol = DependencyContainer()
}

extension EnvironmentValues {
    var dependencyContainer: any DependencyContainerProtocol {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
