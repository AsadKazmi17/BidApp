//
//  AuctionView.swift
//  Bid
//

import Foundation
import SwiftUI

struct AuctionView: View {
    let auctionItem: AuctionItem
    @StateObject private var viewModel: AuctionViewModel
    @FocusState private var isBidFieldFocused: Bool
    @FocusState private var isUserFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    init(auctionItem: AuctionItem, viewModelFactory: any ViewModelFactoryProtocol) {
        self.auctionItem = auctionItem
        let vm = viewModelFactory.createAuctionViewModel(for: auctionItem)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.indigo, .cyan]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    headerSection()
                    
                    // User Name Input
                    userNameSection()
                    
                    // Timer and Current Price
                    timerAndCurrentPrice()
                    
                    // Current Winner Display
                    if !viewModel.showWinner {
                        currentWinnerSection()
                    }
                    
                    // Bid Input
                    if viewModel.isAuctionRunning {
                        bidInputSection()
                    }
                    
                    // Winner View
                    if viewModel.showWinner {
                        winnerView()
                    }
                    
                    Spacer(minLength: 20)
                    
                    // Start Auction Button
                    if !viewModel.isAuctionRunning {
                        Button(action: viewModel.startAuction) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                Text(Strings.AuctionView.startNewAuction)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
            // Toast Message
            if viewModel.showToast {
                showToastView()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(Strings.AuctionView.done) {
                    isUserFieldFocused = false
                    isBidFieldFocused = false
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if !viewModel.isAuctionRunning {
                        dismiss()
                    } else {
                        viewModel.toastMessage = "Auction is running"
                        viewModel.showToast = true
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var timeRemainingColor: Color {
        if viewModel.timeRemaining <= 10 {
            return .red
        } else if viewModel.timeRemaining <= 30 {
            return .orange
        } else {
            return .white
        }
    }
    
    private func headerSection() -> some View {
        VStack(spacing: 8) {
            Text(auctionItem.title)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(auctionItem.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(.horizontal, 16)
    }
    
    private func userNameSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Strings.AuctionView.yourName)
                .font(.headline)
                .foregroundColor(.white)
            
            TextField(Strings.AuctionView.enterYourName, text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(viewModel.isAuctionRunning)
                .focused($isUserFieldFocused)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func currentWinnerSection() -> some View {
        if let currentBid = viewModel.auction.currentBid {
            VStack(spacing: 8) {
                Text(Strings.AuctionView.currentWinner)
                    .font(.headline)
                    .foregroundColor(.yellow)
                
                Text(currentBid.bidderName)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Text("\(Strings.AuctionView.bid)\(currentBid.amount)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
        } else {
            Text(Strings.AuctionView.noBidsYet)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .padding()
        }
    }
    
    private func bidInputSection() -> some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text(Strings.AuctionView.yourBidAmount)
                    .font(.headline)
                    .foregroundColor(.white)
                
                TextField("\(Strings.AuctionView.enterAmountHigherThan)\(viewModel.formattedCurrentPrice)", text: $viewModel.bidAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isBidFieldFocused)
            }
            
            Button(action: viewModel.placeBid) {
                Text(Strings.AuctionView.placeBid)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(viewModel.canPlaceBid ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(!viewModel.canPlaceBid)
            
            // Quick Bid Options
            if viewModel.isAuctionRunning {
                quickBidButtons()
            }
        }
        .padding(.horizontal)
    }
    
    private func timerAndCurrentPrice() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(Strings.AuctionView.timeRemaining)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                Text(viewModel.formattedTimeRemaining)
                    .font(.title2.bold())
                    .foregroundColor(timeRemainingColor)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(Strings.AuctionView.currentPrice)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                Text("AED \(viewModel.formattedCurrentPrice)")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func quickBidButtons() -> some View {
        let currentAmount = viewModel.currentPrice
        let increments = Strings.QuickBidIncrements.increments
        
        return VStack(alignment: .leading, spacing: 8) {
            Text(Strings.AuctionView.quickBidOptions)
                .font(.subheadline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(increments, id: \.self) { increment in
                    Button(action: {
                        viewModel.bidAmount = "\(currentAmount + increment)"
                        viewModel.placeBid()
                    }) {
                        Text("+AED \(increment)")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    private func winnerView() -> some View {
        VStack(spacing: 15) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            Text(Strings.AuctionView.auctionWinner)
                .font(.title2.bold())
                .foregroundColor(.yellow)
            
            Text(viewModel.winnerName)
                .font(.title)
                .foregroundColor(.white)
            
            if let winningBid = viewModel.auction.currentBid {
                Text("\(Strings.AuctionView.winningBid)\(winningBid.amount)")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Button(action: viewModel.startAuction) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text(Strings.AuctionView.startNewAuction)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.blue)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.6))
        )
        .padding(.horizontal)
    }
    
    private func showToastView() -> some View {
        VStack {
            Spacer()
            Text(viewModel.toastMessage)
                .font(.subheadline.bold())
                .padding()
                .background(.thinMaterial)
                .cornerRadius(12)
                .shadow(radius: 10)
                .transition(
                    .move(edge: .bottom).combined(with: .opacity)
                )
                .padding(.bottom, 40)
        }
        .animation(.easeInOut(duration: 0.4), value: viewModel.showToast)
    }
}

#Preview {
    let sampleAuction = AuctionItem(
        id: "preview",
        title: "iPhone 15 Pro Max",
        description: "Latest iPhone in pristine condition",
        imageURL: "iphone",
        startingPrice: 3500,
        category: "Electronics",
        condition: "Like New",
        location: "Dubai"
    )
    let container = DependencyContainer(
        auctionDataService: AuctionDataService(),
        auctionService: AuctionService()
    )
    let factory = ViewModelFactory(dependencyContainer: container)
    return AuctionView(auctionItem: sampleAuction, viewModelFactory: factory)
}
