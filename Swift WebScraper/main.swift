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
    
//    var description = ""
//    while element != nil {
//        // Stop at the next "h" tag. (h2, h3,etc)
//        if element!.tagName().starts(with:"h"){
//            break
//        }
//        description += try element!.text()
//        element = try element!.nextElementSibling()
//        
//    }
//        return description
//}
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

