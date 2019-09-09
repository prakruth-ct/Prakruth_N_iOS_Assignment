import UIKit
import Firebase
import FirebaseDatabase
import FirebaseUI

class ProductOwnerMainVC: BaseVC {
    
    @IBOutlet weak var hiddenText: UILabel!
    @IBOutlet weak var accDetails: UIImageView!
    @IBOutlet weak var listGridButton: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var navBarItem: UINavigationItem!
    
    let firebaseManager = FirebaseManager()
    var viewModel = POViewModel()
    var projectDetails: [ProjectDetails] = []
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-user-acc"), style: .plain, target: self, action: #selector(userDisplayButtonDidPress))
        navBarItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icons8-menu-50"), style: .plain, target: self, action: #selector(listImageDidPress))
        startLoading()
        viewModel.getProjectDetailsFromFM { [weak self] (detailArr) in
            self?.projectDetails = detailArr
            self?.collectionView.reloadData()
            self?.stopLoading()
        }
    }    
    func test() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch? = touches.first
    }
    
    @IBAction private func signOutButtonDidPress(_ button: UIButton) {
        viewModel.firebase.emailUserSignOut {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ViewController.self)) as? ViewController else { fatalError() }
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.currentUser)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.role)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction private func addButtonDidPress(_ button: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: NewProjectPopOverVC.self)) as? NewProjectPopOverVC else { fatalError() }
        addChild(vc)
        vc.view.frame = view.frame
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    @objc func userDisplayButtonDidPress(_ button: UIButton) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: AccDetailsVC.self)) as? AccDetailsVC else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @objc func listImageDidPress(_ sender: UITapGestureRecognizer) {
        
    }
}

extension ProductOwnerMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: POProductBacklogCVCell.self), for: indexPath) as? POProductBacklogCVCell
        cell?.titleOfProject.text = projectDetails[indexPath.row].data.title
        cell?.domainOfProject.text = projectDetails[indexPath.row].data.domain
        cell?.descriptionOfProject.text = projectDetails[indexPath.row].data.descp
        cell?.backgroundColor = UIColor.randomClr()
        cell?.layer.cornerRadius = 7.0
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerRow = CGFloat(1)
        let availableWidth = collectionView.frame.size.width - sectionInsets.left
        let widthPerItem = availableWidth / cellsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: ProjectDescriptionVC.self)) as? ProjectDescriptionVC else { fatalError() }
        
        viewController.projectDetails = projectDetails[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIColor {
    static func randomClr() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
    }
}
