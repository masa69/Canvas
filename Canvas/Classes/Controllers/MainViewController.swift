
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var textBoardView: TextBoardView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textBoardView.didSelectBackground = { (label: TextEditorLabel?) in
            self.gotoTextEditor(label: label)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func gotoTextEditor(label: TextEditorLabel?) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TextEditor", bundle: nil)
        let vc: TextEditorViewController = storyboard.instantiateInitialViewController() as! TextEditorViewController
        vc.label = label
        vc.didFinish = { (text: String, fontSize: CGFloat) in
            if label == nil {
                if text != "" {
                    self.textBoardView.append(text: text, fontSize: fontSize)
                }
                return
            }
            label?.text = text
        }
        self.present(vc, animated: false, completion: nil)
    }
    
}
