//
//  BidApp.swift
//  Bid
//

import SwiftUI

@main
struct BidApp: App {
    private let container: DependencyContainer
    private let viewModelFactory: ViewModelFactory
    private let auctionDataService: AuctionDataService

    init() {
        let dataService = AuctionDataService()
        let container = DependencyContainer(auctionDataService: dataService, auctionService: AuctionService())
        self.auctionDataService = dataService
        self.container = container
        self.viewModelFactory = ViewModelFactory(dependencyContainer: container)
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.dependencyContainer, container)
                .environment(\.viewModelFactory, viewModelFactory)
                .environmentObject(auctionDataService)
        }
    }
}
