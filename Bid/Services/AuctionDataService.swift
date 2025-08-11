//
//  AuctionDataService.swift
//  Bid
//

import Foundation

struct AuctionDataResponse: Codable {
    let auctions: [AuctionItem]
}

protocol AuctionDataServiceProtocol: ObservableObject {
    var activeAuctions: [AuctionItem] { get }
    var pastAuctions: [PastAuction] { get }
    
    func loadActiveAuctions()
    func loadPastAuctions()
    func savePastAuction(_ pastAuction: PastAuction)
}

class AuctionDataService: AuctionDataServiceProtocol {
    @Published var activeAuctions: [AuctionItem] = []
    @Published var pastAuctions: [PastAuction] = []
    
    private let userDefaults: UserDefaults
    private let bundle: Bundle
    private let pastAuctionsKey = "PastAuctions"
    
    init(userDefaults: UserDefaults = .standard, bundle: Bundle = .main) {
        self.userDefaults = userDefaults
        self.bundle = bundle
        loadPastAuctions()
        loadActiveAuctions()
    }
    
    func loadActiveAuctions() {
        guard let url = bundle.url(forResource: "auctions", withExtension: "json") else {
            print("Could not find auctions.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(AuctionDataResponse.self, from: data)
            
            activeAuctions = response.auctions.shuffled()
        } catch {
            print("Error loading auctions: \(error)")
        }
    }
    
    func loadPastAuctions() {
        guard let data = userDefaults.data(forKey: pastAuctionsKey) else { return }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            pastAuctions = try decoder.decode([PastAuction].self, from: data)
            pastAuctions.sort { $0.endDate > $1.endDate }
        } catch {
            print("Error loading past auctions: \(error)")
        }
    }
    
    func savePastAuction(_ pastAuction: PastAuction) {
        pastAuctions.append(pastAuction)
        pastAuctions.sort { $0.endDate > $1.endDate }
        savePastAuctions()
    }
    
    private func savePastAuctions() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(pastAuctions)
            userDefaults.set(data, forKey: pastAuctionsKey)
        } catch {
            print("Error saving past auctions: \(error)")
        }
    }
} 
