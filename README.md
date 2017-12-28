# Local-Authentication

 This is a simple example for integrating a local authentication for sucure some content.

# Quick Guide

The local authentication works on iphone passcode. We used Local Authentication framework that will provide the authentication requesting facilities from use, if user seted Face ID then it will ask for face authentication and if user seted Touch ID then it will ask for fingerprint scane otherwise passcode will work.

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
    
    
    When user successfully authenticate then user will access the secure content.
