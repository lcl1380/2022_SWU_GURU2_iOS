import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var userModel = UserModel() // 인스턴스 생성
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // 로그인 method
    func loginCheck(id: String, pwd: String) -> Bool {
        for user in userModel.users {
            if user.email == id && user.password == pwd {
                return true // 로그인 성공
            }
        }
        return false
    }
    
    // TextField 흔들기 애니메이션
    func shakeTextField(textField: UITextField) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
             }, completion: { _ in
                 UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
        
        print("[Login View Controller] : 텍스트 흔들기 애니메이션 확인됨!")
    }
        
        
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[Login View Controller] : 로그인 뷰 성공적으로 출력됨!")
        
        // 키보드 내리기
            emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
            passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
            loginButton.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        
//        if let user = Auth.auth().currentUser{
//            emailTextField.placeholder = "이미 로그인 된 상태입니다"
//            passwordTextField.placeholder = "이미 로그인 된 상태입니다"
//        }
        
        // 내비게이션 백버튼
        let backBarButtonItem = UIBarButtonItem(title: "이전 화면으로 돌아가기", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .white  // 색상 변경
            self.navigationItem.backBarButtonItem = backBarButtonItem
        print("[Login View Controller] : 백버튼 성공적으로 실행됨!")
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
            
        if userModel.isValidEmail(id: email){
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        }
        else {
            shakeTextField(textField: emailTextField)
            let emailLabel = UILabel(frame: CGRect(x: 68, y: 345, width: 279, height: 45))
            emailLabel.text = "올바른 이메일 형식을 입력해주세요"
            emailLabel.textColor = UIColor.red
            emailLabel.tag = 100
                
            self.view.addSubview(emailLabel)
        } // 이메일 형식 오류
            
        if userModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        }
        else{
            shakeTextField(textField: passwordTextField)
            let passwordLabel = UILabel(frame: CGRect(x: 68, y: 400, width: 279, height: 45))
            passwordLabel.text = "올바른 비밀번호 형식을 입력해 주세요"
            passwordLabel.textColor = UIColor.red
            passwordLabel.tag = 101
                
            self.view.addSubview(passwordLabel)
        } // 비밀번호 형식 오류
            
        //Firebase 이용하여 로그인
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if user != nil{
                print("로그인 성공!")
                self.performSegue(withIdentifier: "LoginSuccess", sender: self)
            } else {
                print("로그인 실패")
                let loginFailLabel = UILabel(frame: CGRect(x: 83, y: 530, width: 279, height: 45))
                loginFailLabel.text = "아이디 혹은 비밀번호가 다릅니다."
                loginFailLabel.textColor = UIColor.blue
                loginFailLabel.tag = 102
                self.view.addSubview(loginFailLabel)
            }
        }
        
//        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) {
//            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
//                (user, error) in if userModel != nil{
//                    print("로그인 성공")
//                    self.performSegue(withIdentifier: "Main_View", sender: self)
//
//                } else {
//                    print("로그인 실패")
//                    let loginFailLabel = UILabel(frame: CGRect(x: 83, y: 530, width: 279, height: 45))
//                    loginFailLabel.text = "아이디 혹은 비밀번호가 다릅니다."
//                    loginFailLabel.textColor = UIColor.blue
//                    loginFailLabel.tag = 102
//
//                    self.view.addSubview(loginFailLabel)
//                }
//            }
//
////            let loginSuccess: Bool = loginCheck(id: email, pwd: password)
////            if loginSuccess {
////                print("로그인 성공")
////                if let removable = self.view.viewWithTag(102) {
////                    removable.removeFromSuperview()
////                }
////
////                // 스토리보드에서 seg 지정해주고 seg 클릭한 다음 Identifier 지정해주면 됨
////                //참고 : https://0urtrees.tistory.com/45
////                self.performSegue(withIdentifier: "Main_View", sender: self)
////            }
////            else {
////                print("로그인 실패")
////                shakeTextField(textField: emailTextField)
////                shakeTextField(textField: passwordTextField)
////                let loginFailLabel = UILabel(frame: CGRect(x: 83, y: 530, width: 279, height: 45))
////                loginFailLabel.text = "아이디 혹은 비밀번호가 다릅니다."
////                loginFailLabel.textColor = UIColor.blue
////                loginFailLabel.tag = 102
////
////                self.view.addSubview(loginFailLabel)
////            }
//        }
    }
}
