import Foundation

class Converter {
    
    func playerListToJson(rowsList: [RankRowModel]) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(rowsList)
        let jsonString: String = String(data: data, encoding: .utf8)!
        return jsonString
    }
    
    func jsonToPlayerList(jsonPlayerList: String) -> [RankRowModel]? {
        let decoder = JSONDecoder()
        if jsonPlayerList == "" {
            return [RankRowModel]()
        }else{
            let data: [RankRowModel]
            let convertedData: Data = jsonPlayerList.data(using: .utf8)!
            data = try! decoder.decode([RankRowModel].self,from: convertedData)
            return data
        }
    }
    func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        return formatter.string(from: date)
        
    }
}
