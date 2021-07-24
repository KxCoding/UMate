//
//  ReviewWriteTableViewController.swift
//  ReviewWriteTableViewController
//
//  Created by Hyunwoo Jang on 2021/07/20.
//

import UIKit

class ReviewWriteTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func reviewOkButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBOutlet weak var deliciousButton: RoundedButton!
    @IBOutlet weak var freshButton: RoundedButton!
    @IBOutlet weak var cleanButton: RoundedButton!
    @IBOutlet weak var plainButton: RoundedButton!
    @IBOutlet weak var saltyButton: RoundedButton!
    
    
    @IBAction func tasteSelectLineButtonTapped(_ sender: RoundedButton) {
        deliciousButton.isSelected = sender.tag == 100
        freshButton.isSelected = sender.tag == 101
        cleanButton.isSelected = sender.tag == 102
        plainButton.isSelected = sender.tag == 103
        saltyButton.isSelected = sender.tag == 104
        
        //        print(sender.titleLabel?.text)
    }
    
    
    @IBOutlet weak var kindButton: RoundedButton!
    @IBOutlet weak var unkindButton: RoundedButton!
    @IBOutlet weak var touchyButton: RoundedButton!
    
    
    @IBAction func serviceSelectLineButtonTapped(_ sender: RoundedButton) {
        kindButton.isSelected = sender.tag == 200
        unkindButton.isSelected = sender.tag == 201
        touchyButton.isSelected = sender.tag == 202
    }
    
    
    @IBOutlet weak var quietButton: RoundedButton!
    @IBOutlet weak var emotionalButton: RoundedButton!
    @IBOutlet weak var simpleButton: RoundedButton!
    @IBOutlet weak var cuteButton: RoundedButton!
    @IBOutlet weak var clearButton: RoundedButton!
    
    
    @IBAction func moodSelectLineButtonTapped(_ sender: RoundedButton) {
        quietButton.isSelected = sender.tag == 300
        emotionalButton.isSelected = sender.tag == 301
        simpleButton.isSelected = sender.tag == 302
        cuteButton.isSelected = sender.tag == 303
        clearButton.isSelected = sender.tag == 304
    }
    
    
    @IBOutlet weak var cheapButton: RoundedButton!
    @IBOutlet weak var affordableButton: RoundedButton!
    @IBOutlet weak var expensiveButton: RoundedButton!
    
    
    @IBAction func priceSelectLineButtonTapped(_ sender: RoundedButton) {
        cheapButton.isSelected = sender.tag == 400
        affordableButton.isSelected = sender.tag == 401
        expensiveButton.isSelected = sender.tag == 402
    }
    
    
    @IBOutlet weak var smallButton: RoundedButton!
    @IBOutlet weak var suitableButton: RoundedButton!
    @IBOutlet weak var plentyButton: RoundedButton!
    
    
    @IBAction func amountSelectLineButtonTapped(_ sender: RoundedButton) {
        smallButton.isSelected = sender.tag == 500
        suitableButton.isSelected = sender.tag == 501
        plentyButton.isSelected = sender.tag == 502
    }
    
    
    // MARK: - 총평 파트
    
    @IBOutlet weak var onePointButton: RoundedButton!
    @IBOutlet weak var twoPointButton: RoundedButton!
    @IBOutlet weak var threePointButton: RoundedButton!
    @IBOutlet weak var fourPointButton: RoundedButton!
    @IBOutlet weak var fivePointButton: RoundedButton!
    
    
    
    @IBAction func generalReviewButtonTapped(_ sender: RoundedButton) {
        onePointButton.isSelected = sender.tag == 600
        twoPointButton.isSelected = sender.tag == 601
        threePointButton.isSelected = sender.tag == 602
        fourPointButton.isSelected = sender.tag == 603
        fivePointButton.isSelected = sender.tag == 604
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

