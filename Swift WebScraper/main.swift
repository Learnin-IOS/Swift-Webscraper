//
//  main.swift
//  Swift WebScraper
//
//  Created by Le Bon B' Bauma on 01/04/2022.
//

import Foundation
import SwiftSoup


struct HouseplantInfo : Codable {
    var description: String
}

// The key is a houseplant name
typealias HouseplantInfoDictionary = [String: HouseplantInfo]

// The Key is a category name
typealias HouseplantCategoryDictionary = [String: HouseplantInfoDictionary]

func scrapeHouseplant(url: URL) throws {
    
    let html = try String(contentsOf: url)
    let document = try SwiftSoup.parse(html)
    
    let span = try document.select("#Description").first()
        ?? document.select("#Decription_and_biology").first()
        ?? document.select("#Name_and_description").first()
        ?? document.select("#Plant_care").first()
    
    if span != nil {
        let h2 = span!.parent()!
        element = try h2.nextElementSibling()
    }   else {
        // Start collecting text from the beginning og the web page.
        let div = try document.select(".mw-parser-output")
        element = div.first()?.children()[3]
    }
    
    
    var description = ""
    while element != nil {
        // Stop at the next "h" tag. (h2, h3,etc)
        if element!.tagName().starts(with:"h"){
            break
        }
        description += try element!.text()
        element = try element!.nextElementSibling()

    }
        return HouseplantInfo(description: description)
}
 
// Remove [...] or (...) text from a string.

func clean(name: String) -> String  {
    name.replacingOccurrences(of: #"(\s*\[.*]|\s*\(.*\)) "#, with: "", options: .regularExpression)
    
}

func scrapeHouseplantts(url: URL)throws -> HouseplantCategoryDictionary{

    let html = try String(contentsOf: url)
    let document = try SwiftSoup.parse(html)
    
    
    let span = try document.select("#List_of_common_houseplants").first()!
    let h2 = span.parent()
    var element = h2
    
    var categories = HouseplantCategoryDictionary()
    var categoryName: String = ""
    
}
    
    
    while true
    {
        guard let sibling = try element.nextElementSibling() else { break }
//        print(sibling.tagName())
        switch sibling.tagName(){
        case "h2":
            // We know the first h2 comes after the end of categories.
            return categories
        case "h3":
            // If there's an existing category name, add it to the Dictionary
            categoryName = clean(name:  try child.text())
            categories[categoryName] = HouseplantInfoDictionary()
//            print(try sibling.children().first()!.text())
        case "ul":
            for child in sibling.children() {
                print(" ", try child.text())
                let a = try child.getElementsByTag("a").first()!
                let href = try a.attr("href")
                let infoURL = URL(string: "href", relativeTo: url)!
                categories[categoryName]![plantName] = (try scrapeHouseplant(url: infoURL))
//                print(try scrapeHouseplant(url: speciesURL))
            }
        default:
            break
        }
        element = sibling
    }
    return categories
}

let url = URL(string: "https://en.wikipedia.org/wiki/Houseplant")!
//print(try scrapeHouseplant(url: url))
let houseplants = try scrapeHouseplant(url: url)

let encoder =  JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let json = try encoder.encode(houseplants)
let jsonString = String(decoding: json, as: UTF8.self)
print(jsonString)

