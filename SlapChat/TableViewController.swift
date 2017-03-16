//
//  TableViewController.swift
//  SlapChat
//
//  Created by Ian Rahman on 7/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

// credit to eirnym, adapted this from their OBJC code

// generates a random date and time

import UIKit

class TableViewController: UITableViewController {

    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if store.getMessageCount() < 1000 {
            generateTestData()
        }
        
        DataStore.dateFormatter.dateFormat = "MMMM d, yyyy (hh:mm)"
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.getMessageCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        let messageForCell = store.getMessage(at: indexPath.row)
        cell.tag = indexPath.row
        let date = DataStore.dateFormatter.string(from: messageForCell.createdAt as! Date)
        cell.textLabel?.text = "\(date )"
        cell.detailTextLabel?.text = messageForCell.content
        return cell
    }
    
    func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
    
    func generateTestData(){
        let verbs = ["lost", "bought", "tested", "tasted", "washed", "carried", "tried out", "burned", "insulted", "trashed", "smashed", "dropped", "side-eyed", "kissed"]
        let pronouns = [("I ", "your"), ("You", "my")]
        let nouns = ["pants", "money", "DS", "favorite mug", "best friend", "grandma's priceless spoon collection", "lucky boxers", "sketchbook", "laptop", "textbook", "student film", "app project", "term paper", "girlfriend", "condoms", "championship ring"]
        let finish = ["last thursday.", "two weeks ago.", "on monday.", "over spring break.", "while I was in Chem Lab.", "when we were in High School", "while my buddy Clyde was watching.", "at the Kappa Psi party.", "in your wildest dreams.", "while everyone else was at the homecoming game."]
        
        let num = Int(arc4random_uniform(50))
        for _ in 0...num{
            let rand = Int(arc4random())
            print("hi")
            let msgStr = pronouns[rand % pronouns.count].0 + " " + verbs[rand % verbs.count] +  " " + pronouns[rand % pronouns.count].1 + " " + nouns[rand % nouns.count] + " " + finish[rand % finish.count]
            if let date = generateRandomDate(daysBack: 100){
                store.addMessage(content: msgStr, date: date)
                print ("did a thing")
            }else {print("could not generate date")}
        }
        
        for index in 0..<store.getMessageCount(){
            let messageToPrint = store.getMessage(at: index)
            print("\(messageToPrint.createdAt): \(messageToPrint.content)")
        }
    }
}
