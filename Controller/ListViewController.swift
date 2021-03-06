import UIKit
import CryptoKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var manager = Manager()
    let transition = PopAnimator()
    var myRow: Int = 0
    var myInexPath: IndexPath?
    var statusArray: [UIColor] = [UIColor.red, UIColor.green]
    let url = "https://www.gravatar.com/avatar/"
    
    var randomAmount: Int = 1
    var randomColor: UIColor = UIColor.green
    var counter: Int = 0
    
    @IBAction func listButton(_ sender: UIButton) {
        randomChange()
        tableViewAnimations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomAmount = Int.random(in: 1..<manager.arrayOfNames.count) // Новое
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewAnimations()
    }
    
    func randomChange() {
        randomAmount = Int.random(in: 1..<manager.arrayOfNames.count)
        randomColor = statusArray.randomElement()!
        counter += 1
        tableView.reloadData()
    }
    
    func tableViewAnimations() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 2.0, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomAmount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        if counter == 0 { // For name changing
            cell.nameLable.text = manager.arrayOfNames[indexPath.row]
//            cell.nameLable.text = manager.arrayOfNames.randomElement() // Новое
        } else {
            cell.nameLable.text = manager.arrayOfNames.randomElement()
        }
        
        cell.statusColor.backgroundColor = randomColor == statusArray.randomElement() ? UIColor.green : UIColor.red
        cell.statusColor.layer.masksToBounds = true
        cell.statusColor.layer.cornerRadius = cell.statusColor.frame.height / 2
        
        cell.img.contentMode = .scaleAspectFill
        cell.img.downloaded(from: url + MD5(string: manager.arrayOfEmails[indexPath.row].lowercased()))
        cell.img.layer.masksToBounds = true
        cell.img.layer.cornerRadius = cell.img.frame.height / 2
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myRow = indexPath.row
        myInexPath = indexPath
        performSegue(withIdentifier: "details1", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailListViewController {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: myInexPath!) as! CustomTableViewCell
            
            destination.transitioningDelegate = self
            destination.getImage = url + MD5(string: manager.arrayOfEmails[myRow].lowercased())
            destination.getName = manager.arrayOfNames[myRow]
            destination.getStatus = cell.statusColor.backgroundColor == UIColor.green ? "online" : "offline"
            destination.getEmail = manager.arrayOfEmails[myRow]
        }
    }
    
    
}

// MARK: - MD5

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

// MARK: - Take a photo

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension ListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        guard let selectedIndexPathCell = tableView.indexPathForSelectedRow, let selectedCell = tableView.cellForRow(at: selectedIndexPathCell) as? CustomTableViewCell, let selectedCellSuperview = selectedCell.superview else { return nil }

        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        transition.originFrame = CGRect(
          x: transition.originFrame.origin.x + 20,
          y: transition.originFrame.origin.y + 20,
          width: transition.originFrame.size.width - 40,
          height: transition.originFrame.size.height - 40
        )

        transition.presenting = true
            
            
      return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
      return nil
    }
}

