//
//  ViewController.swift
//  GFMeal
//
//  Created by Naver on 2017. 4. 21..
//  Copyright © 2017년 minsoopark. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookLogin
import Firebase

class ViewController: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [.email, .publicProfile])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let groupListViewController = storyBoard.instantiateViewController(withIdentifier: "groupListWrapper")
            self.present(groupListViewController, animated:true, completion:nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
}

