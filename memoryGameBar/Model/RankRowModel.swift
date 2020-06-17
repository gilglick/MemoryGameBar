
import Foundation

class RankRowModel : Codable {
    
    var date:String = ""
    //var name:String = ""
    var timer:Int = 0
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    init(){
        let date = Date()
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .medium
        format.timeZone = .current
        self.date = format.string(from: date)
    }
    
    init(timer:Int,latitude:Double,longitude:Double){
        let date = Date()
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .medium
        format.timeZone = .current
        self.date = format.string(from: date)
        //self.name = name
        self.timer = timer
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    
}
