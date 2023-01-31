//
//  MainViewController.swift
//  Exerciswu-main
//
//  Created by YoonJu on 2023/01/28.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
   
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var goalLabel: UILabel!
    
    // 마이페이지에서 설정값 받아오기
    var dday_text = ""
    var weight_text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // dday, weight 값이 둘다 존재하면 텍스트 바꿈
        if dday_text != "", weight_text != "" {
            goalLabel.font = UIFont.systemFont(ofSize:20)
            goalLabel.text = "\(weight_text)kg까지 \(dday_text)일!"
        }
        
        // 캘린더 설정
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.scope = .month
        calendarView.locale = Locale(identifier: "ko_KR")
        //calendarView.scrollEnabled = false
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        // 헤더의 폰트 정렬 설정
        // .center & .left & .justified & .natural & .right
        //calendarView.appearance.headerTitleAlignment = .left
        // 헤더 높이 설정
        //calendarView.headerHeight = 45
    }
}

