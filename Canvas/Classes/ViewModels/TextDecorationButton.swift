
import UIKit

class TextDecorationButton: UIButton {
    
    var style: Canvas.TextDecoration? {
        didSet {
            self.update()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.afterInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.afterInit()
    }
    
    
    private func afterInit() {
        self.tintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    private func update() {
        guard let style: Canvas.TextDecoration = self.style else {
            return
        }
        switch style {
        case .none:
            self.tintColor = UIColor.black
            self.backgroundColor = UIColor.clear
            self.layer.borderColor = UIColor.black.cgColor
        case .clearBorder:
            self.tintColor = UIColor.white
            self.backgroundColor = UIColor.black
            self.layer.borderColor = UIColor.black.cgColor
        }
    }
    
}
