//
//  SubscriptionManager.swift
//  MCast
//
//  Created by Parthiv Akbari on 05/11/25.
//

import Foundation
import StoreKit
import Combine
import StoreKit

@MainActor
class SubscriptionManager: ObservableObject {
    @Published var isActive: Bool = false
    @Published var activeProductID: String?
    @Published var expirationDate: Date?

    static let shared = SubscriptionManager()
    private init() {}

    func checkSubscriptionStatus() async {
        do {
            // Get the current signed-in user's transactions
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    // Check if the transaction is one of your premium subscriptions
                    if Products.allCases.map({ $0.rawValue }).contains(transaction.productID) {
                        self.isActive = true
                        self.activeProductID = transaction.productID
                        self.expirationDate = transaction.expirationDate
                        
                        print("✅ Active subscription: \(transaction.productID)")
                        print("⏳ Expires on: \(transaction.expirationDate?.description ?? "N/A")")
                        
                        setIsUserSubscribe(isSubscribe: true)
                        UserDefaults.standard.synchronize()
                        return
                    }
                }
            }

            // If nothing found, it’s inactive
            print("❌ No active subscription found")
            self.isActive = false
            setIsUserSubscribe(isSubscribe: false)
            UserDefaults.standard.synchronize()

        } catch {
            print("❌ Failed to check subscription: \(error.localizedDescription)")
            self.isActive = false
            setIsUserSubscribe(isSubscribe: false)
            UserDefaults.standard.synchronize()
        }
    }
}
