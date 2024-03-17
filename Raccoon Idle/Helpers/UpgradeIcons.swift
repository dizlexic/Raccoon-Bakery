//
//  UpgradeIcons.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/7/23.
//

import SpriteKit

enum UpgradeIcons: String {
    case Manager, Bakery, Factory, DeliveryHub, Salesforce, ThinkTank, InternationalShipping, CookieUniversity, ConvoyOfCookies, CookieGrove

    enum ImgIndex: Int {
        case Building=0,Research,Cookie,CookieUp,Milk,Boost,Time,Coins
    }
    
    var colorPallete: ColorPallette {
        ManagerType(rawValue: self.rawValue)?.pallete ?? ColorPallette.Yellow
    }
    
    var colorName: String {
        colorPallete.name
    }
    
    var atlasName: String {
        "Upgrade \(colorName)"
    }
    
    var skAtlas: SKTextureAtlas {
        SKTextureAtlas(named: atlasName)
    }
    
    private var split: [[SKTexture]] {
        skAtlas.textureNames.map {
            skAtlas.textureNamed($0)
        }.sorted(by: {$0.description < $1.description}).chunked(into: 8)
    }
    
    private var ons: [SKTexture] {
        split.first ?? []
    }
    
    private var offs: [SKTexture] {
        split.last ?? []
    }
    
    func iconForImgIndex(_ imgIndex: Int) -> [SKTexture] {
        let idx = imgIndex
        return [ons[idx], offs[idx]]
    }
    
    func iconForImgIndex(_ imgIndex: ImgIndex) -> [SKTexture] {
        let idx = imgIndex.rawValue
        return [ons[idx], offs[idx]]
    }
}
