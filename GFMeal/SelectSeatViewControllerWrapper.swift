//
//  SelectSeatViewControllerWrapper.swift
//  GFMeal
//
//  Created by Naver on 2017. 4. 22..
//  Copyright © 2017년 minsoopark. All rights reserved.
//

import UIKit

class SelectSeatViewControllerWrapper: UINavigationController {
    
    var groupId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "selectSeat") as! SelectSeatViewController
        viewController.groupId = groupId
        navigationController?.pushViewController(viewController, animated: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
