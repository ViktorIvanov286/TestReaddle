import UIKit
import CryptoKit

class GridCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let transition = PopAnimator()
    var myIndexPath: IndexPath?
    var manager = Manager()
    var statusArray: [UIColor] = [UIColor.red, UIColor.green]
    var anotherStatusArray: [String] = [String]()
    let url = "https://www.gravatar.com/avatar/"
    var randomAmount: Int = 1
    var randomColor: UIColor = UIColor.green
    
    @IBAction func collectionButton(_ sender: UIButton) {
        randomChange()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomAmount = Int.random(in: 1..<manager.arrayOfNames.count)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func randomChange() {
        randomAmount = Int.random(in: 1..<manager.arrayOfNames.count)
        randomColor = statusArray.randomElement()!
        collectionView.reloadData()
    }
}

extension GridCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.img.contentMode = .scaleAspectFill
        cell.img.downloaded(from: url + MD5(string: manager.arrayOfEmails[indexPath.row].lowercased()))
        cell.img.layer.masksToBounds = true
        cell.img.layer.cornerRadius = cell.img.frame.height / 2
        
        cell.status.backgroundColor = statusArray.randomElement()
        cell.status.layer.masksToBounds = true
        cell.status.layer.cornerRadius = cell.status.frame.height / 2
        
        if cell.status.backgroundColor == UIColor.green {
            anotherStatusArray.append("online")
        } else {
            anotherStatusArray.append("offline")
        }
        
        return cell
    }
}

extension GridCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DetailGridVC = storyboard.instantiateViewController(identifier: "DetailListViewController") as! DetailListViewController
        
        DetailGridVC.getEmail = manager.arrayOfEmails[indexPath.row]
        DetailGridVC.getName = manager.arrayOfNames[indexPath.row]
        
        if anotherStatusArray[indexPath.row] == "online" {
            DetailGridVC.getStatus = "online"
        } else {
            DetailGridVC.getStatus = "offline"
        }
        
        DetailGridVC.getImage = url + MD5(string: manager.arrayOfEmails[indexPath.row].lowercased())
        
        self.navigationController?.pushViewController(DetailGridVC, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension GridCollectionViewController {
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension GridCollectionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        guard let selectedIndexPathCell = collectionView.indexPathsForSelectedItems?.first, let selectedCell = collectionView.cellForItem(at: selectedIndexPathCell) as? CustomTableViewCell, let selectedCellSuperview = selectedCell.superview else { return nil }

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
