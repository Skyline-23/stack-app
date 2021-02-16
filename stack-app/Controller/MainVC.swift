//
//  MainVC.swift
//  stack-app
//
//  Created by 김부성 on 2/7/21.
//

import UIKit
import KDCircularProgress

let bluecolor = #colorLiteral(red: 0.2705882353, green: 0.4431372549, blue: 0.9019607843, alpha: 1)
let redcolor = #colorLiteral(red: 0.9529411765, green: 0.3254901961, blue: 0.3254901961, alpha: 1)

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var circlechart: KDCircularProgress!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var pointbtn: UIButton!
    @IBOutlet weak var pointlbl: UILabel!
    
    
    let currentpoint: Double = 32
    let minuspoint: Double = 13
    let maxpoint: Double = 50
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //테이블 뷰의 선택을 막음
        tableView.allowsSelection = false
        
        // 점수라벨의 텍스트를 변경
        pointlbl.text = "\(Int(currentpoint))점"
        //원형이미지 출력
        circleimage()
        // 처음 원형차트의 퍼센트를 0으로 초기화
        circlechart.angle = 0
        // tableview의 모서리 지정
        self.tableView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 뷰가 나타날때마다 에니메이션을 함
        circlechart.animate(toAngle: newAngle(currentpoint: currentpoint, maxpoint: maxpoint),duration: 0.7, completion: nil)
    }
    @IBAction func pointbtn(_ sender: Any) {
        if titlelbl.text == "상점" {
            titlelbl.text = "벌점"
            pointlbl.text = "\(Int(minuspoint))점"
            pointbtn.setTitle("상점", for: .normal)
            circlechart.set(colors: redcolor)
            circlechart.animate(fromAngle: 0, toAngle: newAngle(currentpoint: currentpoint, maxpoint: maxpoint), duration: 0.7, completion: nil)
            tableView.reloadData()
        }
        else {
            titlelbl.text = "상점"
            pointlbl.text = "\(Int(currentpoint))점"
            pointbtn.setTitle("벌점", for: .normal)
            circlechart.set(colors: bluecolor)
            circlechart.animate(fromAngle: 0, toAngle: newAngle(currentpoint: currentpoint, maxpoint: maxpoint), duration: 0.7, completion: nil)
            tableView.reloadData()
        }
    }
    
    func newAngle(currentpoint: Double, maxpoint: Double) -> Double {
        if titlelbl.text == "상점" {
            return Double(360 * (currentpoint / maxpoint))
        }
        else {
            return Double(360 * (minuspoint / maxpoint))
        }
    }
    
    func circleimage() {
        image.layer.cornerRadius = image.frame.height/2
        image.layer.borderWidth = 1
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.clear.cgColor  //원형 이미지의 테두리 제거
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! customcell
        cell.reasontext.textColor = bluecolor
        if titlelbl.text == "벌점" {
            cell.reasontext.textColor = redcolor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
