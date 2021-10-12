//
//  Page.swift
//  SwiftUI_MVVM
//
//  Created by Sam Kerridge on 12/10/21.
//

import Foundation

struct PageDTO<T: Codable>: Codable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [T]
}
