//
//  main.swift
//  Swift WebScraper
//
//  Created by Le Bon B' Bauma on 01/04/2022.
//

import Foundation
import SwiftSoup

func scrapeHousePlantSpecies(url: URL) throws -> String {
    
    let html = try String(contentsOf: url)
    let document = try SwiftSoup.parse(html)

    let descriptionSpan = try document.select("#Description").first()!

    let h2 = descriptionSpan.parent()!
    var element = h2

    var result = ""
    while true
                {
        guard let sibling = try element.nextElementSibling() else { break }
        if sibling.tagName() != "p" {
            break
        }
        result += try sibling.text()
        element = sibling
    }
    return result
}

let url = URL(string: "https://en.wikipedia.org/wiki/Aglaonema")!
print(try scrapeHousePlantSpecies(url: url))
