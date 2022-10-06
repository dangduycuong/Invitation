//
//  TutorialVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/4/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import AVFoundation

class TutorialVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    var stop: Bool = false
    var imageNames = [Int](1...29)
    
    var timer = Timer()
    var counter = 0
    let audioPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupPageControll()
        navigationController?.navigationBar.isHidden = false
        navigationBarButtonItems([(ItemType.back, ItemPosition.left)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Hướng dẫn sử dụng ứng dụng"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAudioPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioPlayer.pause()
    }
    
    override func back(_ sender: UIBarButtonItem) {
        backVC(controller: Storyboard.MainSlide.mainSlideMenuViewController())
    }
    
    func setupAudioPlayer() {
        // TODO: load the audio file asynchronously and observe player status
        guard let audioFileURL = Bundle.main.url(forResource: "StrangeZero", withExtension: "mp3") else { return }
        let asset = AVURLAsset(url: audioFileURL, options: nil)
        let playerItem = AVPlayerItem(asset: asset)
        audioPlayer.replaceCurrentItem(with: playerItem)
        audioPlayer.actionAtItemEnd = .pause
        
        let durationInSeconds = CMTimeGetSeconds(asset.duration)
        //        circularSlider.maximumValue = CGFloat(durationInSeconds)
        let interval = CMTimeMake(value: 1, timescale: 4)
        audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) {
            [weak self] time in
            let seconds = CMTimeGetSeconds(time)
            //            self?.updatePlayerUI(withCurrentTime: CGFloat(seconds))
        }
        
        self.audioPlayer.play()
    }
    
    func setupPageControll() {
        pageControll.numberOfPages = imageNames.count
        pageControll.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {
        
        if counter < imageNames.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControll.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControll.currentPage = counter
            counter = 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutorialCell
        cell.image.image = UIImage(named: "\(imageNames[indexPath.row])")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        stop = !stop
        if stop {
            audioPlayer.pause()
            timer.invalidate()
        } else {
            audioPlayer.play()
            setupPageControll()
        }
    }
    
}

extension TutorialVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
