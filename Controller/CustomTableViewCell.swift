import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var statusColor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
