//
//  ViewController.swift
//  stack-app
//
//  Created by 김부성 on 2/4/21.
//

import UIKit
import Alamofire

class loginVC: UIViewController {

    @IBOutlet weak var Idtextfield: UITextField!
    @IBOutlet weak var PWtextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //터치가 시작됬을 경우, 키보드를 닫음
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func submit(_ sender: Any) {
        let url = "http://54.175.187.228:3000/v1/auth/login"
        let id = Idtextfield.text
        let pw = PWtextfield.text
        
        let param: Parameters = [
            "id": id!,
            "pw": pw!
        ]
        
        let alamo = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
        let configuration = URLSessionConfiguration.default
        // timeout시간 설정
        configuration.timeoutIntervalForRequest = TimeInterval(1)
        alamo.responseJSON() { response in
            switch response.result {
            case .success(let value):
                if let nsDic = value as? NSDictionary{
                    print(value)
                    let message = nsDic["message"] as? NSString
                    print(message ?? "nothing")
                }
            case .failure(_):
                let alart = UIAlertController(title: nil, message: "네트워크를 다시 확인해주세요", preferredStyle: .alert)
                alart.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alart, animated: true)
                return
            }
        }
    }
}

