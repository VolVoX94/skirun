//
//  SecondViewController.swift
//  skirun
//
//  Created by AISLAB on 27.02.19.
//  Copyright © 2019 hevs. All rights reserved.
// Olivier test



import UIKit

class SecondViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    

    

    @IBOutlet weak var competitionPicker: UIPickerView!
    var listCompetitions:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.competitionPicker.delegate = self
        self.competitionPicker.dataSource = self
        loadListCompetitions();
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //if (pickerView.tag == 0){
            return listCompetitions[row]
       // }else{
             //-----------
        //    return listCompetitions[row]
        //}
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // if (competitionPicker.tag == 0){
        return listCompetitions.count
        // }else{
        //-----------
        //    return listCompetitions.count
        // }
    }
    
    func loadListCompetitions(){
        FirebaseManager.getCompetitons(completion: { (data) in
            self.listCompetitions = Array(data)
            print(data)
        })
    }
    
    //Picker formatting
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x:0, y:0, width:400, height: 30))
        
        let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: 14))
        topLabel.text = listCompetitions[row]
        topLabel.textColor = UIColor.white
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(topLabel)
        
        return view
    }


}

