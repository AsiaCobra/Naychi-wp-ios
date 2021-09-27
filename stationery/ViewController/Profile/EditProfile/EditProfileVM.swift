//  
//  EditProfileVM.swift
//  stationery
//
//  Created by Codigo NOL on 13/01/2021.
//

import Foundation

protocol EditProfileVMBusinessLogic {
    // func getData()
}

class EditProfileVM: EditProfileVMBusinessLogic {

    weak var viewController: EditProfileDisplayLogic?
    var worker = EditProfileWorker()

    func update(id: String, name: String, country: String, state: String, township: String, address: String,
                mobile: String, email: String) {
        
        let request = CustomerRequest()
        request.username = nil
        request.password = nil
        request.firstName = name
        request.email = email
        
        request.billing = Billing()
        request.billing?.firstName = name
        request.billing?.country = "Myanmar"
        request.billing?.address1 = address
        request.billing?.state = state
        request.billing?.city = township
        request.billing?.phone = mobile
        request.billing?.email = email
        
        request.shipping = Shipping()
        request.shipping?.firstName = name
        request.shipping?.country = "Myanmar"
        request.shipping?.address1 = address
        request.shipping?.state = state
        request.shipping?.city = township
        
        LoadingView.shared.show()
        worker.update(id: id, request: request, completion: { (response, _) in
            LoadingView.shared.hide()
            if response != nil {
                self.viewController?.didSuccessUpdate()
            } else {
                self.viewController?.didFailUpdate()
            }
        })
        
    }
    
    func getStateInEng(_ picker: PickerViewWithTitle) -> String {
        let selectedState = picker.getSelectedValue() ?? ""
        return AppUtil.shared.currentLanguage == .myanmar ? Region.getStateEng(selectedState) : selectedState
    }
    
    func getTownshipInEng(_ statePicker: PickerViewWithTitle, _ townshipPicker: PickerViewWithTitle) -> String {
        let selectedState = statePicker.getSelectedValue() ?? ""
        let selectedTownship = townshipPicker.getSelectedValue() ?? ""
        
        return AppUtil.shared.currentLanguage == .myanmar ? Region.getTownshipEng(selectedState, selectedTownship) : selectedTownship
    }    
}
