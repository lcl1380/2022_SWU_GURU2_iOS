//
//  TableViewController.swift
//  Exerciswu-main
//
//  Created by YoonJu on 2023/01/28.
//

import UIKit

class TableViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTodoBtn: UIButton!
    @IBOutlet weak var switchBtn: UIButton!
    
    
    var datasource:[String] = []
    
    // 열 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    // 열 데이터
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoCell
        cell.chkBox.tintColor = .black
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.todoLabel.text = "\(datasource[row])"
        return cell
    }
    
    // 순서 조정 메서드 2개
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //from: 옮길 것 to: 옮길 위치(앞에 옮겨짐)
        let fromRow = sourceIndexPath.row
        let toRow = destinationIndexPath.row
        let data = datasource[fromRow]
        datasource.remove(at: fromRow)
        datasource.insert(data, at: toRow)
        saveData()
        tableView.reloadData()
    }
    
    // 아이콘 없애기
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    // 들여쓰기 제거
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // 위치 변경 버튼
    @IBAction func changeEditing(_ sender: Any) {
        self.tableView.isEditing.toggle()
    }
    
    // 데이터 추가 버튼
    @IBAction func addTodo(_ sender: Any) {
        // alert 생성 - 클릭하면 수정창 나타나게 하기
        let editAlert = UIAlertController(title: "운동 추가하기", message: "", preferredStyle: .alert)
        
        // alert창에 텍스트박스 생성, 데이터 내용 표시
        editAlert.addTextField{ (textField) in
            textField.text = ""
        }
        editAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            // 데이터 불러오기
            if let fields = editAlert.textFields, let textField = fields.first, let text = textField.text {
                self.datasource.append(text)
                // 열만 업데이트
                self.saveData()
                self.tableView.reloadData()
            }
        }))
        editAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        // alert창 화면에 띄우기
        self.present(editAlert, animated: true, completion: nil)
    }
    
    
    // 셀 스와이프하면 나타나는 버튼 (수정, 삭제)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let btnEdit = UIContextualAction(style: .destructive, title: "Edit") {(action, view, completion) in
            
            // alert 생성
            let editAlert = UIAlertController(title: "운동 수정하기", message: "", preferredStyle: .alert)
            
            // alert창에 텍스트박스 생성, 데이터 내용 표시
            editAlert.addTextField{ (textField) in
                textField.text = self.datasource[indexPath.row]
            }
            
            editAlert.addAction(UIAlertAction(title: "수정", style: .default, handler: { (action) in
                // 데이터 불러오기
                if let fields = editAlert.textFields, let textField = fields.first, let text = textField.text {
                    self.datasource[indexPath.row] = text
                    // 열만 업데이트
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                    self.saveData()
                }
            }))
            editAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            // alert창 화면에 띄우기
            self.present(editAlert, animated: true, completion: nil)
            completion(true)
        }
        let btnDelete = UIContextualAction(style: .destructive, title: "Del") {(action, view, completion) in
            
            // 데이터 삭제
            let row = indexPath.row
            self.datasource.remove(at: row)
            
            // 테이블뷰 화면에서 삭제
            tableView.reloadData()
            self.saveData()
            completion(true)
        }
        
        // 버튼 색상 설정(= UIColor.black)
        btnEdit.backgroundColor = .blue
        btnDelete.backgroundColor = .black
        
        return UISwipeActionsConfiguration(actions: [btnDelete, btnEdit])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 색상 변경
        addTodoBtn.tintColor = .black
        switchBtn.tintColor = .black
        
        let userDefault = UserDefaults.standard
        if let value = userDefault.array(forKey: "TodoData") as? [String] {
            print(value, "from user default")
            // 자료형 명시 안하면 오류남
            self.datasource = value
        }
    }
    
    // refresh(새로고침) 함수
    @objc func fetchData(_ sender:Any) {
        tableView.refreshControl?.endRefreshing()
    }
    
    // 테이블뷰 높이 설정(한 화면에 5칸 뜨도록)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 5
    }
    
    // UserDefaults에 데이터 저장 시 호출
    func saveData() {
        // UserDefault 인스턴스 만들기
        let userDefault = UserDefaults.standard
        userDefault.setValue(datasource, forKey: "TodoData")
        userDefault.synchronize()
    }
}

