import UIKit
import Firebase
import Crashlytics

class BaseVC: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(title: String, msg: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return regex?.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    func startLoading() {
        
        let blurVC = UIVisualEffectView()
        blurVC.frame = activityIndicator.frame
        blurVC.effect = UIBlurEffect(style: .regular)
        activityIndicator.addSubview(blurVC)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor.blue
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func decideRole(role: String) -> String {
        switch(role) {
        case "PO":
            return "Product Owner"
        case "PM":
            return "Project Manager"
        case "dev":
            return "Developer"
        default:
            return ""
        }
    }
}
