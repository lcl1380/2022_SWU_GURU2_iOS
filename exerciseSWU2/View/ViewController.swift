import UIKit
import SwiftyGif

class ViewController: UIViewController {

    @IBOutlet weak var intro_image: UIButton!
    @IBOutlet weak var TitleImage: UIImageView! //타이틀 로고.png
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //GIF 실행
        do {
            let gif = try UIImage(gifName: "exerciseSwuri")
            self.intro_image.imageView?.setGifImage(gif, loopCount: -1)
        } catch {
            NSLog("GIF 이미지 실행 불가!")
        }
        
        // 로고 이미지 출력
        TitleImage.image = UIImage(named: "exerciSWU")
        print("[View Controller] : 타이틀 로고 성공적으로 출력됨!")
        
        // 배너 띄우는 부분
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        print("[View Controller] : 배너 성공적으로 띄워짐!")
        
        // 2초마다 넘어가는 배너 자동 넘김 함수
        banner_Timer()
        print("[View Controller] : 배너 성공적으로 넘어감!\n")
        
        //내비게이션 백버튼
        let backBarButtonItem = UIBarButtonItem(title: "이전 화면으로 돌아가기", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .white  // 색상 변경
            self.navigationItem.backBarButtonItem = backBarButtonItem
            print("[View Controller] : 백버튼 성공적으로 넘어감!\n")
    }
    
    // 배너 구현 부분 ------------------------------------------------------------------------
        // nowPage : 현재 배너의 페이지를 체크할 변수 (자동 스크롤할 때 필요)
        var nowPage: Int = 0
    
        // 데이터 배열
        let dataArray: Array<UIImage> = [UIImage(named: "img1")!, UIImage(named: "img2")!, UIImage(named: "img3")!,
                                         UIImage(named: "img4")!, UIImage(named: "img5")!, UIImage(named: "img6")!,
                                         UIImage(named: "img7")!, UIImage(named: "img8")!, UIImage(named: "img9")!, UIImage(named: "img10")!]
        
        // 2초마다 실행되는 타이머
        func banner_Timer() {
            let _: Timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in self.banner_Move() }
        }
        
        // 현재 배너를 넘기는 함수
        func banner_Move() {
            //현재 페이지가 마지막 페이지일 경우
            if nowPage == dataArray.count-1 {
            //맨 처음 페이지로 돌아간다
            bannerCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            nowPage = 0
            return
            }
        // 배너를 다음 배너로 전환함
        nowPage += 1
        bannerCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
        }
    // -------------------------------------------------------------------------------
}

//델리게이트와 데이터 소스 처리
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //컬렉션뷰 개수 설정
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dataArray.count //tip개수만큼 개수 자동 설정
        }
        
        //컬렉션뷰 셀 설정
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.imgView.image = dataArray[indexPath.row]
            return cell
        }
        
        // UICollectionViewDelegateFlowLayout 상속
        //컬렉션뷰 사이즈 설정
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: bannerCollectionView.frame.size.width  , height:  bannerCollectionView.frame.height)
        }
        
        //컬렉션뷰 감속 끝났을 때 현재 페이지 체크
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
}
