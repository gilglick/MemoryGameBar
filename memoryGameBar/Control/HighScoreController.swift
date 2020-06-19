
import UIKit
import MapKit
import Foundation

class HighScoreController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var HighScore_MAP_map: MKMapView!
    @IBOutlet weak var HighScore_TV_Ranks: UITableView!
    
    var converter:Converter = Converter()
    var rows = [RankRowModel]()
    var rankRowModel:RankRowModel = RankRowModel()
    var dirty:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        HighScore_TV_Ranks.delegate = self
        HighScore_TV_Ranks.dataSource = self
        if rankRowModel.timer != 0 {
            updateTableView(newRankRowModel: self.rankRowModel)
        }
        else {
            rows = readFromLocalStorage()
        }
        setMarkerOnMap(rowsList: self.rows)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func writeToLocalStorage(rowsList: [RankRowModel]){
        let defaults = UserDefaults.standard
        defaults.set(converter.rowsListToJson(rowsList: rowsList), forKey: "storage")
    }
    
    func readFromLocalStorage() -> [RankRowModel]{
        let defaults = UserDefaults.standard
        if let newList: [RankRowModel] = converter.jsonTorowsList(jsonRowsList: defaults.string(forKey: "storage") ?? ""){
            return newList
        }
        return [RankRowModel]()
    }
    func clearStorage(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
    }
    
    func updateTableView(newRankRowModel: RankRowModel){
        var rowsListFromStorage = readFromLocalStorage()
        if rowsListFromStorage.count < 10 {
            dirty = true
            rowsListFromStorage.append(newRankRowModel)
            writeToLocalStorage(rowsList: rowsListFromStorage.sorted(by: {$0.timer < $1.timer}))
        }else if(rowsListFromStorage.last!.timer > newRankRowModel.timer){
            dirty = true
            rowsListFromStorage.remove(at: rowsListFromStorage.count - 1)
            rowsListFromStorage.append(newRankRowModel)
            writeToLocalStorage(rowsList: rowsListFromStorage.sorted(by: {$0.timer < $1.timer}))
        }
        self.rows = readFromLocalStorage()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.HighScore_TV_Ranks.dequeueReusableCell(withIdentifier: "RankRowViewCell", for: indexPath) as? RankRowViewCell
        cell?.HighScore_LBL_Timer.text = String(rows[indexPath.row].timer)
        cell?.HighScore_LBL_Date.text = rows[indexPath.row].date
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        zoomIn(rankRowModel: rows[indexPath.row])
    }
    
    func setMarkerOnMap(rowsList: [RankRowModel]){
        if(!rowsList.isEmpty){
            for row in rowsList {
                let annontation = MKPointAnnotation()
                annontation.title = row.date
                annontation.coordinate = CLLocationCoordinate2D(latitude: row.latitude , longitude: row.longitude )
                HighScore_MAP_map.addAnnotation(annontation)
            }
            if dirty == true {
                zoomIn(rankRowModel: rankRowModel)
            }
            else {
                zoomIn(rankRowModel: rowsList.first!)
            }
        }
    }
    
    func zoomIn(rankRowModel: RankRowModel){
        let zoomIn = CLLocationCoordinate2D(latitude: rankRowModel.latitude , longitude:rankRowModel.longitude  )
        let region = MKCoordinateRegion(center: zoomIn, latitudinalMeters: 800, longitudinalMeters: 800)
        HighScore_MAP_map.setRegion(region, animated: true)    }
}
