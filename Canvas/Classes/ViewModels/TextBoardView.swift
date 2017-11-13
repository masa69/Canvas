
import UIKit

class TextBoardView: UIView {
    
    private var texts: [TextEditorLabel] = [TextEditorLabel]()
    
    var indexCounter: Int = 0
    
    var selectedText: TextEditorLabel?
    
    var didSelectBackground: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.afterInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.afterInit()
    }
    
    
    private func afterInit() {
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
    }
    
    
    func append(text: String) {
        let label: TextEditorLabel = TextEditorLabel(index: self.indexCounter, parentView: self, text: text)
        label.touchStart = { (label: UILabel) in
            self.selectedText = label as? TextEditorLabel
            print("start")
        }
        label.touchFinish = {
            self.selectedText = nil
            print("finish")
        }
        self.texts.append(label)
        self.indexCounter += 1
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label: TextEditorLabel = self.selectedText {
            label.handleTouchesBegan(touches: touches)
            return
        }
        self.didSelectBackground?()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label: TextEditorLabel = self.selectedText {
            label.handleTouchesMoved(touches: touches)
            return
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label: TextEditorLabel = self.selectedText {
            label.handleTouchesEnded(touches: touches)
            return
        }
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label: TextEditorLabel = self.selectedText {
            label.handleTouchesCancelled(touches: touches)
            return
        }
    }
    
}
