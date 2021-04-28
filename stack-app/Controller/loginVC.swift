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
    
    var serverMessage:String = ""
    lazy var alert: UIAlertController = {
        let alartview = UIAlertController(title: nil, message: serverMessage, preferredStyle: .alert)
        alartview.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        return alartview
    }()
    
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
        
        let url = "\(Ip().ip)/v1/auth/login"
//        let id = Idtextfield.text
//        let pw = PWtextfield.text
        
        let param: Parameters = [
            "id": "student",
            "pw": "student1234"
        ]
        
        
        // timeout시간 설정
        let sessionManager: Session = {
          //2
            let configuration = URLSessionConfiguration.af.default
          //3
            configuration.timeoutIntervalForRequest = 30
            configuration.waitsForConnectivity = true
          //4
            return Session(configuration: configuration)
        }()
        
        let alamo = sessionManager.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
        alamo.responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let code = json["code"].intValue
                self.serverMessage = json["message"].stringValue
                if code == 200 {
                    self.delegate.token = json["data"]["token"].stringValue
                    if let menuScreen = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") {
                        menuScreen.modalPresentationStyle = .fullScreen
                        menuScreen.modalTransitionStyle = .crossDissolve
                        self.dismiss(animated: false) {
                            self.present(menuScreen, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    self.view.tintColor = UIColor.cyan
                    self.present(self.alert, animated: true)
                    return
                }
            case .failure(_):
                self.serverMessage = "네트워크를 다시 확인해주세요"
                self.view.tintColor = UIColor.cyan
                self.present(self.alert, animated: true)
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
