
import UIKit

class TextEditorLabel: UILabel {
    
    private var parentView: UIView?
    
    private let insets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    
    private var paddingV: CGFloat {
        get {
            return insets.top + insets.bottom
        }
    }
    
    private var paddingH: CGFloat {
        get {
            return insets.left + insets.right
        }
    }
    
    var isMoving: Bool = false
    
    private var isOneFinger: Bool = false
    private var isTwoFinger: Bool = false
    
    private var locations: [CGPoint] = [CGPoint]()
    
    private var originX: CGFloat = 0
    private var originY: CGFloat = 0
    
    var index: Int = 0

    var touchStart: ((_ label: UILabel) -> Void)?
    
    var touchFinish: (() -> Void)?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init(index: Int, parentView: UIView, text: String, fontSize: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.height))
        
        self.index = index
        self.parentView = parentView
        self.numberOfLines = 0
        // タップを感知させる
        self.isUserInteractionEnabled = true
        // 複数の指でのタップを感知させる
        self.isMultipleTouchEnabled = true
        
        self.text = text
        self.font = UIFont.systemFont(ofSize: self.fontSize)
//        print(self.font.pointSize)
        self.backgroundColor = UIColor.lightGray
        // label のサイズを テキスト + 余白 に合わせる
        super.sizeToFit()
        let width: CGFloat = self.frame.width + self.paddingV
        let height: CGFloat = self.frame.height + self.paddingH
        let x: CGFloat = (parentView.frame.width - width) / 2 - (self.paddingV / 2)
        let y: CGFloat = (parentView.frame.height - height) / 2 - (self.paddingH / 2)
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        self.parentView?.addSubview(self)
    }
    
    
    // label の周りに余白を追加
    override func drawText(in rect: CGRect) {
        let newRect: CGRect = UIEdgeInsetsInsetRect(rect, self.insets)
        super.drawText(in: newRect)
    }
    
    
    func nearLocationIndex(location: CGPoint) -> Int? {
        if self.locations.count == 1 {
            return 0
        }
        var diff: CGFloat = 0
        for (i, lo) in self.locations.enumerated() {
            var diffX: CGFloat = location.x - lo.x
            var diffY: CGFloat = location.y - lo.y
            diffX = (diffX < 0) ? diffX * -1 : diffX
            diffY = (diffY < 0) ? diffY * -1 : diffY
            if i == 0 {
                diff = diffX + diffY
                continue
            }
            return (diff < diffX + diffY) ? 0 : 1
        }
        return nil
    }
    
    
    func handleTouchesBegan(touches: Set<UITouch>) {
        guard let touche: UITouch = touches.first else {
            return
        }
        if self.isTwoFinger {
            self.isMoving = false
            return
        }
        if self.isOneFinger {
            print("Two Finger")
            self.isMoving = false
            self.isTwoFinger = true
        } else {
            print("One Finger")
            self.isOneFinger = true
            self.touchStart?(self)
        }
        
        self.locations.append(touche.location(in: self.parentView))
        
        self.originX = self.frame.origin.x
        self.originY = self.frame.origin.y
        
        print("origin: x: \(self.originX) y: \(self.originY)")
    }
    
    
    func handleTouchesMoved(touches: Set<UITouch>) {
        guard let touche: UITouch = touches.first else {
            return
        }
        let location: CGPoint = touche.location(in: self.parentView)
        guard let index: Int = self.nearLocationIndex(location: location) else {
            return
        }
        self.isMoving = true
        if self.isTwoFinger {
            self.locations[index].x = location.x
            self.locations[index].y = location.y
            print("touches.count: \(touches.count)")
            return
        }
        if self.isOneFinger {
            self.frame.origin.x = self.originX + location.x - self.locations[index].x
            self.frame.origin.y = self.originY + location.y - self.locations[index].y
            self.locations[index].x = location.x
            self.locations[index].y = location.y
            self.originX = self.frame.origin.x
            self.originY = self.frame.origin.y
            return
        }
    }
    
    
    func handleTouchesEnded(touches: Set<UITouch>) {
        guard let touche: UITouch = touches.first else {
            return
        }
        let location: CGPoint = touche.location(in: self.parentView)
        guard let index: Int = self.nearLocationIndex(location: location) else {
            return
        }
        self.frame.origin.x = self.originX + location.x - self.locations[index].x
        self.frame.origin.y = self.originY + location.y - self.locations[index].y
        self.locations[index].x = location.x
        self.locations[index].y = location.y
        self.originX = self.frame.origin.x
        self.originY = self.frame.origin.y
        self.locations.remove(at: index)
        if self.isTwoFinger {
            self.isTwoFinger = false
            print("touchesEnded two: \(self.locations.count)")
            return
        }
        if self.isOneFinger {
            self.isMoving = false
            self.isOneFinger = false
            self.touchFinish?()
            return
        }
    }
    
    
    func handleTouchesCancelled(touches: Set<UITouch>) {
        print("touchesCancelled")
    }
    
    
    // MARK: - Touch Event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouchesBegan(touches: touches)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouchesMoved(touches: touches)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouchesEnded(touches: touches)
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouchesCancelled(touches: touches)
    }
    
}
