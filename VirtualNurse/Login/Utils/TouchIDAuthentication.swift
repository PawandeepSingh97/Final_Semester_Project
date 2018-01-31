//
//  TouchIDAuthentication.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 21/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

class BiometricIDAuth {
    let context = LAContext()
    var loginReason = "Logging in with Touch ID"
    
//    func biometricType() -> BiometricType {
//        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
//        if #available(iOS 11.0, *) {
//            switch context.biometryType {
//            case .none:
//                return .none
//            case .typeTouchID:
//                return .touchID
//            case .typeFaceID
//                :
//                return .faceID
//            }
//        } else {
//            // Fallback on earlier versions
//
//        }
//    }
    
    func canEvaluatePolicy() -> Bool {
        print("failed");
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser(completion: @escaping (String?) -> Void) {
        guard canEvaluatePolicy() else {
            completion("Touch ID not available")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    // User authenticated successfully, take appropriate action
                    completion(nil)
                }
            } else {
                let message: String
                
                switch evaluateError {
                case LAError.authenticationFailed?:
                    message = "There was a problem verifying your identity."
                case LAError.userCancel?:
                    message = "You pressed cancel."
                case LAError.userFallback?:
                    message = "You pressed password."
//                case LAError.biometryNotAvailable?:
//                    message = "Face ID/Touch ID is not available."
//                case LAError.biometryNotEnrolled?:
//                    message = "Face ID/Touch ID is not set up."
//                case LAError.biometryLockout?:
//                    message = "Face ID/Touch ID is locked."
                default:
                    message = "Face ID/Touch ID may not be configured"
                }
                completion(message)                            }
        }
    }
    
    
    
    
}//end class

