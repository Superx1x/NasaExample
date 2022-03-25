//
//  ViewController.swift
//  NasaExample
//
//  Created by IrvingHuang on 2022/3/23.
//

import UIKit
import CoreGraphics

struct NaDataFromJson: Decodable {
    var description: String?
    var copyright: String?
    var title: String?
    var url: String?
    var apod_site: String?
    var date: String?
    var media_type: String?
    var hdurl: String?
}

class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var nasaCollectionView: UICollectionView!
    var fullScreenSize :CGSize!
    var nasaDataArr: [NaDataFromJson] = [] {
        didSet {
            DispatchQueue.main.async {
                self.nasaCollectionView.reloadData()
            }
        }
    }
    let apiAddress = "https://raw.githubusercontent.com/cmmobile/NasaDataSet/main/apod.json"
    var urlSession = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        nasaDataArr = getnasaDatas()
        */
        getnasaDatasFromWeb(webAddress: apiAddress)
        // 取得螢幕的尺寸
        fullScreenSize = UIScreen.main.bounds.size
        // 設定UICollectionView背景色
        nasaCollectionView.backgroundColor = UIColor.gray
        // 取得UICollectionView排版物件
        let layout = nasaCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // 設定內容與邊界的間距
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1);
        // 設定每一列的間距
        layout.minimumLineSpacing = 1
        // 設定每個項目的尺寸
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width)/3 - 6.0, height: CGFloat(fullScreenSize.width)/3 - 6.0)
    }
    
    //collectionView裡面每個item要呈現的方法要實作下面三個方法
    //方法一是呈現數量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nasaDataArr.count
    }
    //方法二是每個項目要顯示什麼內容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let nasaData = nasaDataArr[indexPath.row]
        let cellId = "nasaCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NasaCell
        
        let urlStr = nasaData.url ?? ""
        if let smallurl = URL(string: urlStr) {
            let urlSessionDownloadTask = urlSession.downloadTask(with: smallurl, completionHandler: {
                (url, response, error) in
                if error != nil {
                    let errorCode = (error! as NSError).code
                    print("發生錯誤，錯誤代碼：\(errorCode)")
                    return
                }
                if let okURL = url {
                    do {
                        let downloadImage = UIImage(data: try Data(contentsOf: okURL))
                        DispatchQueue.main.async {
                            cell.urlImageView.image = downloadImage
                        }
                    }catch {
                        print("錯誤樣式 TO DO")
                    }
                }
            })
            urlSessionDownloadTask.resume()
        }
        
        cell.titleLabel.text = nasaData.title
        return cell
    }
    //方法三點擊後要做什麼事情
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
        let nasaData = nasaDataArr[indexPath.row]
        detailVC.nasaData = nasaData
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //假資料試試看
    /*
    func getnasaDatas() -> [NasaDate] {
        var nasaDatas = [NasaDate]()
        nasaDatas.append(NasaDate(description: "description1", copyright: "copyright1", title: "title1", url: "url1", apod_site: "apod_site1", date: "date1", media_type: "media_type1", hdurl: "hdurl1"))
        nasaDatas.append(NasaDate(description: "description2", copyright: "copyright2", title: "title2", url: "url2", apod_site: "apod_site2", date: "date2", media_type: "media_type2", hdurl: "hdurl2"))
        nasaDatas.append(NasaDate(description: "description3", copyright: "copyright3", title: "title3", url: "url3", apod_site: "apod_site3", date: "date3", media_type: "media_type3", hdurl: "hdurl3"))
        nasaDatas.append(NasaDate(description: "description4", copyright: "copyright4", title: "title4", url: "url4", apod_site: "apod_site4", date: "date4", media_type: "media_type4", hdurl: "hdurl4"))
        nasaDatas.append(NasaDate(description: "description5", copyright: "copyright5", title: "title5", url: "url5", apod_site: "apod_site5", date: "date5", media_type: "media_type5", hdurl: "hdurl5"))
        return nasaDatas
    }
    */
    
    func getnasaDatasFromWeb(webAddress: String) {
        guard let url = URL(string: webAddress) else { return }
        let urlSessionDataTask = urlSession.dataTask(with: url, completionHandler: {
            (data, urlResponse, error) in
            if error != nil {
                let errorCode = (error! as NSError).code
                print("發生錯誤，錯誤代碼：\(errorCode)")
                return
            }
            if let loadData = data {
                print("成功下載到資料")
                do {
                    self.nasaDataArr = try JSONDecoder().decode([NaDataFromJson].self, from: loadData)
                }catch {
                    print("TO DO")
                }
            }
        })
        urlSessionDataTask.resume()
    }
}

