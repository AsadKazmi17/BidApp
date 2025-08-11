//
//  AuctionService.swift
//  Bid
//

import Foundation

protocol AuctionServiceProtocol {
    func fetchBids(currentPrice: Int, completion: @escaping (BidModel) -> Void)
}

class AuctionService: AuctionServiceProtocol {
    private let simulatedUsers: [(String, String)] = {
        return Strings.SimulatedUsers.names.enumerated().map { index, name in
            ("\(Strings.UserIds.simPrefix)\(name.lowercased())", name)
        }
    }()
    
    func fetchBids(currentPrice: Int, completion: @escaping (BidModel) -> Void) {
        let bidIncrement = Int.random(in: Strings.AuctionSettings.minBidIncrement...Strings.AuctionSettings.maxBidIncrement)
        let newAmount = currentPrice + bidIncrement
        
        let randomUser = simulatedUsers.randomElement() ?? (Strings.UserIds.unknown, "Unknown")
        
        let bid = BidModel(bidderName: randomUser.1, amount: newAmount, userId: randomUser.0)
        completion(bid)
    }
}
