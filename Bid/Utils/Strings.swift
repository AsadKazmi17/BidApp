//
//  Strings.swift
//  Bid
//

import Foundation

struct Strings {
    
    // MARK: - Auction View
    struct AuctionView {
        static let title = "🏆 Live Auction"
        static let subtitle = "Bid against simulated users in real-time!"
        static let yourName = "Your Name"
        static let enterYourName = "Enter your name"
        static let timeRemaining = "⏱ Time Remaining"
        static let currentPrice = "💰 Current Price"
        static let currentWinner = "👑 Current Winner"
        static let bid = "Bid: AED "
        static let noBidsYet = "No bids yet - be the first to bid!"
        static let yourBidAmount = "Your Bid Amount"
        static let enterAmountHigherThan = "Enter amount higher than AED "
        static let placeBid = "Place Bid"
        static let quickBidOptions = "Quick Bid Options:"
        static let auctionWinner = "🏆 Auction Winner"
        static let winningBid = "Winning Bid: AED "
        static let startNewAuction = "Start New Auction"
        static let done = "Done"
    }
    
    // MARK: - Toast Messages
    struct Toast {
        static let pleaseEnterName = "Please enter your name"
        static let invalidBidAmount = "Invalid bid amount or username"
        static let yourBidAlreadyHighest = "Your bid is already the highest!\nWait for someone else to bid."
        static let youPlacedBid = "You placed a bid of AED "
        static let auctionEnded = "Auction ended! Winner: "
        static let noWinner = "No Winner"
        static let placedBid = " placed a bid of AED "
    }
    
    // MARK: - User IDs
    struct UserIds {
        static let userPrefix = "user_"
        static let simPrefix = "sim_"
        static let unknown = "sim_unknown"
    }
    
    // MARK: - Simulated Users
    struct SimulatedUsers {
        static let names = [
            "Alice", "Bob", "Charlie", "Diana", "Eve", 
            "Frank", "Grace", "Henry", "Ivy", "Jack",
            "Kate", "Liam", "Mia", "Noah", "Olivia"
        ]
    }
    
    // MARK: - Auction Settings
    struct AuctionSettings {
        static let startingPrice = 100
        static let auctionDuration = 60
        static let minBidIncrement = 5
        static let maxBidIncrement = 50
        static let minSimulatedBidInterval = 4.0
        static let maxSimulatedBidInterval = 10.0
        static let toastDuration = 3.0
    }
    
    // MARK: - Quick Bid Increments
    struct QuickBidIncrements {
        static let increments = [10, 25, 50, 100]
    }
    
    // MARK: - Home View
    struct HomeView {
        static let activeAuctions = "Active Auctions"
        static let pastAuctions = "Past Auctions"
        static let startingPrice = "Starting Price"
        static let category = "Category"
        static let winner = "Winner"
        static let winningBid = "Winning Bid"
        static let ended = "Ended"
        
        static let headerTitle = "🏆 BidApp"
        static let headerDescription = "Live Auction Platform"
        
        static let pastAuctionTitle = "🏆 Past Auctions"
        static let pastAuctionDescription = "See who won previous auctions!"
        
        static let liveAuctionTitle = "🔥 Live Auctions"
        static let liveAuctionDescription = "Discover amazing items up for bidding!"
    }
    
    // MARK: - Active Auction Card
    struct AuctionCardView {
        static let tapToBid = "Tap to Bid"
        static let startingPrice = "Starting Price"
    }
}
