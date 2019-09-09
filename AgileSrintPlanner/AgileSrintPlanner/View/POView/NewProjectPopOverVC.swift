import UIKit

class NewProjectPopOverVC: BaseVC {
    
    @IBOutlet weak var actualView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var descpTextField: UITextView!
    
    var viewModel = POViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popOver()
    }
    
    @IBAction private func addProjectButtonDidPress(_ button: UIButton) {
        if titleTextField.text?.isEmpty ?? false {
            showAlert(title: "Missing Data", msg: "Project Title is Mandatory", actionTitle: "Try Again")
        } else if domainTextField.text?.isEmpty ?? false {
            showAlert(title: "Missing Data", msg: "Project Domain is Mandatory", actionTitle: "Try Again")
        } else if descpTextField.text?.isEmpty ?? false {
            showAlert(title: "Missing Data", msg: "Project Description is Mandatory", actionTitle: "Try Again")
        } else {
            super.stopLoading()
            viewModel.addNewProject(title: titleTextField?.text ?? "", domain: domainTextField?.text ?? "", descp: descpTextField?.text ?? "") {
                super.stopLoading()
                super.showAlert(title: "Success", msg: "Project Created Successfully", actionTitle: "Close")
            }
            view.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch? = touches.first
        if touch?.view != actualView {
            view.removeFromSuperview()
        }
    }
    
    func popOver() {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}
