//  
//  ContactUsVM.swift
//  stationery
//
//  Created by Codigo NOL on 16/01/2021.
//

import Foundation

protocol ContactUsVMBusinessLogic {
     func contactUs(name: String, email: String, title: String, message: String)
}

class ContactUsVM: ContactUsVMBusinessLogic {

    weak var viewController: ContactUsDisplayLogic?
    var worker = ContactUsWorker()

    func contactUs(name: String, email: String, title: String, message: String) {
    
        LoadingView.shared.show()
        
        let request = ContactUsRequest()
        request.fullName = name
        request.email = email
        request.subject = title
        request.message = message
        
        worker.contactUs(request: request, completion: { (_, error) in
            LoadingView.shared.hide()
            if let e = error, !e.isEmpty {
                self.viewController?.didFailContact()
            } else {
                self.viewController?.didSuccessContact()
            }
        })
     }
}
