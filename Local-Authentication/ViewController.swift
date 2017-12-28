//
//  ViewController.swift
//  Local-Authentication
//
//  Created by Sachin on 21/12/17.
//  Copyright © 2017 Pixelpoint. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var nextBtn : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action: #selector(self.authenticateUser), for: .touchUpInside)
    }
    
    
    ////// Local authentication method ///////
    @objc func authenticateUser() {
        
        let context = LAContext()
        var error: NSError?
        
        let reasonString = "Authentication is needed to access your notes."
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {
            let _ = [context .evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reasonString, reply: { (success, evalPolicyError) -> Void in
                
                if success {
                    //
                    debugPrint("Successfully authenticated")
                    DispatchQueue.main.async {
                        self.authenticateUser()
                    }
                    
                } else {
                    //
                    switch evalPolicyError!._code {
                    case  LAError.systemCancel.rawValue:
                        print("Authentication was cancelled by the system")
                    case LAError.userCancel.rawValue:
                        print("Authentication was cancelled by the user")
                    case LAError.userFallback.rawValue:
                        print("User selected to enter custom password")
                    default:
                        print("Authentication failed")
                        
                    }
                    if((self.presentingViewController) != nil){
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })]
        } else {
            switch error!.code {
            case LAError.biometryNotEnrolled.rawValue:
                print("TouchID is not enrolled")
            case LAError.passcodeNotSet.rawValue:
                print("A passcode has not been set")
            default:
                print("TouchID now avalible")
            }
        }
    }
    
    //////// Navigate to secure content page after authentication. //////////
    func navigateToNextController() {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! NextViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
