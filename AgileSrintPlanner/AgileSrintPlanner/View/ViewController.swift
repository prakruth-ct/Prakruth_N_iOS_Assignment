import UIKit
import Firebase
import Crashlytics
import GoogleSignIn
import FirebaseUI

class ViewController: BaseVC, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet private weak var emailSignInButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var passwordextField: UITextField!
    
    var fireBaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        setupTextFieldDelegates()
        emailSignInButton.imageView?.contentMode = .scaleAspectFit
        NotificationCenter.default.addObserver(self, selector: #selector(moveViewWhenKeyboardAppears), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveViewWhenKeyboardAppears), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @IBAction private func newUserButtonDidPress(_ button: UIButton) {
        guard let popVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: EmailSignInPopUpVC.self)) as? EmailSignInPopUpVC else { fatalError() }
        
        addChild(popVC)
        popVC.view.frame = view.frame
        view.addSubview(popVC.view)
        popVC.didMove(toParent: self)
    }

    @IBAction private func emailLoginButtonDidPress(_ button: UIButton) {
        if nameTextField?.text?.isEmpty ?? true || passwordextField?.text?.isEmpty ?? true {
            showAlert(title: "Login Failed", msg: "Email or Password Missing", actionTitle: "Close")
        } else if !isValidEmail(email: nameTextField.text ?? "") {
            showAlert(title: "Login Failed", msg: "Email Id Wrongly Formated", actionTitle: "Close")
        } else {
            super.startLoading()
            fireBaseManager.emailUserLogin(email: nameTextField?.text, password: passwordextField?.text) { (user, error) in
                if error != "nil" {
                    self.showAlert(title: "Login Failed", msg: error, actionTitle: "Try Again")
                } else {
                    self.fireBaseManager.decideUserRole(user: Auth.auth().currentUser) { (viewController, role) in
                        UserDefaults.standard.set(role, forKey: Constants.UserDefaults.role)
                        guard let viewController = viewController else { return }
                        let currentUser = Auth.auth().currentUser
                        currentUser?.getIDTokenResult(forcingRefresh: true, completion: { (token, error) in
                                UserDefaults.standard.set(token?.claims, forKey: Constants.UserDefaults.currentUser)
                        })
                        let navigationController = UINavigationController(rootViewController: viewController)
                        self.present(navigationController, animated: true, completion: nil)
//                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                //CANNOT CALL SUPER WITH WEAK SELF
                super.stopLoading()
            }
        }
    }
    
    @IBAction private func passwordHideShowButtonDidPress(_ button: UIButton) {
        if passwordextField.isSecureTextEntry {
            passwordextField.isSecureTextEntry = false
        } else {
            passwordextField.isSecureTextEntry = true
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch? = touches.first
        view.endEditing(true)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
    @objc func moveViewWhenKeyboardAppears(notification: Notification) {
        let notificationInfoObj = notification.userInfo
        guard let notificationInfo = notificationInfoObj else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            if let keyBoardFrame = (notificationInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyBoardFrame.height
                }
            }else {
                return
            }
        }else if notification.name == UIResponder.keyboardWillHideNotification {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func setupTextFieldDelegates() {
        passwordextField.delegate = self
        passwordextField.returnKeyType = .done
        nameTextField.delegate = self
        nameTextField.returnKeyType = .next
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
