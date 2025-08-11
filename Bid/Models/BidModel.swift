//
//  BidModel.swift
//  Bid
//

import Foundation

struct BidModel: Identifiable {
    let id = UUID()
    let bidderName: String
    let amount: Int
    let userId: String
}
