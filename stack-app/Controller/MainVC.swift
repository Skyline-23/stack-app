//
//  MainVC.swift
//  stack-app
//
//  Created by 김부성 on 2/7/21.
//

import UIKit
import Alamofire
import KDCircularProgress

let bluecolor = #colorLiteral(red: 0.2705882353, green: 0.4431372549, blue: 0.9019607843, alpha: 1)
let redcolor = #colorLiteral(red: 0.9529411765, green: 0.3254901961, blue: 0.3254901961, alpha: 1)

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var circlechart: KDCircularProgress!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointButton: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    
    // 상점 벌점
    var pluspoint: Double = 0
    var minuspoint: Double = 0
    var score:NSArray?
    var tableData : [Int : String] = [:]
    var tableDate : [Int : String] = [:]
    
    // 차트 최고점
    let maxpoint: Double = 50
    // 델리게이트 호출
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 뷰가 생성 될 때 상점을 로드
        networking(type: 0)
        
        //테이블 뷰의 선택을 막음
        tableView.allowsSelection = false
        
        // 점수라벨의 텍스트를 변경
        pointLabel.text = "로딩중"
        //원형이미지 출력
        circleimage()
        // 처음 원형차트의 퍼센트를 0으로 초기화
        circlechart.angle = 0
        // tableview의 모서리 지정
        self.tableView.layer.cornerRadius = 10
        
        // 이 코드는 쓸모 없으니 잘 작동한다면 삭제요망
        //circlechart.frame.origin.x = 500
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 뷰가 나타날때마다 에니메이션을 함
        circlechart.animate(toAngle: newAngle(currentpoint: pluspoint, maxpoint: maxpoint),duration: 0.7, completion: nil)
    }
    
    // 상점, 벌점 전환 함수
    @IBAction func pointButton(_ sender: Any) {
        if title == "상점" {
            title = "벌점"
            pointButton.setTitle("상점", for: .normal)
            circlechart.set(colors: redcolor)
            networking(type: 1)
            tableView.reloadData()
        }
        else {
            title = "상점"
            pointButton.setTitle("벌점", for: .normal)
            circlechart.set(colors: bluecolor)
            networking(type: 0)
            tableView.reloadData()
        }
    }
    
    // 차트의 애니메이션을 그리는 함수
    private func drawChart(_ point: Double) {
        circlechart.animate(fromAngle: 0, toAngle: newAngle(currentpoint: point, maxpoint: maxpoint), duration: 0.7, completion: nil)
    }
    
    // 프로필 사진을 원형으로 처리하는 함수
    private func circleimage() {
        image.layer.cornerRadius = image.frame.height/2
        image.layer.borderWidth = 1
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.clear.cgColor  //원형 이미지의 테두리 제거
    }
    
    // 네트워크 관련 함수
    private func networking(type: Int) {
        
        // 네트워크 url, 헤더, queryparameter 설정
        let url = "http://10.80.162.86:3000/v1/score"
        let headers:HTTPHeaders = ["authorization" : "\((delegate?.token)!)"]
        let parameters: Parameters = ["type": type]
        
        // url을 넣고 get으로 요청
        let alamo = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
        alamo.responseJSON() { response in
            switch response.result {
            case .success(let value):
                if let NSDic = value as? NSDictionary{
                    let code = self.server_code(NSDic)
                    if code == 200 {
                        self.scoreData(NSDic, type)
                        if type == 0 {
                            self.drawChart(self.pluspoint)
                            self.pointLabel.text = "\(Int(self.pluspoint))점"
                            self.tableView.reloadData()
                        }
                        else {
                            self.drawChart(self.minuspoint)
                            self.pointLabel.text = "\(Int(self.minuspoint))점"
                            self.tableView.reloadData()
                        }
                    }
                    else {
                        let message = self.server_message(NSDic)
                        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            case .failure(_):
                let alert = UIAlertController(title: nil, message: "네트워크를 다시 확인해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
                
            }
        }
    }
    
    // 네트워크 처리 후 서버에서 받아온 코드를 처리
    public func server_code(_ dictionary:NSDictionary) -> Int {
        let data = dictionary["code"] as! Int
        return data
    }
    
    public func server_message(_ dictionary:NSDictionary) -> String {
        let data = dictionary["message"] as! String
        return data
    }
    
    // 코드가 정상일 경우 데이터 처리
    private func scoreData(_ dictionary:NSDictionary, _ type: Int) {
        self.pluspoint = 0
        self.minuspoint = 0
        tableData = [:]
        let data = dictionary["data"] as? NSDictionary
        self.score = data?["score"] as? NSArray
        if score?.count != 0 {
            for a in 0...(self.score!.count - 1) {
                let scoreAdd = self.score![a] as? NSDictionary
                if type == 0 {
                    self.pluspoint += scoreAdd!["score"] as! Double
                    tableData[a] = scoreAdd!["reason"] as? String
                }
                else {
                    self.minuspoint += scoreAdd!["score"] as! Double
                    tableData[a] = scoreAdd!["reason"] as? String
                }
            }
        }
        else {
            self.pluspoint = 0
            self.minuspoint = 0
        }
    }
    
    // 차트의 각도를 반환하는 함수
    private func newAngle(currentpoint: Double, maxpoint: Double) -> Double {
        if self.title == "상점" {
            return Double(360 * (currentpoint / maxpoint))
        }
        else {
            return Double(360 * (minuspoint / maxpoint))
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! customcell
        let scoreDic = score![tableData.count - 1 - indexPath.row] as! NSDictionary
        cell.reasontext.text = tableData[tableData.count - 1 - indexPath.row]! + " \(scoreDic["score"]!)점"
        cell.datetext.text = ""
        cell.reasontext.textColor = bluecolor
        if self.title == "벌점" {
            cell.reasontext.textColor = redcolor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
