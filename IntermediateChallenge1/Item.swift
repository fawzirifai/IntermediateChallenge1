//
//  Item.swift
//  IntermediateChallenge1
//
//  Created by Fawzi Rifai on 07/08/2022.
//

import Foundation

struct Item {
    var identifier = UUID()
    let title: String
    let date: Date?
    var formattedDate: String? {
        date?.formatted()
    }
}
