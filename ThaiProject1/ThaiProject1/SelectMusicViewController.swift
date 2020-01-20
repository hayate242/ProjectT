//
//  SelectMusicViewController.swift
//  ThaiProject1
//
//  Created by 中山颯 on 2016/11/17.
//  Copyright © 2016年 中山颯. All rights reserved.
//

import UIKit
import MediaPlayer

class SelectMusicViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var img: UIImageView!

    
    var player = MPMusicPlayerController()
    var cntPlay: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "MP3MusicPlayer"
        
        player = MPMusicPlayerController.applicationMusicPlayer()
        //player = MPMusicPlayerController.systemMusicPlayer()
        
        // 再生中のItemが変わった時に通知を受け取る
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(SelectMusicViewController.nowPlayingItemChanged(_:)), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // 通知の有効化
        player.beginGeneratingPlaybackNotifications()
        
        // MPMediaPickerControllerのインスタンスを作成
        let picker = MPMediaPickerController()
        // ピッカーのデリゲートを設定
        picker.delegate = self
        // 複数選択にする。（falseにすると、単数選択になる）
        picker.allowsPickingMultipleItems = false
        // ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseSong(_ sender: UIButton) {
        // MPMediaPickerControllerのインスタンスを作成
        let picker = MPMediaPickerController()
        // ピッカーのデリゲートを設定
        picker.delegate = self
        // 複数選択にする。（falseにすると、単数選択になる）
        picker.allowsPickingMultipleItems = false
        // ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
   
    
    /// メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        // プレイヤーを止める
        player.stop()
        //init Play/Stop button 
        cntPlay = 0
        playImg.image = UIImage(named: "Circled Pause-50.png")!
        
        // 選択した曲情報がmediaItemCollectionに入っているので、これをplayerにセット。
        player.setQueue(with: mediaItemCollection)
        player.play()
        
        // 選択した曲から最初の曲の情報を表示
        if let mediaItem = mediaItemCollection.items.first {
            updateSongInformationUI(mediaItem)
        }
        
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
        
    }
    
    
    /// 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    /// 曲情報を表示する
    func updateSongInformationUI(_ mediaItem: MPMediaItem) {
        
        // 曲情報表示
        // (a ?? b は、a != nil ? a! : b を示す演算子です)
        // (aがnilの場合にはbとなります)
        artistLabel.text = mediaItem.artist ?? "不明なアーティスト"
        albumLabel.text = mediaItem.albumTitle ?? "不明なアルバム"
        songLabel.text = mediaItem.title ?? "不明な曲"
        
        // アートワーク表示
        if let artwork = mediaItem.artwork {
            let image = artwork.image(at: img.bounds.size)
            img.image = image
        } else {
            // アートワークがないとき
            // (今回は灰色表示としました)
            img.image = nil
            img.backgroundColor = UIColor.gray
        }
        
    }
    
    
    @IBOutlet weak var playImg: UIImageView!
    @IBAction func playStopButton(_ sender: UIButton) {
        if cntPlay%2 == 0 {
            player.pause()
            playImg.image = UIImage(named: "Circled Play-50.png")!
            cntPlay += 1
        }
        else {
            player.play()
            playImg.image = UIImage(named: "Circled Pause-50.png")!
            cntPlay += 1
        }
        print(cntPlay)
    }

    
    
    /// 再生中の曲が変更になったときに呼ばれる
    func nowPlayingItemChanged(_ notification: NSNotification) {
        
        if let mediaItem = player.nowPlayingItem {
            updateSongInformationUI(mediaItem)
        }
        
    }
    
    deinit {
        // 再生中アイテム変更に対する監視をはずす
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // ミュージックプレーヤー通知の無効化
        player.endGeneratingPlaybackNotifications()
    }
    
    
}

