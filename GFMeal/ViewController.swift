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

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let loginButton = LoginButton(readPermissions: [.email, .publicProfile])
//        loginButton.delegate = self
//        view.addSubview(loginButton)
        
        self.loginButton.addTarget(self, action: #selector(ViewController.facebookLogin), for: .touchUpInside)
        
        FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            let currentUser = auth.currentUser
            if (currentUser != nil) {
                self.performSegue(withIdentifier: "showGroupList", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            self.performSegue(withIdentifier: "showGroupList", sender: self)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    func facebookLogin() {
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logIn([.email, .publicProfile], viewController: self) { (result) in
            self.getFBUserData()
        }
    }
    
    func getFBUserData(){
        if ((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.performSegue(withIdentifier: "showGroupList", sender: self)
                }
            })
        }
    }
}

