//
//  ViewController.swift
//  stack-app
//
//  Created by 김부성 on 2/4/21.
//

import UIKit

import Alamofire

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
        // 터치 입력 비활성화
        self.view.isUserInteractionEnabled = false
        
        let param: Parameters = [
            "id": "\(Idtextfield.text ?? "")",
            "pw": "\(PWtextfield.text ?? "")"
        ]
        do {
            try Networking.post(uri: "/auth/login", param: param, header: nil) {
                self.view.isUserInteractionEnabled = true
                let decoder = JSONDecoder()
                let jsonData = try? decoder.decode(LoginResponse.self, from: $0)
                switch jsonData?.code {
                case 200:
                    Token.shared.token = jsonData?.data?.token
                    if let menuScreen = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") {
                        menuScreen.modalPresentationStyle = .fullScreen
                        menuScreen.modalTransitionStyle = .crossDissolve
                        self.dismiss(animated: false) {
                            self.present(menuScreen, animated: true, completion: nil)
                        }
                    }
                case 404:
                    print(jsonData?.message as Any)
                default:
                    break
                }
            }
        } catch let error {
            self.view.isUserInteractionEnabled = true
            print(error)
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
