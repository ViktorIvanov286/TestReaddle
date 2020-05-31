import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
    
    @IBOutlet weak var list: UIView!
    @IBOutlet weak var grid: UIView!
    
    var listVC = ListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.alpha = 1
        grid.alpha = 0
        
    }
    
    
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            list.alpha = 1
            grid.alpha = 0
        case 1:
            list.alpha = 0
            grid.alpha = 1
        default:
            break
        }
    }
}

