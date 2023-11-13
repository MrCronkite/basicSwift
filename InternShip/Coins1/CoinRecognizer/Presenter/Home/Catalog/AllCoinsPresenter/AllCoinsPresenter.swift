

import UIKit
import GoogleMobileAds
import Moya

protocol AllCoinsViewProtocol: AnyObject {
    func reloadDataForSettings()
    func setupBanner(ad: GADBannerView)
    func noMatchLable(isShow: Bool)
}

protocol AllCoinsPresenter: AnyObject {
    var category: Int { get set }
    var filter: Filter? { get set }
    var coins: [ResultAllCoins] { get set }
    var filteredItems: [ResultAllCoins] { get set }
    
    init(view: AllCoinsViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService, storage: UserSettings, provider: MoyaProvider<CoinsService>)
    
    func loadAllCoins()
    func tapOnTheFilter()
    func goToBack()
    func loadBanner()
    func goToCard(index: Int)
    func filterForSearchText(_ searchText: String?)
    func filteredCoins()
}

final class AllCoinsPresenterImpl: AllCoinsPresenter {
    weak var view: AllCoinsViewProtocol?
    var router: RouterProtocol?
    var filter: Filter?
    var googleAd: GoogleAdMobService?
    var storage: UserSettings?
    var provider: MoyaProvider<CoinsService>?
    var coins: [ResultAllCoins] = []
    var filteredItems: [ResultAllCoins] = []
    var category: Int = 0
    
    init(view: AllCoinsViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService, storage: UserSettings, provider: MoyaProvider<CoinsService>) {
        self.view = view
        self.router = router
        self.googleAd = googleAd
        self.storage = storage
        self.provider = provider
    }
    
    func loadAllCoins() {
        Activity.showActivity(view: view as! AllCoinsViewController)
        provider?.request(.getAllCoins(limit: 220, offset: 0)) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Activity.hideActivity()
            }
            switch result {
            case let .success(response):
                do {
                    let coin = try response.map(AllCoins.self)
                    self.coins = coin.results
                    self.filteredItems = self.coins
                    self.view?.reloadDataForSettings()
                } catch {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        }
    }
    
    func goToCard(index: Int) {
        Activity.showActivity(view: view as! AllCoinsViewController)
        provider?.request(.getCoinForId(id: "\(filteredItems[index].id)"), completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Activity.hideActivity()
            }
            switch result {
            case let .success(response):
                do {
                    let coins = try response.map(ReferenceCoins.self)
                    let result = ResultsCoins(id: coins.id,
                                              name: coins.name,
                                              reference: coins,
                                              chance: 0)
                    self.router?.goToCardCoin(tab: .camera, coins: [result], images: nil, category: self.category)
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
    
    func filteredCoins() {
        if let ascending = self.filter?.costIsLowToHight {
            self.coins = sortPrices(self.coins, ascending: ascending)
        }
        
        if let dates = self.filter?.data {
            let coinsDate = replacePresentWithCurrentYear(in: self.coins)
            self.filteredItems = filterDates(coinsDate, withinRange: dates)
        }
        
        if self.filter == nil {
            loadAllCoins()
        }
        
        view?.noMatchLable(isShow: !self.filteredItems.isEmpty)
        view?.reloadDataForSettings()
    }
    
    func filterForSearchText(_ searchText: String?) {
        if let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
            let searchWords = searchText.components(separatedBy: " ")
            
            filteredItems = self.coins.filter { item in
                let lowercasedName = item.name.lowercased()
                return searchWords.allSatisfy { searchWord in
                    return lowercasedName.contains(searchWord.lowercased())
                }
            }
        } else {
            filteredItems = self.coins
        }
        
        if filteredItems.isEmpty {
            view?.noMatchLable(isShow: false)
        } else {
            view?.noMatchLable(isShow: true)
        }
        
        view?.reloadDataForSettings()
    }
    
    func loadBanner() {
        let isPremium = (storage?.premium(forKey: .keyPremium))!
        if !isPremium {
            guard let googleAd = googleAd else { return }
            view?.setupBanner(ad: googleAd.loadBaner())
        }
    }
    
   private func sortPrices(_ prices: [ResultAllCoins], ascending: Bool) -> [ResultAllCoins] {
        let sortedPrices = prices.sorted { (price1, price2) -> Bool in
            let value1 = extractNumericValue(from: price1.priceTo)
            let value2 = extractNumericValue(from: price2.priceTo)
            return ascending ? (value1 < value2) : (value1 > value2)
        }
        return sortedPrices
    }
    
    func filterDates(_ dates: [ResultAllCoins], withinRange range: [String]) -> [ResultAllCoins] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let startYearRange = Int(range[0]) ?? 0
        let endYearRange = Int(range[1]) ?? Int.max

        let filteredDates = dates.filter { dateRange in
            let components = dateRange.dateRange.components(separatedBy: " - ")
            
            if components.count != 2 {
                return false 
            }

            if let startYear = Int(components[0]) {
                return startYear >= startYearRange && startYear <= endYearRange
            } else {
                return false
            }
        }

        return filteredDates
    }
    
    func tapOnTheFilter() {
        router?.goToFilter(filter: filter)
    }
    
    func goToBack() {
        router?.popToView(isAnimate: true)
    }
    
    
    private func extractNumericValue(from price: String) -> Double {
        let numericCharacters = price.filter { "0123456789,.".contains($0) }
        
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        
        var numericString = numericCharacters.replacingOccurrences(of: decimalSeparator, with: ".")
        
        numericString = numericCharacters.replacingOccurrences(of: ",", with: "").appending("00")
        
        if let value = Double(numericString) {
            return value
        }
        
        return 0.0
    }
    
    func replacePresentWithCurrentYear(in dates: [ResultAllCoins]) -> [ResultAllCoins] {
        let currentYear = Calendar.current.component(.year, from: Date())
        var updatedDates = dates

        for (index, var date) in updatedDates.enumerated() {
            date.dateRange = date.dateRange.replacingOccurrences(of: "present", with: "\(currentYear)")
            date.dateRange = date.dateRange.replacingOccurrences(of: "Present", with: "\(currentYear)")
            updatedDates[index] = date
        }

        return updatedDates
    }
}

extension Date {
    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
}
