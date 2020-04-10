//
//  String+AddText.swift
//  MyLocations
//
//  Created by Catalina on 4/2/20.
//  Copyright © 2020 Deep Minds. All rights reserved.
//

import Foundation

extension String {
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
