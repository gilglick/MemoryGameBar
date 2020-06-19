
import UIKit
import AVFoundation

class GameController: UIViewController {
    
    @IBOutlet weak var game_LBL_moveCounter: UILabel!
    @IBOutlet weak var game_LBL_timer: UILabel!
    @IBOutlet weak var game_STACKVIEW_cardsHolder: UIStackView!
    
    /*Final Vars*/
    let NUMBER_OF_ROWS : Int = 5
    let NUMBER_OF_COLS : Int = 4
    let SPACING: CGFloat = 10
    let DELAY : Double = 0.5
    
    /*Vars*/
    var deck = [Card]()
    var numberOfCards : Int!
    var firstCard : Card?
    var isClickable : Bool = true
    
    /*Vars for Timer&Moves*/
    var numberOfMoves : Int = 0
    var timer : Int = 0
    
    var rankRowModel:RankRowModel = RankRowModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        startGame()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)   
    }
    
    /*Card button control*/
    @IBAction func flip(_ sender: Card) {
        
        if(!isClickable || sender.isFlipped){
            
            return
        }
        
        deckControl(sender: sender)
        
    }
    
    /*Start gameBoard and initialize Timer and Moves*/
    func startGame(){
        
        initCards(numOfRows: NUMBER_OF_ROWS, numOfCardsPerRow: NUMBER_OF_COLS)
        startTimer()
    }
    
    /*Create new card */
    func createCard () -> Card {
        
        let newCard : Card = Card()
        newCard.addTarget(self, action: #selector(flip), for: .touchUpInside)
        
        return newCard
    }
    
    /*Create new row  */
    func createRow () -> UIStackView {
        
        let row = UIStackView()
        
        row.axis = .horizontal
        row.alignment = .fill
        row.distribution = .fillEqually
        row.spacing = SPACING
        row.contentMode = .scaleToFill
        row.translatesAutoresizingMaskIntoConstraints = false
        return row
    }
    
    /*Init cards, put front picture and shuffle matrix*/
    func initCards(numOfRows : Int, numOfCardsPerRow : Int){
        
        let images = [#imageLiteral(resourceName: "beer"),#imageLiteral(resourceName: "cocktail"),#imageLiteral(resourceName: "rum"),#imageLiteral(resourceName: "shaker"),#imageLiteral(resourceName: "champagne"),#imageLiteral(resourceName: "gin"),#imageLiteral(resourceName: "whisky"),#imageLiteral(resourceName: "vodka"),#imageLiteral(resourceName: "coconut"),#imageLiteral(resourceName: "beer-bottle")]
        var count:Int = 0
        numberOfCards = NUMBER_OF_ROWS * NUMBER_OF_COLS
        for _ in 0 ..< numOfRows {
            
            for _ in 0 ..< numOfCardsPerRow {
                
                let newCard : Card = createCard()
                deck.append(newCard)
                newCard.front = images[Int(count/2)]
                count+=1
            }
        }
        deck.shuffle()
        for i in 0 ..< numOfRows {
            
            let row : UIStackView = createRow()
            for j in 0 ..< numOfCardsPerRow {
                row.addArrangedSubview(deck[i*numOfCardsPerRow+j])
            }
            game_STACKVIEW_cardsHolder.addArrangedSubview(row)
        }
    }
    
    
    
    /*function for checking weither its the first or the second card*/
    func deckControl(sender : Card){
        
        sender.flip()
        if(firstCard == nil){
            firstCard = sender
        } else {
            isClickable = false
            checkForMatches(sender: sender)
        }
    }
    
    /*Increase 1 move and checks if 2 cards are matches*/
    func checkForMatches(sender : Card){
        
        increaseMove()
        if(sender.front != firstCard!.front){
            
            playerGuessedWrong(sender: sender)
        } else {
            playerGuessedRight(sender: sender)
        }
    }
    /*Handle the case the player found match*/
    func playerGuessedRight(sender : Card){
        
        firstCard!.remove()
        firstCard = nil
        sender.remove()
        //make sure its not the end of game
        if(isWon()){
            performSegue(withIdentifier: "afterGame", sender: self)
        }
        isClickable = true
    }
    
    /*Handle the case the player dont found match*/
    func playerGuessedWrong(sender : Card) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DELAY ) {
            
            self.firstCard!.flip()
            sender.flip()
            self.firstCard = nil
            self.isClickable = true
        }
    }
    
    /*Checks if all the cards are flipped */
    func isWon() -> Bool {
        
        for card in deck {
            
            if(!card.isFlipped)    {
                
                return false
            }
        }
        return true
        
    }
    
    /*Increasing moves counter by every move*/
    func increaseMove() {
        
        numberOfMoves += 1
        game_LBL_moveCounter.text  = String(numberOfMoves)
    }
    
    func startTimer() {
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            self.timer += 1
            self.game_LBL_timer.text  = String(self.timer)
        }
        
    }
    
    /*Starting new game */
    func newGame () {
        
        resetCards()
        resetMoves()
        resetTimer()
        deck.shuffle()
    }
    
    func resetCards() {
        
        for card in deck {
            card.flip()
            card.add()
            card.isFlipped = false
        }
    }
    
    func resetMoves() {
        numberOfMoves = 0
        game_LBL_moveCounter.text  = String(numberOfMoves)
        
    }
    
    func resetTimer() {
        timer = 0
        game_LBL_timer.text  = String(timer)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! HighScoreController
        vc.rankRowModel = self.rankRowModel
        vc.rankRowModel.timer = self.timer
    }
    
}
