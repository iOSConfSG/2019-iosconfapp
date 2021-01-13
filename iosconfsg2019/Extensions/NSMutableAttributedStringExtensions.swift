//
//  NSMutableAttributedStringExtensions.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 13/1/21.
//  Copyright © 2021 Vina Melody. All rights reserved.
//

import UIKit

extension String {
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex

        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }

        return indices
    }
}

extension NSMutableAttributedString {
    
    func colorSubstrings(substrings: [String], color: UIColor) {
        for substring in substrings {
            let indexes: [Int] = self.string.indicesOf(string: substring)
            for index in indexes {
                let range = NSRange(location:index, length: substring.count)
                self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            }
        }
    }
}
