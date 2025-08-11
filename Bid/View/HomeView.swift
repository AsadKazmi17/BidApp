//
//  HomeView.swift
//  Bid
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var auctionDataService: AuctionDataService
    @Environment(\.viewModelFactory) private var viewModelFactory
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.indigo, .cyan]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header
                    headerSection
                    
                    // Custom Tab Bar
                    tabButtonsSection
                    
                    // Content based on selected tab
                    TabView(selection: $selectedTab) {
                        activeAuctionsView
                            .tag(0)
                        
                        pastAuctionsView
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(Strings.HomeView.headerTitle)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            Text(Strings.HomeView.headerDescription)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var tabButtonsSection: some View {
        HStack(spacing: 0) {
            tabButton(title: Strings.HomeView.activeAuctions, isSelected: selectedTab == 0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 0
                }
            }
            
            tabButton(title: Strings.HomeView.pastAuctions, isSelected: selectedTab == 1) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 1
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private func tabButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                
                Rectangle()
                    .fill(isSelected ? Color.white : Color.clear)
                    .frame(height: 3)
                    .cornerRadius(1.5)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var activeAuctionsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(Strings.HomeView.liveAuctionTitle)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text(Strings.HomeView.liveAuctionDescription)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(auctionDataService.activeAuctions) { auction in
                        NavigationLink(destination: AuctionView(auctionItem: auction, viewModelFactory: viewModelFactory)) {
                            AuctionCardView(auction: auction)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .refreshable {
            auctionDataService.loadActiveAuctions()
        }
    }
    
    private var pastAuctionsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(Strings.HomeView.pastAuctionTitle)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text(Strings.HomeView.pastAuctionDescription)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                LazyVStack(spacing: 16) {
                    ForEach(auctionDataService.pastAuctions) { pastAuction in
                        PastAuctionCardView(pastAuction: pastAuction)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    HomeView()
} 
