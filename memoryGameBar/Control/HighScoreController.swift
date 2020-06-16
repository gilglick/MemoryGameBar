
import UIKit
import Foundation
class HighScoreController : UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    @IBOutlet weak var HighScore_TV_Ranks: UITableView!
    var rows = [RankRowModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.HighScore_TV_Ranks.dequeueReusableCell(withIdentifier: "RankRowViewCell", for: indexPath) as? RankRowViewCell
        
        cell?.HighScore_LBL_Timer.text = finalName
        
        
        
        return cell!
       }
       
}

