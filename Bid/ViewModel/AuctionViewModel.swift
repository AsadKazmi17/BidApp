//
//  AuctionViewModel.swift
//  Bid
//

import Foundation
import Combine

protocol AuctionViewModelProtocol: ObservableObject {
    var username: String { get set }
    var bidAmount: String { get set }
    var timeRemaining: Int { get }
    var isAuctionRunning: Bool { get }
    var winnerName: String { get }
    var auctionHistory: [BidModel] { get }
    var toastMessage: String { get }
    var showToast: Bool { get }
    var currentPrice: Int { get }
    var formattedCurrentPrice: String { get }
    var showWinner: Bool { get }
    var formattedTimeRemaining: String { get }
    var canPlaceBid: Bool { get }
    
    func startAuction()
    func endAuction()
    func placeBid()
    func resetAuction()
}

class AuctionViewModel: AuctionViewModelProtocol {
    @Published var username: String = ""
    @Published var bidAmount: String = ""
    @Published var timeRemaining: Int = Strings.AuctionSettings.auctionDuration
    @Published var isAuctionRunning = false
    @Published var winnerName: String = ""
    @Published var auctionHistory: [BidModel] = []

    @Published var toastMessage: String = ""
    @Published var showToast: Bool = false
    
    @Published var auction: Auction
    
    private var timer: AnyCancellable?
    private var simulatedBidTimer: AnyCancellable?
    private let auctionService: any AuctionServiceProtocol
    private let auctionDataService: any AuctionDataServiceProtocol
    private var currentUserId: String = ""
    private let auctionItem: AuctionItem

    init(auctionItem: AuctionItem, auctionService: any AuctionServiceProtocol, auctionDataService: any AuctionDataServiceProtocol) {
        self.auctionItem = auctionItem
        self.auctionService = auctionService
        self.auctionDataService = auctionDataService
        self.auction = Auction(startingPrice: auctionItem.startingPrice, currentBid: nil)
    }

    var currentPrice: Int {
        auction.currentBid?.amount ?? auction.startingPrice
    }
    
    var formattedCurrentPrice: String {
        return PriceFormatter.shared.formatAmount(currentPrice)
    }
    
    var showWinner: Bool {
        !isAuctionRunning && !winnerName.isEmpty
    }
    
    var formattedTimeRemaining: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var canPlaceBid: Bool {
        guard let amount = Int(bidAmount), !username.isEmpty, isAuctionRunning else { return false }
        
        if let lastBid = auctionHistory.last, lastBid.userId == currentUserId {
            return false
        }
        
        return amount > currentPrice
    }

    func startAuction() {
        if username.isEmpty {
            showToast(Strings.Toast.pleaseEnterName)
        } else {
            currentUserId = "\(Strings.UserIds.userPrefix)\(username.lowercased().replacingOccurrences(of: " ", with: "_"))_\(UUID().uuidString.prefix(8))"
            
            resetAuction()
            isAuctionRunning = true
            startTimer()
            startSimulatedBidding()
        }
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.checkTimer() }
    }
    
    private func startSimulatedBidding() {
        simulatedBidTimer = Timer.publish(every: Double.random(in: Strings.AuctionSettings.minSimulatedBidInterval...Strings.AuctionSettings.maxSimulatedBidInterval), on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.simulateBid()
            }
    }
    
    func endAuction() {
        timeRemaining = 0
        isAuctionRunning = false
        timer?.cancel()
        simulatedBidTimer?.cancel()
        winnerName = auction.currentBid?.bidderName ?? Strings.Toast.noWinner
        showToast("\(Strings.Toast.auctionEnded)\(winnerName)")
        
        let pastAuction = PastAuction(
            id: UUID().uuidString,
            auctionItem: auctionItem,
            winnerName: winnerName,
            winningBid: auction.currentBid?.amount ?? auctionItem.startingPrice,
            endDate: Date(),
            totalBids: auctionHistory.count
        )
        auctionDataService.savePastAuction(pastAuction)
    }

    func checkTimer() {
        guard timeRemaining > 1 else {
            endAuction()
            return
        }
        
        timeRemaining -= 1
    }

    func simulateBid() {
        guard isAuctionRunning else { return }
        
        auctionService.fetchBids(currentPrice: currentPrice) { [weak self] bid in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.auction.currentBid = bid
                self.auctionHistory.append(bid)
                let formattedAmount = PriceFormatter.shared.formatAmount(bid.amount)
                self.showToast("\(bid.bidderName)\(Strings.Toast.placedBid)\(formattedAmount)")
            }
        }
    }

    func placeBid() {
        guard let amount = Int(bidAmount), amount > currentPrice, !username.isEmpty else { 
            showToast(Strings.Toast.invalidBidAmount)
            bidAmount = ""
            return
        }
        
        if let lastBid = auctionHistory.last, lastBid.userId == currentUserId {
            showToast(Strings.Toast.yourBidAlreadyHighest)
            bidAmount = ""
            return
        }
        
        let bid = BidModel(bidderName: username, amount: amount, userId: currentUserId)
        auction.currentBid = bid
        auctionHistory.append(bid)
        let formattedAmount = PriceFormatter.shared.formatAmount(amount)
        showToast("\(Strings.Toast.youPlacedBid)\(formattedAmount)")
        bidAmount = ""
    }

    func resetAuction() {
        auction = Auction(startingPrice: auctionItem.startingPrice, currentBid: nil)
        timeRemaining = Strings.AuctionSettings.auctionDuration
        winnerName = ""
        bidAmount = ""
        auctionHistory.removeAll()
        timer?.cancel()
        simulatedBidTimer?.cancel()
    }

    private func showToast(_ message: String) {
        toastMessage = message
        showToast = true

        Task {
            try? await Task.sleep(nanoseconds: UInt64(Strings.AuctionSettings.toastDuration * 1_000_000_000)) // 3 seconds
            await MainActor.run {
                showToast = false
            }
        }
    }
    
    deinit {
        timer?.cancel()
        simulatedBidTimer?.cancel()
    }
}

