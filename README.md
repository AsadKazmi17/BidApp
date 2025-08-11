# **Project Structure**

**Models**
```
Auction.swift              // Auction state model
AuctionItem.swift          // Auction item details
BidModel.swift             // Individual bid data
```

**Services**
```
AuctionDataService.swift      // Loads and saves auction data (local JSON & past auctions)
AuctionService.swift          // Simulated bidding service conforming to protocol
AuctionServiceProtocol.swift  // Defines fetchBids() for easy service replacement
```

**ViewModels**
```
AuctionViewModel.swift     // Core auction logic, timer, bid handling, and simulated bidding
```

**Views**
```
HomeView.swift             // Displays live & past auctions
AuctionView.swift          // The live auction screen
```

**Resources**
```
auction.json               // Dummy JSON file for auctions
Strings.swift              // Constants and app text
PriceFormatter.swift       // Currency formatting helper
```

---

## Architecture & Design Decisions

1. **MVVM Architecture**  
   ViewModels manage all business logic and state, keeping Views declarative.

2. **Dependency Injection**  
   `AuctionViewModel` receives an `AuctionServiceProtocol` so we can easily replace the simulated bidding service with a real one.

3. **Protocol-Oriented Design**  
   `AuctionServiceProtocol` defines bidding fetch logic, decoupling the implementation from the `ViewModel`.

4. **Publisher-based Timers**  
   Uses Combine's `Timer.publish` for countdown and simulated bidding intervals.

5. **Single Source of Truth**  
   Auction state (`Auction`) lives entirely in the `ViewModel` and updates Views reactively via `@Published`.

---

## **How It Works**

**1. Select Auction**
- The user will see **Active** and **Past Auctions** tabs.
- In the **Active Auctions** tab, random auctions are displayed.
- In the **Past Auctions** tab, auctions are listed with the latest ones at the top.
- Tapping on an active auction opens its detail page.

**2. Start Auction**
- The user enters their name.
- The auction timer starts.
- Simulated bidding begins automatically.

**3. Place Bids**
- The user enters a bid amount.
- The bid must be higher than the current highest bid.
- If valid, the user becomes the current winner.
- **Quick Bid Buttons:** Four quick bid buttons allow instantly increasing the bid by a preset AED amount for faster bidding.

**4. Simulated Bids**
- A background timer generates random bids from simulated users.
- This can be replaced with real-time network updates.

**5. Auction End**
- When the timer reaches zero, the last highest bidder is declared the winner.
- The auction is saved in **UserDefaults** as a Past Auction.

---

## **How to Run this**

1. Clone the repository using [`git@github.com:AsadKazmi17/Bid.git`](https://github.com/AsadKazmi17/Bid.git)  
2. Open the project in Xcode.  
3. Select any iPhone simulator.  
4. Run the app. No third-party SDKs are used, so there’s nothing else to install.
