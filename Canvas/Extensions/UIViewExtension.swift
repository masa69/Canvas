
import UIKit

extension UIView {
    func toImage() -> UIImage? {
        // UIGraphicsBeginImageContextWithOptions(size: CGSize, opaque: Bool, scale: CGFloat)
        // 第2引数: true = 背景不透明, false = 背景透明
        // 第3引数: Retinaに対応するために必要
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
