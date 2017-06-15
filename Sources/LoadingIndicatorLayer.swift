import Cocoa

open class LoadingIndicatorLayer: CALayer {
    public var indicatorOpacity: Float = 0.9
    private static let ArcLength: CGFloat = 0.5
    private static let IdleToLoadingAnimationDuration: TimeInterval = 0.3
    private static let LoadingToIdleAnimationDuration: TimeInterval = 0.3
    
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
        
        // Update frames of layers
        for circleLayer in circleLayers {
            circleLayer.transform = CATransform3DIdentity
            circleLayer.frame = bounds
        }

        updateStatus()
        previousBounds = bounds
    }
    
    open var status: Status = .idle {
        didSet {
            if oldValue != status {
                statusTransition(from: oldValue, to: status)
            }
        }
    }

    fileprivate func setupCircleLayersForNonLoadingStatus(_ opacity: Float) {
        for i in 0 ..< 3 {
            let circleLayer = circleLayers[i]
            circleLayer.opacity = opacity
            circleLayer.path = NSBezierPath(ovalIn: bounds).cgPath
            circleLayer.transform = CATransform3DMakeRotation(CGFloat(i) / 3 * CGFloat.pi * 2, 0, 0, 1)
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
                circleLayer.opacity = indicatorOpacity
                circleLayer.strokeStart = 0
                circleLayer.strokeEnd = LoadingIndicatorLayer.ArcLength
                circleLayer.path = arcPath(for: i)

                let rotatingAnimation = CAKeyframeAnimation(keyPath: "transform")
                let maxAngle: CGFloat = i % 2 == 0 ? -6.28 : 6.28
                rotatingAnimation.values = [
                    transformWithAngle(CGFloat(i) / 3 * CGFloat.pi * 2),
                    transformWithAngle(CGFloat(i) / 3 * CGFloat.pi * 2 + maxAngle * 0.5),
                    transformWithAngle(CGFloat(i) / 3 * CGFloat.pi * 2 + maxAngle)
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
    
    private func arcPath(for index: Int) -> CGPath {
        return NSBezierPath(ovalIn: bounds.insetBy(dx: -CGFloat(index) * 10, dy: -CGFloat(index) * 10)).cgPath
    }
    
    // MARK: - Transition animations
    private func statusTransition(from oldStatus: Status, to newStatus: Status) {
        switch (oldStatus, newStatus) {
        case (.idle, .loading):
            idleToLoading()
        case (.loading, .idle):
            loadingToIdle()
        default:
            updateStatus()
        }
    }
    
    private func idleToLoading() {
        for (i, layer) in circleLayers.enumerated() {
            layer.path = arcPath(for: i)
            
            let strokeAnimation: CABasicAnimation
            if i % 2 == 1 {
                strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
                strokeAnimation.fromValue = 0
                strokeAnimation.toValue = LoadingIndicatorLayer.ArcLength
                layer.strokeStart = 0
            } else {
                strokeAnimation = CABasicAnimation(keyPath: "strokeStart")
                strokeAnimation.fromValue = LoadingIndicatorLayer.ArcLength
                strokeAnimation.toValue = 0
                layer.strokeEnd = LoadingIndicatorLayer.ArcLength
            }
            
            
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 0
            opacityAnimation.toValue = indicatorOpacity
            
            let transformAnimation = CABasicAnimation(keyPath: "transform")
            transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1))
            transformAnimation.toValue = transformWithAngle(CGFloat(i) / 3 * CGFloat.pi * 2)
            
            let animation = CAAnimationGroup()
            animation.animations = [opacityAnimation, strokeAnimation, transformAnimation]
            
            animation.duration = LoadingIndicatorLayer.IdleToLoadingAnimationDuration
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.fillMode = kCAFillModeForwards
            if i == 0 {
                animation.delegate = self
            }
            layer.removeAllAnimations()
            layer.add(animation, forKey: "idleToLoadingAnimation")
        }
    }
    
    private func loadingToIdle() {
        for (i, layer) in circleLayers.enumerated() {
            layer.path = arcPath(for: i)
            
            let strokeAnimation: CABasicAnimation
            if i % 2 == 0 {
                strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
                strokeAnimation.fromValue = LoadingIndicatorLayer.ArcLength
                strokeAnimation.toValue = 0
                layer.strokeStart = 0
            } else {
                strokeAnimation = CABasicAnimation(keyPath: "strokeStart")
                strokeAnimation.fromValue = LoadingIndicatorLayer.ArcLength
                strokeAnimation.toValue = 1
                layer.strokeEnd = 1
            }
            
            
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = indicatorOpacity
            opacityAnimation.toValue = 0
            
            let transformAnimation = CABasicAnimation(keyPath: "transform")
            transformAnimation.toValue = NSValue(caTransform3D: CATransform3DRotate(CATransform3DMakeScale(1.25, 1.25, 1), CGFloat.pi * -0.25, 0, 0, 1))
            transformAnimation.fromValue = layer.presentation()!.transform
            
            let animation = CAAnimationGroup()
            animation.animations = [opacityAnimation, strokeAnimation, transformAnimation]
            
            animation.duration = LoadingIndicatorLayer.LoadingToIdleAnimationDuration
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.fillMode = kCAFillModeForwards
            if i == 0 {
                animation.delegate = self
            }
            layer.removeAllAnimations()
            layer.add(animation, forKey: "LoadingToIdleAnimation")
        }
    }
}

extension LoadingIndicatorLayer: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == circleLayers.first?.animation(forKey: "idleToLoadingAnimation") {
            for layer in circleLayers {
                layer.removeAllAnimations()
            }
            updateStatus()
        }
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
