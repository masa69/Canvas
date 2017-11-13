
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var textBoardView: TextBoardView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textBoardView.didSelectBackground = {
            self.textBoardView.append(text: "sample\n text")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
