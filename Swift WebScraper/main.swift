//
//  main.swift
//  Swift WebScraper
//
//  Created by Le Bon B' Bauma on 01/04/2022.
//

import Foundation
import SwiftSoup

func scrapeHouseplant(url: URL) throws {
    
    let html = try String(contentsOf: url)
    let document = try SwiftSoup.parse(html)
    
    let span = try document.select("#List_of_common_houseplants").first()!
    let h2 = span.parent()!
    var element = h2
    
    
    while true
    {
        guard let sibling = try element.nextElementSibling() else { break }
//        print(sibling.tagName())
        switch sibling.tagName(){
        case "h2":
            return
        case "h3":
            print(try sibling.children().first()!.text())
        case "ul":
            for child in sibling.children() {
                print(" ", try child.text())
                let a = try child.getElementsByTag("a").first()!
                let href = try a.attr("href")
                let speciesURL = URL(string: "href", relativeTo: url)!
                print(try scrapeHouseplant(url: speciesURL))
            }
        default:
            break
        }
        element = sibling
    }
}

let url = URL(string: "https://en.wikipedia.org/wiki/Houseplant")!
print(try scrapeHouseplant(url: url))

