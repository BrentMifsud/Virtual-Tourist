//
//  InstructionLabel.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-14.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit


/// This class controls the PinViewController's Instruction Label
class InstructionLabel: UILabel {

	/// The various states for the instruction label.
	enum LabelState: String {
		case readyForNewPin = "Long press to add new travel location"
		case releaseToAddPin = "Release finger to add pin"
	}


	/// Populate Instruction Label based on its state.
	/// - Parameter label: Instruction Label State
	func setState(_ label: LabelState){
		text = label.rawValue
	}

}
