//
//  SelectSeatViewController.swift
//  GFMeal
//
//  Created by Naver on 2017. 4. 22..
//  Copyright © 2017년 minsoopark. All rights reserved.
//

import UIKit
import Firebase

class SelectSeatViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var seatPicker: UIPickerView!
    @IBOutlet weak var numberPicker: UIPickerView!
    
    @IBOutlet weak var closeBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    let seats = ["A", "B", "C"]
    let numbers = [["1", "2"], ["1", "2", "3", "4", "5", "6"], ["1", "2", "3", "4", "5", "6", "7", "8"]]
    
    var seatIndex = 0
    
    var groupId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navController = navigationController as! SelectSeatViewControllerWrapper
        self.groupId = navController.groupId
        
        self.seatPicker.dataSource = self
        self.seatPicker.delegate = self
        
        self.numberPicker.dataSource = self
        self.numberPicker.delegate = self
        
        self.closeBarButton.target = self
        self.closeBarButton.action = #selector(SelectSeatViewController.close)
        
        self.doneBarButton.target = self
        self.doneBarButton.action = #selector(SelectSeatViewController.selectSeat)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func selectSeat() {
        print("group id = \(groupId)")
        let currentTimeMillis = Date().timeIntervalSince1970 * 1000
        let body = "\(seats[seatPicker.selectedRow(inComponent: 0)])\(numbers[seatIndex][numberPicker.selectedRow(inComponent: 0)]) 근처에 앉았어요."
        let message = [
            "sender": FIRAuth.auth()?.currentUser?.displayName ?? "",
            "body": body,
            "createdAt": currentTimeMillis
        ] as [String : Any]
        let ref = FIRDatabase.database().reference()
        ref.child("group").child(groupId).child("message").childByAutoId().setValue(message)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Sources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var counts = 0
        if pickerView == self.seatPicker {
            counts = seats.count
        } else {
            counts = numbers[seatIndex].count
        }
        return counts
    }
    
    // MARK: Delegates
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.seatPicker {
            return seats[row]
        } else {
            return numbers[seatIndex][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.seatPicker {
            seatIndex = row
            self.numberPicker.reloadAllComponents()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
