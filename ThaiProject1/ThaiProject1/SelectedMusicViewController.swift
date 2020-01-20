//
//  SelectedMusicViewController.swift
//  ThaiProject1_pillow
//
//  Created by 中山颯 on 2016/12/24.
//  Copyright © 2016年 中山颯. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

class SelectedMusicViewController: UIViewController {
    
    var musicTitle: String!
    @IBOutlet weak var musicTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        musicTitleLabel.text = musicTitle
//        print(musicTitle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
