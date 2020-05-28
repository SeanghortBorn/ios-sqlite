//
//  Person.swift
//  SQLite
//
//  Created by Pov Song on 5/27/20.
//  Copyright © 2020 Pov Song. All rights reserved.
//

import UIKit
import Foundation
class Person {
    var name:String = ""
    var id:Int = 0
    
    init(id:Int, name:String) {
        self.id = id
        self.name = name
    }
}
