//
//  Item.swift
//  Todoey
//
//  Created by Jeremy Thompson on 2018-03-18.
//  Copyright © 2018 Jeremy Thompson. All rights reserved.
//

import Foundation

// Encodable allows you to write to new custom plist file
class Item: Encodable, Decodable {
    
    var title: String = ""
    var done: Bool = false
    
}
