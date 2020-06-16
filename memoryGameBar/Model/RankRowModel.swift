//
//  RankModel.swift
//  memoryGameBar
//
//  Created by user166560 on 6/16/20.
//  Copyright © 2020 Gil Glick. All rights reserved.
//

import Foundation

class RankRowModel : Codable {
    
    var date:String = ""
    //var name:String = ""
    var timer:Int = 0
    //var location
    
    init(){}
    init(/*name:String,*/timer:Int/*,location:Location*/){
       let date = Date()
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .medium
        format.timeZone = .current
        self.date = format.string(from: date)
        //self.name = name
        //seld.location = location
        self.timer = timer
        
    }
    
    
}
