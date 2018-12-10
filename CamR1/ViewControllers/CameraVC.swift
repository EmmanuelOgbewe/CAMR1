//
//  CameraVC.swift
//  CamR1
//
//  Created by Emmanuel  Ogbewe on 11/29/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import UIKit
import Vision
import AVKit

class CameraVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate {
    
    //IBOutlets
    @IBOutlet var cameraView: UIView!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var confidenceField: UILabel!
    
    @IBOutlet var startView: UIVisualEffectView!
    
    private var confidenceData : [String] = []
    private var identifierData : [String] = []
    private var optionsView = UIView()
    
    private var outputText = String()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.isHidden = true
        searchField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setUpLayout()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "StartVC")
        vc.presentingViewController?.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func setUpLayout(){
        let cameraHelper = CameraHelper()
        cameraView.isHidden = false
        searchView.backgroundColor = UIColor.init(rgb: 0x434446).withAlphaComponent(0.6)
        
        searchField.keyboardAppearance = .dark
        cameraHelper.setUpView(vc: self, delegate: self, cameraView: cameraView)
        setUpOptionsView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
//        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        [
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            searchView.heightAnchor.constraint(equalToConstant: 51)
            ].forEach{$0.isActive = true}
    }
    func setUpDelegate(){
        cameraView.isUserInteractionEnabled = true
        let gesture  = UITapGestureRecognizer(target: self, action: #selector(CameraVC.setUpOptionsView))
        gesture.delegate = self
        cameraView.addGestureRecognizer(gesture)
    }
    @objc func setUpOptionsView(){
        let view = UIView(frame: searchView.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(rgb: 0x434446).withAlphaComponent(0.6)
        
        cameraView.addSubview(view)
        [
            view.heightAnchor.constraint(equalToConstant: 51),
            view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            ].forEach{$0.isActive = true }
        
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Camera was able to capture a frame")
        // Create a VNCoreMLModel
        guard let model = try? VNCoreMLModel(for: Resnet50().model)else {return}
        // Create a VNCoreML request
        let request = VNCoreMLRequest(model: model) { (finalReq, err) in
            // check the error
            if err != nil {
                fatalError("error")
            }
            guard let results = finalReq.results as? [VNClassificationObservation] else{return}
            guard let firstObservation = results.first else {return}
            
            print(firstObservation.identifier, firstObservation.confidence)
           
            DispatchQueue.main.async {
                if self.searchField.isEditing == false {
                    self.outputText = firstObservation.identifier
                    self.confidenceField.text = self.setConfidence(num: firstObservation.confidence)
                    self.searchField.text = self.outputText
                }
                print("\(firstObservation.identifier)\(firstObservation.confidence)")
            }
            self.confidenceData.append("\(firstObservation.confidence)")
            self.identifierData.append(firstObservation.identifier)
            print(self.confidenceData.count)
            
        }
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else{return}
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    private func setConfidence(num : Float) -> String{
        return "\(Int(num * 100))%"
    }
    
    public func grabData () -> ([String],[String]){
        return (confidenceData,identifierData)
    }
}
extension CameraVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchField.text = ""
        confidenceField.text = ""
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

