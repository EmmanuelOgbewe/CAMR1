//
//  ResultsHelper.swift
//  CamR1
//
//  Created by Emmanuel  Ogbewe on 11/30/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import Foundation

class ResultsHelper{
    
    private var confidenceData : [String] = []
    private var observationsData : [String] = []
    
    private var numIdentified = Int()
    private var numConfidence = Int()
    
    //initialize
    init(confidenceData: [String], observationsData: [String]){
        self.confidenceData = confidenceData
        self.observationsData = observationsData
        numIdentified = observationsData.count
        numConfidence = confidenceData.count
    }
    
    //return identified objects
    func objectsIdentified() -> [String]{
        return observationsData
    }
    // return array of identified objects confidence level
    func objectsConfidence() -> [String]{
        return confidenceData
    }
    
}
