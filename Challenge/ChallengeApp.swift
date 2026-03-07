//
//  ChallengeApp.swift
//  Challenge
//
//  Created by William Simião on 07/03/26.
//

import SwiftUI

@main
struct ChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            SignUpViewControllerRepresentable()
        }
    }
}

struct SignUpViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SignUpViewController {
        SignUpViewController()
    }
    
    func updateUIViewController(_ uiViewController: SignUpViewController, context: Context) {}
}
