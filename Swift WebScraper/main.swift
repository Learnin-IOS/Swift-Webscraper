//
//  main.swift
//  Swift WebScraper
//
//  Created by Le Bon B' Bauma on 01/04/2022.
//

import Foundation
import SwiftSoup

let url = URL(string: "https://en.wikipedia.org/wiki/Aglaonema")!
let html = try String(contentsOf: url)
let document = try SwiftSoup.parse(html)

let description = try document.select("#Description").first()!

print(description)

