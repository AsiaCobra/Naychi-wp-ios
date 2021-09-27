//  
//  CartAddressVM.swift
//  stationery
//
//  Created by Codigo NOL on 30/12/2020.
//

import Foundation

protocol CartAddressVMBusinessLogic {
}

class CartAddressVM: CartAddressVMBusinessLogic {

    weak var viewController: CartAddressDisplayLogic?
    var worker = CartAddressWorker()

    func getStateInEng(_ picker: PickerView) -> String {
        let selectedState = picker.getSelectedValue() ?? ""
        return AppUtil.shared.currentLanguage == .myanmar ? Region.getStateEng(selectedState) : selectedState
    }
    
    func getTownshipInEng(_ statePicker: PickerView, _ townshipPicker: PickerView) -> String {
        let selectedState = statePicker.getSelectedValue() ?? ""
        let selectedTownship = townshipPicker.getSelectedValue() ?? ""
        
        return AppUtil.shared.currentLanguage == .myanmar ? Region.getTownshipEng(selectedState, selectedTownship) : selectedTownship
    }
}
