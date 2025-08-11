//
//  PastAuctionCardView.swift
//  Bid
//

import Foundation
import SwiftUI

struct PastAuctionCardView: View {
    let pastAuction: PastAuction
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: pastAuction.auctionItem.imageURL)) { phase in
                switch phase {
                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.gray.opacity(0.7), .gray.opacity(0.5)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 90, height: 90)
                            
                            VStack(spacing: 4) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                        }
                        
                    case .success(let image):
                        ZStack {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .clipped()
                                .cornerRadius(12)
                            
                            VStack(spacing: 2) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.yellow)
                                
                                Text("Won")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(4)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(6)
                        }
                        
                    case .failure(_):
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.gray.opacity(0.7), .gray.opacity(0.5)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 90, height: 90)
                            
                            VStack(spacing: 4) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.yellow)
                                
                                Text("Won")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            }
                        }
                        
                    @unknown default:
                        EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(pastAuction.auctionItem.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("\(Strings.HomeView.winner): \(pastAuction.winnerName)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("\(Strings.HomeView.winningBid): \(pastAuction.formattedWinningBid)")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("\(Strings.HomeView.ended): \(pastAuction.formattedEndDate)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
