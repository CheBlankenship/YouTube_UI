//
//  ViewController.swift
//  Youtube
//
//  Created by Che Blankenship on 7/6/17.
//  Copyright © 2017 Che Blankenship. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    
//    var videos: [Video] = {
//        
//        // Daniel Caesar Channel MVC
//        var daniel_caesar_channel = Channel()
//        daniel_caesar_channel.name = "Daniel Caesar"
//        daniel_caesar_channel.profileImageName = "dani_prof"
//        
//        // taylor swift MVC
//        var blankSpaceVideo = Video()
//        blankSpaceVideo.thumbnailImageName = "taylor_swift_blank_space"
//        blankSpaceVideo.title = "Taylor Swift - Blank Space"
//        blankSpaceVideo.numberOfViews = 1640684000
//        //blankSpaceVideo.date =
//        
//        blankSpaceVideo.channel = daniel_caesar_channel
//        
//        // Daniel Caesar MVC
//        var getYouVideo = Video()
//        getYouVideo.thumbnailImageName = "daniel_caesar"
//        getYouVideo.title = "Daniel Caesar - Get You ft. Kali Uchis [Official Video]"
//        getYouVideo.numberOfViews = 5043491021
//        //getYouVideo.date =
//        getYouVideo.channel = daniel_caesar_channel
//        return [blankSpaceVideo, getYouVideo]
//    }()
    
    // Define video： ここでは？オプショナルを使うことでまだ定義されていない値を準備しておく。
    // ここでは、ModelのVideo classをArrayとして呼んでいる。
    var videos: [Video]?
    
    func fetchVideos() {
        let urlStr = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        let url = URLRequest(url: urlStr!)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error ?? "ERROR")
                return
            }
            
            // selfを使うことで自分のクラス内の値にアクセスすることが可能になる。ここでは、Homecontrollerにあるvideosというoptional array にアクセスする.
            self.videos = [Video]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                
                for dictionary in json as! [[String: AnyObject]] {
                    // 先ほど読んだModel の　Video class　をオブジェクトとして定義。
                    let video = Video()
                    // jsonの値を Video object　の　key　と一致させる。そして、as?　を使って String にキャスト(変換)する。
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    //print(video.title ?? "get title from JSON")
                    
                    
                    // Dictionary の　channel レベルにアクセスしやすいように定義しておく
                    let channelDictionary = dictionary["channel"] as! [String: AnyObject]
                    // Channel class を呼ぶ。
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    
                    video.channel = channel
                    /// 最後に、Array として定義した　var videos: [Video]?　に代入する。
                    self.videos?.append(video)
                    
                }
                
                DispatchQueue.global().async {
                    self.collectionView?.reloadData()
                }
                
                
            }
            catch let jsonError {
                print(jsonError)
            }
            
            
//            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(str ?? "LOAD JSON DATA?")
            
        }.resume()
            
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()

        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearch))
        
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
    }
    
    

    func handleSearch() {
        print(123)
    }
    
    func handleMar() {
        print(456)
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
        
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection numberOfItemInSection: Int) -> Int {
        
        if let count = videos?.count {
            return count
        }
        
        return videos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // ダウンキャストして、Video() class へのアクセスを可能にする
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}







