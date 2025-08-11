//
//  NumberFormatter.swift
//  Bid
//

import Foundation

struct PriceFormatter {
    static let shared = PriceFormatter()
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private init() {}
    
    func formatPrice(_ amount: Int) -> String {
        let formattedNumber = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "AED \(formattedNumber)"
    }
    
    func formatAmount(_ amount: Int) -> String {
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    func formatPriceWithoutCurrency(_ amount: Int) -> String {
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
} 
