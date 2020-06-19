import UIKit
import Foundation
import CoreLocation

class MainController: UIViewController {
    
    @IBOutlet weak var Main_BTN_highScroe: UIButton!
    @IBOutlet weak var Main_BTN_play: UIButton!
    
    var rankRowModel:RankRowModel = RankRowModel()
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "play" {
            let vc = segue.destination as! GameController
            vc.rankRowModel = self.rankRowModel
        }
    }
    
}

extension MainController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            rankRowModel.latitude = location.coordinate.latitude
            rankRowModel.longitude = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
}
