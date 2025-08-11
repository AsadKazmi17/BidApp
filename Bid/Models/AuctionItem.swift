//
//  AuctionItem.swift
//  Bid
//

import Foundation

struct AuctionItem: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let imageURL: String
    let startingPrice: Int
    let category: String
    let condition: String
    let location: String
    
    var formattedStartingPrice: String {
        return PriceFormatter.shared.formatPrice(startingPrice)
    }
}

struct PastAuction: Identifiable, Codable {
    let id: String
    let auctionItem: AuctionItem
    let winnerName: String
    let winningBid: Int
    let endDate: Date
    let totalBids: Int
    
    var formattedWinningBid: String {
        return PriceFormatter.shared.formatPrice(winningBid)
    }
    
    var formattedEndDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: endDate)
    }
} 
