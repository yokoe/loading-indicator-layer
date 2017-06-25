import Cocoa
import LoadingIndicatorLayer

class ViewController: NSViewController {
    @IBOutlet weak var theView: NSView!
    
    private var loadingIndicatorLayer: LoadingIndicatorLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theView.wantsLayer = true
        theView.layer = CALayer()
        theView.layer?.backgroundColor = NSColor.darkGray.cgColor
        
        loadingIndicatorLayer = LoadingIndicatorLayer()
        loadingIndicatorLayer.color = NSColor.yellow
        theView.layer?.addSublayer(loadingIndicatorLayer)
    }
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        guard let layer = theView.layer else { return }
        
        loadingIndicatorLayer.frame = CGRect(x: layer.bounds.midX - 40, y: layer.bounds.midY - 40, width: 80, height: 80)
    }
    
    @IBAction func onStatusIdle(_ sender: Any) {
        loadingIndicatorLayer.status = .idle
    }
    
    @IBAction func onStatusLoading(_ sender: Any) {
        loadingIndicatorLayer.status = .loading
    }
}

