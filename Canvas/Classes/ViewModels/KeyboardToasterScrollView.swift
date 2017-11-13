
import UIKit

class KeyboardToasterScrollView: UIScrollView {
    
    var activeTextField: UITextField?
    
    var adjustmentHeaderHeight: CGFloat = 0
    var adjustmentOffsetY: CGFloat = 0
    
    
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
        self.layoutIfNeeded()
    }
    
    
    func prepareObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.willShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.willHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    private func resize(y: CGFloat, duration: TimeInterval) {
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(duration)
        
        let offsetY: CGFloat = y + self.adjustmentOffsetY
        
        let contentInsets = UIEdgeInsetsMake(0, 0, offsetY, 0)
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
        self.contentOffset.y = offsetY
        
        UIView.commitAnimations()
    }
    
    
    private func refresh() {
        self.contentInset = UIEdgeInsets.zero
        self.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    
    // MARK: - NotificationCenter
    
    @objc func willShow(_ sender: Notification) {
        
        if self.activeTextField == nil {
            return
        }
        
        if let userInfo = sender.userInfo {
            
            let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let animationDuration: Double = ((userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue)!
            
            self.refresh()
            
            let myBoundSize: CGSize = UIScreen.main.bounds.size
            let keyboardMinY = myBoundSize.height - keyboardFrame.size.height
            
            if let textField: UITextField = self.activeTextField {
                
                let absoluteActiveTextFieldRect: CGRect = textField.convert(textField.bounds, to: self)
                let textFieldMaxY: CGFloat = absoluteActiveTextFieldRect.maxY + textField.frame.height + self.adjustmentHeaderHeight
                
//                print(textFieldMaxY, keyboardMinY)
                
                if textFieldMaxY >= keyboardMinY {
                    let offsetY: CGFloat = textFieldMaxY - keyboardMinY
                    self.resize(y: offsetY, duration: animationDuration)
                }
                return
            }
        }
    }
    
    
    @objc func willHide(_ sender: Notification) {
        self.refresh()
    }
    
}
