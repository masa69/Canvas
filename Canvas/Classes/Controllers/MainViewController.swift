
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var textBoardView: TextBoardView!
    
    @IBOutlet weak var deleteView: UIView!
    
    @IBOutlet weak var deleteViewBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteViewBottomConstraint.constant = deleteView.frame.height * -1
        self.initTextBoardView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func initTextBoardView() {
        textBoardView.touchStart = {
            print("start")
            self.animateDeleteView(constant: 12)
        }
        textBoardView.touchFinish = { (index: Int, location: CGPoint) in
            if self.needRemove(location: location) {
                print("remove")
                self.textBoardView.remove(index: index)
            }
            print("finish")
            self.animateDeleteView(constant: self.deleteView.frame.height * -1)
        }
        textBoardView.didSelect = { (label: TextEditorLabel?) in
            self.gotoTextEditor(label: label)
        }
    }
    
    
    private func animateDeleteView(constant: CGFloat) {
        let animate: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) {
            self.deleteViewBottomConstraint.constant = constant
            self.view.layoutIfNeeded()
        }
        animate.startAnimation()
    }
    
    
    private func needRemove(location: CGPoint) -> Bool {
        let minX: CGFloat = deleteView.frame.origin.x
        let maxX: CGFloat = deleteView.frame.origin.x + deleteView.frame.width
        let minY: CGFloat = deleteView.frame.origin.y
        let maxY: CGFloat = deleteView.frame.origin.y + deleteView.frame.height
        if minX <= location.x && location.x <= maxX {
            if minY <= location.y && location.y <= maxY {
                return true
            }
        }
        return false
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
            if let l: TextEditorLabel = label {
                self.textBoardView.update(index: l.index, text: text, fontSize: fontSize)
            }
        }
        self.present(vc, animated: false, completion: nil)
    }
    
}
