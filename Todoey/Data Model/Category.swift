//
//  Category.swift
//  
//
//  Created by Jeremy Thompson on 2018-04-03.
//

import Foundation
import RealmSwift

class Category: Object {
    // dyanmic so can monitor changes to var during run time
    @objc dynamic var name : String = ""
    // save random chameleon bg color
    @objc dynamic var colour: String = ""
    // inside each category, thing called item pointed to list object
    let items = List<Item>()
    
}

