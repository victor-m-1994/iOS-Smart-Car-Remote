//
//  ViewController.swift
//  Remote Controller
//
//  Created by Victor Marsanskis on 10/19/17.
//  Copyright © 2017 Victor Marsanskis. All rights reserved.
//

import UIKit
import CDJoystick
import CoreBluetooth
import ExternalAccessory

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    
    
    @IBOutlet weak var leftStick: CDJoystick!
    
    @IBOutlet weak var rightStick: CDJoystick!
    
    @IBOutlet weak var leftX: UILabel!
    @IBOutlet weak var leftY: UILabel!
    @IBOutlet weak var leftAngle: UILabel!
    
    @IBOutlet weak var rightX: UILabel!
    @IBOutlet weak var rightY: UILabel!
    @IBOutlet weak var rightAngle: UILabel!
    
    var manager: CBCentralManager!
    var peripheral:CBPeripheral!

    let deviceUUID = UUID(uuidString: "DBBD02C8-765D-4340-95DC-35A7C69F420A")
    let serviceUUID = "DFB0"
    let characteristicUUID = "DFB1"
    let message = "5"
    var testManager = EAAccessoryManager.shared()
    let beeTee = BeeTee()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rightStick = CDJoystick()
        leftStick.backgroundColor = .clear
        rightStick.backgroundColor = .clear
        //Customize joystick
        leftStick.substrateColor = .lightGray
        leftStick.substrateBorderColor = .gray
        leftStick.substrateBorderWidth = 1.0
        leftStick.stickSize = CGSize(width: 50, height: 50)
        leftStick.stickColor = .darkGray
        leftStick.stickBorderColor = .black
        leftStick.stickBorderWidth = 2.0
        leftStick.fade = 0.5
        rightStick.substrateColor = .lightGray
        rightStick.substrateBorderColor = .gray
        rightStick.substrateBorderWidth = 1.0
        rightStick.stickSize = CGSize(width: 50, height: 50)
        rightStick.stickColor = .darkGray
        rightStick.stickBorderColor = .black
        rightStick.stickBorderWidth = 2.0
        rightStick.fade = 0.5
        
        
        leftStick.trackingHandler = { joystickData in
            let x = joystickData.velocity.x
            let y = joystickData.velocity.y
            let angle = joystickData.angle
            self.leftX.text = String(describing: x)
            self.leftY.text = String(describing: y)
            self.leftAngle.text = String(describing: angle)
        }
        
        rightStick.trackingHandler = { joystickData in
            let x = joystickData.velocity.x
            let y = joystickData.velocity.y
            let angle = joystickData.angle
            self.rightX.text = String(describing: x)
            self.rightY.text = String(describing: y)
            self.rightAngle.text = String(describing: angle)
        }
        
        //Bluetooth setup
        manager = CBCentralManager(delegate: self, queue: nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: - Bluetooth Delegates
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("bluetooth state changed")
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Scanning for peripherals")
        } else {
            print("Bluetooth not available.")
        }
        
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Device Found")
        print("Advertisement Data:",advertisementData)
        print("RSSI: ", RSSI)
        //manager.stopScan()
        //manager.connect(peripheral, options: nil)
    }
    
    
    func centralManager( central: CBCentralManager,didConnectPeripheral peripheral: CBPeripheral) {
        print("Connected to: ",peripheral)
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connected: ", error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered services")
    }
    
    
    @IBAction func test(_ sender: Any) {
        let devices = testManager.connectedAccessories
        print(devices.count)
    }
}

