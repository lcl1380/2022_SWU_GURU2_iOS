import UIKit
import Photos

class UserEditViewController: UIViewController {
    
    var imagePicker:UIImagePickerController!
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var bmiField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    let numberFormatter:NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func bmiCalc(_ sender: Any) {
        if let heightText = heightField.text, let height = Double(heightText), let weightText = weightField.text, let weight = Double(weightText){
            let bmi = weight / ((height/100)*(height/100))
            bmiField.text = numberFormatter.string(from: NSNumber(value: bmi))
        }
        view.endEditing(true)
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        print("로그아웃")
    }
    
    
    @IBAction func textFieldFinishEdit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func textEndEditing(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //취소 버튼 추가
        let action_cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(action_cancel)
        
        //현재 사진 삭제 버튼 추가
        let action_delete = UIAlertAction(title: "현재 사진 삭제", style: .default, handler: nil)
            action_delete.setValue(UIColor.red, forKey: "titleTextColor")
            actionSheet.addAction(action_delete)
        //구현
        
        
        
        
        
        
        //갤러리 버튼 추가
        let action_gallery = UIAlertAction(title: "앨범에서 선택", style: .default){
            (action) in
            switch PHPhotoLibrary.authorizationStatus(){
            case .authorized:
                self.showGallery()
            case .notDetermined:
                if #available(iOS 14, *) {
                    PHPhotoLibrary.requestAuthorization(for: .readWrite){ (status) in }
                } else {
                    // Fallback on earlier versions
                }
                
            default:
                let alertVC = UIAlertController(title: "권한 필요", message: "사진첩 접근 권한이 필요합니다. 설정 화면에서 설정해주세요.", preferredStyle: .alert)
                
                //설정 어플 열기
                let action_settings = UIAlertAction(title: "설정", style: .default)
                {
                    (action) in
                    if let appSettings = URL(string: UIApplication.openSettingsURLString){
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
                let action_cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                alertVC.addAction(action_settings)
                alertVC.addAction(action_cancel)
                self.present(alertVC, animated:true, completion:nil)
            }
        }
        actionSheet.addAction(action_gallery)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

//갤러리 띄우기
extension UserEditViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showGallery() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else{
            return
        }
        imageView.image = selectedImage
    }
}
