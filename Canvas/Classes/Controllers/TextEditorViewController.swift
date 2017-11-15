
import UIKit

class TextEditorViewController: UIViewController {
    
    @IBOutlet weak var keyboardToasterView: KeyboardToasterView!
    
    @IBOutlet weak var keyboardToasterViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var fontSizeSlider: UISlider!
    
    @IBOutlet weak var alignChangerButton: AlignChangerButton!
    
    
    var label: TextEditorLabel?
    
    var align: Canvas.Align = .center {
        didSet {
            alignChangerButton.align = self.align
            
            switch self.align {
            case .left:
                bodyTextView.textAlignment = .left
            case .center:
                bodyTextView.textAlignment = .center
            case .right:
                bodyTextView.textAlignment = .right
            }
        }
    }
    
    var color: Canvas.Color = .black
    
    var textDecoration: Canvas.TextDecoration = .none
    
    var didFinish: ((_ text: String, _ fontSize: CGFloat, _ color: Canvas.Color, _ align: Canvas.Align, _ textDecoration: Canvas.TextDecoration) -> Void)?
    
    var fontSize: CGFloat = 30 {
        didSet {
            bodyTextView.font = UIFont.systemFont(ofSize: self.fontSize, weight: .semibold)
            fontSizeSlider.value = Float(self.fontSize)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTextView()
        self.initButton()
        self.initKeyboardView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareTextView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareObservers()
        bodyTextView.becomeFirstResponder()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeObservers()
    }
    
    
    private func initTextView() {
        bodyTextView.text = ""
        fontSizeSlider.maximumValue = 70
        fontSizeSlider.minimumValue = 11
        fontSizeSlider.addTarget(self, action: #selector(self.changeFontSizeSlider(_:)), for: .valueChanged)
    }
    
    
    private func initButton() {
        doneButton.addTarget(self, action: #selector(self.onDoneButton(_:)), for: .touchDown)
        alignChangerButton.addTarget(self, action: #selector(self.onAlignChangerButton(_:)), for: .touchDown)
    }
    
    
    private func initKeyboardView() {
        keyboardToasterView.relatedViewToTargetView = self.view
        keyboardToasterView.targetViewButtomConstraint = keyboardToasterViewBottomConstraint
    }
    
    
    private func prepareObservers() {
        keyboardToasterView.prepareObservers()
    }
    
    
    private func removeObservers() {
        keyboardToasterView.removeObservers()
    }
    
    
    private func prepareTextView() {
        guard let label: TextEditorLabel = self.label else {
            self.fontSize = 30
            self.align = .center
            self.color = .black
            self.textDecoration = .none
            return
        }
        self.fontSize = label.fontSize
        self.align = label.align
        self.color = label.color
        self.textDecoration = label.textDecoration
        bodyTextView.text = label.text
    }
    
    
    // MARK: - Target Slider
    
    @objc func changeFontSizeSlider(_ sender: UISlider) {
        self.fontSize = CGFloat(fontSizeSlider.value)
    }
    
    
    // MARK: - Target Button
    
    @objc func onDoneButton(_ sender: UIButton) {
        self.dismiss(animated: false) {
            if self.bodyTextView.text != "" {
                self.didFinish?(self.bodyTextView.text, self.fontSize, self.color , self.align, self.textDecoration)
            }
        }
    }
    
    
    @objc func onAlignChangerButton(_ sender: UIButton) {
        alignChangerButton.change { (align: Canvas.Align) in
            self.align = align
        }
    }
    
}
