//
//  NaSingleData.swift
//  NasaExample
//
//  Created by IrvingHuang on 2022/3/24.
//

import Foundation

class NasaData {
    var description: String = ""
    var copyright: String = ""
    var title: String = ""
    var url: String = ""
    var apod_site: String = ""
    var date: String = ""
    var media_type: String = ""
    var hdurl: String = ""
    
    init(description: String, copyright: String, title: String, url: String, apod_site: String, date: String, media_type: String, hdurl: String) {
        self.description = description
        self.copyright = copyright
        self.title = title
        self.url = url
        self.apod_site = apod_site
        self.date = date
        self.media_type = media_type
        self.hdurl = hdurl
    }
    
    var show: String {
        let text = "description:\(description)\ncopyright\(copyright)\ntitle\(title)\nurl\(url)\napod_site\(apod_site)\ndate\(date)\nmedia_type\(media_type)\nhdurl\(hdurl)"
        return text
    }
}
