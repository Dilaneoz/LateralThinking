//
//  Favorites.swift
//  literalThinking
//
//  Created by Dilan Öztürk on 15.12.2024.
//

import UIKit

struct FavoriteItem: Codable {
    
    let section: Int
    let row: Int
    let detailsItem: DetailsItem
    let scenarioDetails: ScenariosItem
}

struct DetailsItem: Codable { // FavoritesCollectionViewController'daki datalar
    
    let imageName: String
    let title: String
    let titleColor: ColorWrapper // Renk özelliği
}

struct ScenariosItem: Codable { // FavoritesCollectionViewController'dan cell e tıklayında aktarılan ScenariosViewController'daki datalar
    
    let gameScenario: String
    let backImage: String
    let frontImage: String
}

//UIColor doğrudan Codable uyumlu değildir. Ancak, Codable uyumunu sağlamak için renkleri Data formatında saklayabiliriz. Bunun için aşağıdaki gibi bir Codable uzantısı kullanmak lazım. bunu yukarıaki "let titleColor: ColorWrapper" satırı için yapıyoruz
struct ColorWrapper: Codable {
    let color: UIColor

    enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }

    init(color: UIColor) {
        self.color = color
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(CGFloat.self, forKey: .red)
        let green = try container.decode(CGFloat.self, forKey: .green)
        let blue = try container.decode(CGFloat.self, forKey: .blue)
        let alpha = try container.decode(CGFloat.self, forKey: .alpha)
        self.color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(alpha, forKey: .alpha)
    }
}






