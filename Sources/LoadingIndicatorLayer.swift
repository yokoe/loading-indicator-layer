import Cocoa

open class LoadingIndicatorLayer: CALayer {
    public enum Status {
        case idle
        case hover
        case loading
    }
    
    fileprivate var circleLayers = [CAShapeLayer]()

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    public override init() {
        super.init()

        for _ in 0 ..< 3 {
            let circleLayer = CAShapeLayer()
            circleLayer.lineWidth = 10
            circleLayer.strokeColor = NSColor.white.cgColor
            circleLayer.fillColor = NSColor.clear.cgColor
            circleLayer.strokeStart = 0
            circleLayer.strokeEnd = 0.333
            circleLayer.opacity = 0
            circleLayers.append(circleLayer)
            addSublayer(circleLayer)
        }
    }

    fileprivate var previousBounds: CGRect?
    override open func layoutSublayers() {
        if let previousBounds = previousBounds, previousBounds.equalTo(bounds) {
            return
        }

        updateStatus()
        previousBounds = bounds
    }
    
    open var status: Status = .idle {
        didSet {
            if oldValue != status {
                updateStatus()
            }
        }
    }

    fileprivate func setupCircleLayersForNonLoadingStatus(_ opacity: Float) {
        for i in 0 ..< 3 {
            let circleLayer = circleLayers[i]
            circleLayer.opacity = opacity
            circleLayer.transform = CATransform3DIdentity
            circleLayer.frame = bounds
            circleLayer.path = NSBezierPath(ovalIn: bounds).cgPath
            circleLayer.transform = CATransform3DMakeRotation(CGFloat(i) / 3 * CGFloat(M_PI) * 2, 0, 0, 1)
            circleLayer.removeAnimation(forKey: "rotatingAnimation")
        }
    }
    fileprivate func updateStatus() {
        switch status {
        case .idle:
            setupCircleLayersForNonLoadingStatus(0)
            for (_, circleLayer) in circleLayers.enumerated() {
                circleLayer.strokeStart = 0
                circleLayer.strokeEnd = 0.333
            }
            break
        case .hover:
            setupCircleLayersForNonLoadingStatus(0.5)
            for (_, circleLayer) in circleLayers.enumerated() {
                circleLayer.strokeStart = 0.1
                circleLayer.strokeEnd = 0.233
            }
            break
        case .loading:
            for (i, circleLayer) in circleLayers.enumerated() {
                circleLayer.opacity = 0.9
                circleLayer.strokeStart = 0
                circleLayer.strokeEnd = 0.5
                circleLayer.transform = CATransform3DIdentity
                circleLayer.frame = bounds
                circleLayer.path = NSBezierPath(ovalIn: bounds.insetBy(dx: -CGFloat(i) * 10, dy: -CGFloat(i) * 10)).cgPath

                let rotatingAnimation = CAKeyframeAnimation(keyPath: "transform")
                let maxAngle: CGFloat = i % 2 == 0 ? -6.28 : 6.28
                rotatingAnimation.values = [
                    transformWithAngle(CGFloat(i) / 3 * CGFloat(M_PI) * 2),
                    transformWithAngle(CGFloat(i) / 3 * CGFloat(M_PI) * 2 + maxAngle * 0.5),
                    transformWithAngle(CGFloat(i) / 3 * CGFloat(M_PI) * 2 + maxAngle)
                ]
                rotatingAnimation.keyTimes = [0, 0.5, 1]
                rotatingAnimation.duration = 3
                rotatingAnimation.repeatCount = .infinity
                rotatingAnimation.isRemovedOnCompletion = false
                rotatingAnimation.fillMode = kCAFillModeForwards
                circleLayer.removeAnimation(forKey: "rotatingAnimation")
                circleLayer.add(rotatingAnimation, forKey: "rotatingAnimation")
            }
            break
        }
    }

    fileprivate func transformWithAngle(_ angle: CGFloat) -> NSValue {
        return NSValue(caTransform3D: CATransform3DMakeRotation(angle, 0, 0, 1))
    }
}

// From: https://gist.github.com/mayoff/d6d9738860ef2d0ac4055f0d12c21533
fileprivate extension NSBezierPath {

    fileprivate var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement:
                path.move(to: points[0])
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement:
                path.closeSubpath()
            }
        }

        return path
    }
}
