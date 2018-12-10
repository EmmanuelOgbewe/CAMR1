//
//  CameraHelper.swift
//  CamR1
//
//  Created by Emmanuel  Ogbewe on 11/30/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import UIKit
import Vision
import AVKit

class CameraHelper: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //Search components
    var searchView = UIView()
    let textField = UITextField()
    let topView = UIView()
    let overlay = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    func setUpView(vc: UIViewController, delegate : AVCaptureVideoDataOutputSampleBufferDelegate, cameraView : UIView){
        //Create capture session
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice =  AVCaptureDevice.default(for: .video)else {return}
        guard let input =  try? AVCaptureDeviceInput(device: captureDevice)else{return}
        captureSession.addInput(input)
        captureSession.startRunning()
  
        let previewLayer  = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        topView.frame = vc.view.frame
        vc.view.addSubview(topView)
        topView.layer.addSublayer(previewLayer)
        previewLayer.frame = topView.frame
//        searchView.frame =  vc.view.frame
        overlay.frame = vc.view.frame
        view.addSubview(overlay)
//   
        let dataOuput = AVCaptureVideoDataOutput()
        
        // monitor data output
        dataOuput.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "videoQueue"))
        // add dataouput to capture session
        captureSession.addOutput(dataOuput)
        
        vc.view.addSubview(cameraView)
        
    }
    
    func setUpSeachView(view: UIView){
       
        searchView = UIView(frame: CGRect(x:0, y: 0, width: 200, height: 60))
        searchView.backgroundColor = UIColor(rgb: 0x64676F)
        view.insertSubview(searchView, at: 0)
//
        searchView.translatesAutoresizingMaskIntoConstraints = false

        [
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
           searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
           searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
            ].forEach{$0.isActive = true}
    }
    
}


