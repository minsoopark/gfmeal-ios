//
//  MessageListViewController.swift
//  GFMeal
//
//  Created by Naver on 2017. 4. 22..
//  Copyright © 2017년 minsoopark. All rights reserved.
//

import UIKit
import Firebase

class MessageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var group: Group? = nil
    var messages = [Message]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = group?.name ?? ""
        
        if (group == nil) {
            return
        }
        
        let ref = FIRDatabase.database().reference()
        ref.child("group").child(group?.id ?? "").child("message").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let messageDict = snapshot.value as? NSDictionary
            let messageId = snapshot.key
            let messageSender = messageDict?["sender"] as? String ?? ""
            let messageBody = messageDict?["body"] as? String ?? ""
            let messageCreatedAt = messageDict?["createdAt"] as? Double ?? 0.0
            let message = Message()
            message.id = messageId
            message.sender = messageSender
            message.body = messageBody
            message.createdAt = Int64(messageCreatedAt)
            self.messages += [message]
            self.tableView.reloadData()
            self.scrollToBottom()
        })
        
        self.seatButton.addTarget(self, action: #selector(MessageListViewController.selectSeat), for: .touchUpInside)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        cell.senderLabel.text = message.sender
        cell.createdAtLabel.text = Date().offsetFrom(date: Date(timeIntervalSince1970: TimeInterval(message.createdAt / 1000)))
        cell.bodyLabel.text = message.body
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func selectSeat() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "selectSeatWrapper") as! SelectSeatViewControllerWrapper
        viewController.groupId = group?.id ?? ""
        self.present(viewController, animated: true, completion: nil)
    }
    
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Date {
    func elapsedTimeMillis(date: Date) -> Int64 {
        return Int64(Date().timeIntervalSince(date))
    }
    func yearsFrom(date: Date) -> Int {
        return Int(elapsedTimeMillis(date: date) / 60 / 60 / 24 / 365)
    }
    func monthsFrom(date: Date) -> Int {
        return Int(elapsedTimeMillis(date: date) / 60 / 60 / 24 / 30)
    }
    func weeksFrom(date: Date) -> Int{
        return Int(elapsedTimeMillis(date: date) / 60 / 60 / 24 / 7)
    }
    func daysFrom(date: Date) -> Int {
        return Int(elapsedTimeMillis(date: date) / 60 / 60 / 24)
    }
    func hoursFrom(date: Date) -> Int {
        return Int(elapsedTimeMillis(date: date) / 60 / 60)
    }
    func minutesFrom(date: Date) -> Int {
        return Int(elapsedTimeMillis(date: date) / 60)
    }
    func offsetFrom(date: Date) -> String {
        if yearsFrom(date: date)   > 0 { return "\(yearsFrom(date: date))년 전"   }
        else if monthsFrom(date: date)  > 0 { return "\(monthsFrom(date: date))개월 전"  }
        else if weeksFrom(date: date)   > 0 { return "\(weeksFrom(date: date))주 전"   }
        else if daysFrom(date: date)    > 0 { return "\(daysFrom(date: date))일 전"    }
        else if hoursFrom(date: date)   > 0 { return "\(hoursFrom(date: date))시간 전"   }
        else if minutesFrom(date: date) > 0 { return "\(minutesFrom(date: date))분 전" }
        else { return "방금 전" }
    }
    
}
