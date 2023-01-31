import UIKit
import FirebaseCore
import FirebaseAuth

class JoinViewController: UIViewController {
    
    var userModel = UserModel() // 인스턴스 생성

        @IBOutlet weak var nameTextField: UITextField!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var passwordConfirmTextField: UITextField!
        @IBOutlet weak var joinButton: UIButton!
    
    // 회원 확인 method
        func isUser(id: String) -> Bool {
            for user in userModel.users {
                if user.email == id {
                    return true // 이미 회원인 경우
                }
            }
            return false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[Join View Controller] : 회원가입 뷰 성공적으로 출력됨!")
        
        // 키보드 내리기
            nameTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
            emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
            passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
            passwordConfirmTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
    }
    
    @IBAction func didTapJoinButton(_ sender: Any) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let passwordConfirm = passwordConfirmTextField.text, !passwordConfirm.isEmpty else { return }
        
        if userModel.isValidEmail(id: email){
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        }
        else {
            shakeTextField(textField: emailTextField)
            let emailLabel = UILabel(frame: CGRect(x: 100, y: 485, width: 275, height: 20))
            emailLabel.text = "이메일 형식을 확인해 주세요"
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
            let passwordLabel = UILabel(frame: CGRect(x: 90, y: 540, width: 275, height: 20))
            passwordLabel.text = "비밀번호 형식을 확인해 주세요"
            passwordLabel.textColor = UIColor.red
            passwordLabel.tag = 101
            
            self.view.addSubview(passwordLabel)
        } // 비밀번호 형식 오류
        
        if password == passwordConfirm {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ [self](user, error) in
                if user != nil{
                    print("회원가입 성공!")
                } else{
                    self.shakeTextField(textField: self.passwordConfirmTextField)
                    let passwordConfirmLabel = UILabel(frame: CGRect(x: 120, y: 595, width: 275, height: 20))
                    passwordConfirmLabel.text = "비밀번호가 다릅니다."
                    passwordConfirmLabel.textColor = UIColor.red
                    passwordConfirmLabel.tag = 102
                    self.view.addSubview(passwordConfirmLabel)
                    
                    print("회원가입 실패")
                    
                }
            }
        }
        
//        if password == passwordConfirm {
//            if let removable = self.view.viewWithTag(102) {
//                removable.removeFromSuperview()
//            }
//        }
//        else {
//            shakeTextField(textField: passwordConfirmTextField)
//            let passwordConfirmLabel = UILabel(frame: CGRect(x: 120, y: 595, width: 275, height: 20))
//            passwordConfirmLabel.text = "비밀번호가 다릅니다."
//            passwordConfirmLabel.textColor = UIColor.red
//            passwordConfirmLabel.tag = 102
//
//            self.view.addSubview(passwordConfirmLabel)
//        }
        
        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) && password == passwordConfirm {
            let joinFail: Bool = isUser(id: email)
            if joinFail {
                print("이메일 중복")
                shakeTextField(textField: emailTextField)
                let joinFailLabel = UILabel(frame: CGRect(x: 68, y: 485, width: 275, height: 20))
                joinFailLabel.text = "이미 가입된 이메일입니다."
                joinFailLabel.textColor = UIColor.red
                joinFailLabel.tag = 103
                
                self.view.addSubview(joinFailLabel)
            }
            else {
                print("가입 성공")
                if let removable = self.view.viewWithTag(103) {
                    removable.removeFromSuperview()
                }
                // 스토리보드에서 seg 지정해주고 seg 클릭한 다음 Identifiet 지정해주면 됨
                //참고 : https://0urtrees.tistory.com/45
                self.performSegue(withIdentifier: "JoinSuccess", sender: self)
            }
        }
    }

    // TextField 흔들기 애니메이션
    func shakeTextField(textField: UITextField) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 10
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }
    
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {
        if nameTextField.isFirstResponder {
            emailTextField.becomeFirstResponder()
        }
        else if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
        else if passwordTextField.isFirstResponder {
            passwordConfirmTextField.becomeFirstResponder()
        }
    }
    
}
