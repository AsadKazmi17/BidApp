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
DependencyContainer.swift     // Centralizes app dependencies (services) and injects them into views
ViewModelFactory.swift        // Creates ViewModels with injected dependencies
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
Data/auctions.json               // Dummy JSON file for auctions
Utils/Strings.swift              // Constants and app text
Utils/NumberFormatter.swift       // Currency formatting helper
```

---

## Architecture & Design Decisions

1. **MVVM + Dependency Injection**
   - The app uses **MVVM** for a clean separation of concerns:
     - **ViewModels** manage business logic and state.
     - **Views** remain declarative and reactive.
   - **DependencyContainer** is injected into views, supplying all services through protocols for easy replacement.

2. **Protocol-Oriented Design**
   - Core services (e.g., `AuctionServiceProtocol`, `AuctionDataServiceProtocol`) define the required functionality without locking into a specific implementation.
   - This allows swapping the simulated bidding service with a real backend without changing ViewModels.

3. **Publisher-Based Timers**
   - Uses **Combine's** `Timer.publish` to:
     - Countdown auction time.
     - Trigger simulated bids at intervals.

4. **Single Source of Truth**
   - The `AuctionViewModel` holds the single source of truth for an auction's state (`Auction` model).
   - All updates are published via `@Published` properties so views stay in sync.

5. **Simulated Bidding System**
   - `AuctionService` generates random bids from a list of simulated users.
   - Bid increments are randomized between min/max thresholds.
   - Designed so this simulation can be replaced by real-time network updates.

6. **Data Persistence**
   - `AuctionDataService` loads active auctions from a bundled JSON file.
   - Past auctions are persisted in **UserDefaults**.
   - Auctions are sorted so the latest appear at the top of the **Past Auctions** tab.

7. Navigation & ViewModel Creation
   - `ViewModelFactory` handles creation of ViewModels with the correct dependencies.
   - `HomeView` passes the factory into child views like `AuctionView` via environment values.
   - `AuctionView` creates its ViewModel with the provided factory, ensuring dependencies are consistent across the app.

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

1. Clone the repository using [`git@github.com:AsadKazmi17/BidApp.git`](https://github.com/AsadKazmi17/BidApp.git)  
2. Open the project in Xcode.  
3. Select any iPhone simulator.  
4. Run the app. No third-party SDKs are used, so there’s nothing else to install.
