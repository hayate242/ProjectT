//
//  BLEViewController.swift
//  ThaiProject1
//
//  Created by 中山颯 on 2016/11/17.
//  Copyright © 2016年 中山颯. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class BLEViewController: UIViewController, CBCentralManagerDelegate,CBPeripheralDelegate{

    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    
    var myService: Array<Any>!
    /**  キャラクタリスティック配列*/
    var myCharacteristics: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var mySwitch: UISwitch!

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sw: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var sw1: UISwitch!
    @IBOutlet weak var switch1Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Added navigation bar
        self.title = "Massage"

        //Prepare a centralManager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        //start Scanning
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sw.transform = CGAffineTransform(scaleX: 3, y: 3)
        sw1.transform = CGAffineTransform(scaleX: 3, y: 3)
    }
    
    //  接続状況が変わるたびに呼ばれる
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print ("state: \(central.state)")
    }
    
//    //  スキャン開始
    @IBAction func startScan(_ sender: UIButton) {
        print("start Scanning")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
    }
    
    //  スキャン結果を取得
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        
        //if the peripheral name contains "Pro1-", connect the device
        print(self.peripheral)
//        if(self.peripheral.name != nil && self.peripheral.name!.contains("Pro1-")){
//            self.centralManager.connect(self.peripheral, options: nil)
//        }
        self.centralManager.connect(self.peripheral, options: nil)

    }
    
//    //  スキャン終了
//    @IBAction func stopScan(_ sender: UIButton) {
//        centralManager.stopScan()
//    }
    
    
    //  接続成功時に呼ばれる
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connect success!")
        print(self.peripheral)
        //Stop Scanning
        centralManager.stopScan()
        
        statusLabel.text = "status: Connected!"
        
        //Start searching service!
        self.peripheral.delegate = self
        self.peripheral.discoverServices(nil)
    }
    
    //  接続失敗時に呼ばれる
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connect failed...")
    }

    
    
    //  service検索結果取得
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else{
            print("error")
            return
        }
        print("\(services.count)個のサービスを発見。\(services)")
        
        myService = services
        
//        print("myService = \(myService)")
        
        //  サービスを見つけたらすぐにキャラクタリスティックを取得
        for obj in services {
            self.peripheral.discoverCharacteristics(nil, for: obj)
        }
    }
    
    //  キャラクタリスティック検索結果取得
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let characteristics = service.characteristics {
//            print("\(characteristics.count)個のキャラクタリスティックを発見。\(characteristics)")
            
//            myCharacteristics.addObjects(from: [characteristics])
        }

        for characteristics in service.characteristics! {
            myCharacteristics.add(characteristics)
        }
        
        //データを送れます
        for i in 0..<2 {
            //データ更新通知の受け取りを開始する
            self.peripheral.setNotifyValue(true, for: myCharacteristics[i] as! CBCharacteristic)
        }
        
        
    }
    
    /**
     Write
     */
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    {
        print("Write Success to \(peripheral.name)")
    }

    
    
    //send data to peripheral
    @IBAction func swAction(_ sender: UISwitch) {
        
        var st: Int = 0
        // st is a valuable to preserve the connection status of peripheral
        if self.peripheral != nil {
            st = self.peripheral.value(forKey: "state") as! Int
        }
        
        
        //send operation command if the device is connected to peripheral
        if self.peripheral != nil && st == 2 {
            switchLabel.text = sender.isOn ? "ON":"OFF"
            
            if sw.isOn == true {
                //データ更新通知の受け取りを開始する
                self.peripheral.setNotifyValue(true, for: myCharacteristics[0] as! CBCharacteristic)
                
                
                //make NSString data in order to sent by BLE
                let temp:NSString = ("PO") as NSString
                let data: NSData! = temp.data(using: String.Encoding.utf8.rawValue, allowLossyConversion:true) as NSData!
                //send data with BLE
                self.peripheral.writeValue(data as Data, for: myCharacteristics[0] as! CBCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
            else {
                //データ更新通知の受け取りを開始する
                self.peripheral.setNotifyValue(true, for: myCharacteristics[0] as! CBCharacteristic)
                
                
                //make NSString data in order to sent by BLE
                let temp:NSString = ("PC") as NSString
                let data: NSData! = temp.data(using: String.Encoding.utf8.rawValue, allowLossyConversion:true) as NSData!
                //send data with BLE
                self.peripheral.writeValue(data as Data, for: myCharacteristics[0] as! CBCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
        else {
            statusLabel.text = "status: Disconnected!"
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Device is not Connected!"
            alertView.message = "Please push connect button and check the connection state"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            sw.setOn(false, animated: true)
        }
        

    }
    @IBAction func sw1Action(_ sender: UISwitch) {
        var st: Int = 0
        // st is a valuable to preserve the connection status of peripheral
        if self.peripheral != nil {
            st = self.peripheral.value(forKey: "state") as! Int
        }
        
        
        //send operation command if the device is connected to peripheral
        if self.peripheral != nil && st == 2 {
            switch1Label.text = sender.isOn ? "ON":"OFF"
            
            if sw1.isOn == true {
                //データ更新通知の受け取りを開始する
                self.peripheral.setNotifyValue(true, for: myCharacteristics[0] as! CBCharacteristic)
                
                
                //make NSString data in order to sent by BLE
                let temp:NSString = ("P1O") as NSString
                let data: NSData! = temp.data(using: String.Encoding.utf8.rawValue, allowLossyConversion:true) as NSData!
                //send data with BLE
                self.peripheral.writeValue(data as Data, for: myCharacteristics[0] as! CBCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
            else {
                //データ更新通知の受け取りを開始する
                self.peripheral.setNotifyValue(true, for: myCharacteristics[0] as! CBCharacteristic)
                
                
                //make NSString data in order to sent by BLE
                let temp:NSString = ("P1C") as NSString
                let data: NSData! = temp.data(using: String.Encoding.utf8.rawValue, allowLossyConversion:true) as NSData!
                //send data with BLE
                self.peripheral.writeValue(data as Data, for: myCharacteristics[0] as! CBCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
        else {
            statusLabel.text = "status: Disconnected!"
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Device is not Connected!"
            alertView.message = "Please push connect button and check the connection state"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
            
            sw1.setOn(false, animated: true)
        }
    }
    

}
