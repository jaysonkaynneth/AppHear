//
//  DictionaryModel.swift
//  AppHear
//
//  Created by Piter Wongso on 11/11/22.
//

import Foundation

struct Word: Codable, Hashable {
    var status: Bool
    var message: String
    var data: [WordData]
}

struct WordData: Codable, Hashable {
    var lema: String
    var arti: [WordMeaning]
}

struct WordMeaning: Codable, Hashable{
    var kelasKata, deskripsi: String

    enum CodingKeys: String, CodingKey {
        case kelasKata = "kelas_kata"
        case deskripsi
    }
}

