//  
//  CartDetailVM.swift
//  stationery
//
//  Created by Codigo NOL on 02/01/2021.
//

import Foundation

protocol CartDetailVMBusinessLogic {
    // func getData()
}

class CartDetailVM: CartDetailVMBusinessLogic {

    weak var viewController: CartDetailDisplayLogic?
    var worker = CartDetailWorker()

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
