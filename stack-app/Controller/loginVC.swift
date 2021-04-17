//
//  ViewController.swift
//  stack-app
//
//  Created by 김부성 on 2/4/21.
//

import UIKit

import Alamofire
import SwiftyJSON

class loginVC: UIViewController, UITextFieldDelegate {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var Idtextfield: UITextField!
    @IBOutlet weak var PWtextfield: UITextField!
    @IBOutlet weak var autoLoginCheckBox: UIView!
    @IBOutlet var autoLoginTouch: UITapGestureRecognizer!
    @IBOutlet weak var checkMark: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edittextfield(textfieldname: Idtextfield)
        edittextfield(textfieldname: PWtextfield)
        checkMark.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    func edittextfield(textfieldname: UITextField) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textfieldname.delegate = self
        textfieldname.leftView = paddingView
        textfieldname.leftViewMode = .always
        textfieldname.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == Idtextfield {
            PWtextfield.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            submit()
        }
        return true
    }
    
    @IBAction func autoLoginTouch(_ sender: UITapGestureRecognizer) {
        if checkMark.isHidden == true {
            checkMark.isHidden = false
        }
        else {
            checkMark.isHidden = true
        }
    }
    
    private func submit() {
        
        let url = "http://10.80.162.86:3000/v1/auth/login"
//        let id = Idtextfield.text
//        let pw = PWtextfield.text
        
        let param: Parameters = [
            "id": "student",
            "pw": "student1234"
        ]
        
        
        // timeout시간 설정
//        let sessionManager: Session = {
//          //2
//            let configuration = URLSessionConfiguration.af.default
//          //3
//            configuration.timeoutIntervalForRequest = 30
//            configuration.waitsForConnectivity = true
//          //4
//            return Session(configuration: configuration)
//        }()
//        let configuration = URLSessionConfiguration.af.default
        let alamo = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
        alamo.responseJSON() { response in
            switch response.result {
            case .success(let value):
                if let NSDic = value as? NSDictionary {
                    
                    let code = NSDic["code"] as? NSNumber
                    let message = NSDic["message"] as? NSString
//                    if let data = NSDic["data"] as? NSDictionary {
//                        self.delegate.token = data["token"] as? NSString
//                    }
                    if code == 200 {
                        let data = NSDic["data"] as? NSDictionary
                        self.delegate.token = data?["token"] as? NSString
                        if let menuScreen = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") {
                            menuScreen.modalPresentationStyle = .fullScreen
                            menuScreen.modalTransitionStyle = .crossDissolve
                            self.dismiss(animated: false) {
                                self.present(menuScreen, animated: true, completion: nil)
                            }
                        }
                    }
                    else
                    {
                        let alart = UIAlertController(title: nil, message: "\(message!)", preferredStyle: .alert)
                        self.view.tintColor = UIColor.cyan
                        alart.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alart, animated: true)
                        return
                    }
                }
            
            case .failure(_):
                let alart = UIAlertController(title: nil, message: "네트워크를 다시 확인해주세요", preferredStyle: .alert)
                alart.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alart, animated: true)
                return
            }
        }
    }
    
    //터치가 시작됬을 경우, 키보드를 닫음
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitTouch(_ sender: Any) {
        submit()
    }
}
