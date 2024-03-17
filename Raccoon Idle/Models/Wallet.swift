//
//  Wallet.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/20/23.
//

import Foundation

class Wallet {
    private var _wallet: Set<Currency>
    
    var held: (CurrencyType?) -> Currency? {
        { [weak self] type in
            self?._wallet.first {
                $0.type == type
            }
        }
    }
    
    private func getHeld(like currency: Currency) -> Currency? {
        getHeld(for: currency.type)
    }
    
    private func getHeld(for type: CurrencyType) -> Currency? {
        held(type)
    }
    
    init(currencies: [Currency]?) {
        guard let currencies = currencies else {
            _wallet = []
            return
        }
        
        _wallet = Set<Currency>(currencies)
    }
    
    func getHeldAmount(for type: CurrencyType) -> Decimal {
        held(type)?.amount ?? .zero
    }
    
    func getSaveString(for type: CurrencyType) -> String {
        held(type)?.displayValue ?? Currency(type: type).displayValue
    }
    
    func setHeld(to currency: Currency) {
        guard let held = held(currency.type) else {
            _wallet.insert(currency)
            return
        }
        held.amount = currency.amount
        held.type = currency.type
    }
}

extension Wallet {
    public static func <= (lhs: Wallet, rhs: Currency) -> Bool {
        guard let held = lhs.getHeld(like: rhs) else { return true }
        return held <= rhs
    }
    
    public static func >= (lhs: Wallet, rhs: Currency) -> Bool {
        guard let held = lhs.getHeld(like: rhs) else { return true }
        return held >= rhs
    }
}

// Wallet to Currency operators
extension Wallet {
    public static func += (lhs: Wallet, rhs: Currency) {
        guard let held = lhs.getHeld(like: rhs) else { return }
        held += rhs
    }
    
    public static func -= (lhs: Wallet, rhs: Currency) {
        let wallet = lhs
        let currency = rhs
        guard let held = wallet.getHeld(like: currency) else { return }
        held -= currency
    }
}

extension Wallet {
    public static func += (lhs: Wallet, rhs: Decimal) {
        guard let held = lhs.getHeld(for: .Cookies) else { return }
        held += rhs
    }
}
