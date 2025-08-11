//
//  AuctionCardView.swift
//  Bid
//

import Foundation
import SwiftUI

struct AuctionCardView: View {
    let auction: AuctionItem

    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                AsyncImage(url: URL(string: auction.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()

                    case .failure:
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 35))
                                .foregroundColor(.white)
                            Text(Strings.AuctionCardView.tapToBid)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                        }

                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .frame(height: 130)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(spacing: 8) {
                Text(auction.title)
                    .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)

                Text(auction.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text(Strings.AuctionCardView.startingPrice)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(auction.formattedStartingPrice)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
        .frame(height: 350)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
    }
}
