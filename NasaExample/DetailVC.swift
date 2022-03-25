//
//  DetailVC.swift
//  NasaExample
//
//  Created by IrvingHuang on 2022/3/23.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var hdurlImageView: UIImageView!
    var nasaData: NaDataFromJson!
    var urlSession = URLSession(configuration: .default)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nasaData = nasaData {
            self.title = nasaData.title
            dateLabel.text = nasaData.date
            titleLabel.text = nasaData.title
            copyrightLabel.text = nasaData.copyright
            descriptionLabel.text = nasaData.description
            let fromMainVChdurl = nasaData.hdurl ?? ""
            showPicture(detailVChdurl: fromMainVChdurl)
        } else {
            titleLabel.text = "no data found"
        }
    }
    
    func showPicture(detailVChdurl: String) {
        if let hdurl = URL(string: detailVChdurl) {
            let urlSessionDownloadTask = urlSession.downloadTask(with: hdurl, completionHandler: {
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
                            self.hdurlImageView.image = downloadImage
                        }
                    }catch {
                        print("錯誤樣式 TO DO")
                    }
                }
            })
            urlSessionDownloadTask.resume()
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
