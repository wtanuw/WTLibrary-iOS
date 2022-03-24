//
//  UIView+WTArrowView.m
//  Pods
//
//  Created by Mac on 20/4/2564 BE.
//

#import "UIView+WTArrowView.h"

@implementation UIView (WTArrowView)

- (void)addArrow
{
    
}


- (void)makeArrow
{
    
}

@end


//extension UIBezierPath {
//    func addArrow(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
//        self.move(to: start)
//        self.addLine(to: end)
//
//        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
//        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
//        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
//
//        self.addLine(to: arrowLine1)
//        self.move(to: end)
//        self.addLine(to: arrowLine2)
//    }
//}
//
//class MyViewController : UIViewController {
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let arrow = UIBezierPath()
//        arrow.addArrow(start: CGPoint(x: 200, y: 200), end: CGPoint(x: 50, y: 50), pointerLineLength: 30, arrowAngle: CGFloat(Double.pi / 4))
//
//        let arrowLayer = CAShapeLayer()
//        arrowLayer.strokeColor = UIColor.black.cgColor
//        arrowLayer.lineWidth = 3
//        arrowLayer.path = arrow.cgPath
//        arrowLayer.fillColor = UIColor.clear.cgColor
//        arrowLayer.lineJoin = kCALineJoinRound
//        arrowLayer.lineCap = kCALineCapRound
//        self.view.layer.addSublayer(arrowLayer)
//    }
//}
