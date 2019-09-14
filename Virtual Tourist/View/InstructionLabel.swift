//
//  InstructionLabel.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-14.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit

class InstructionLabel: UILabel {

	enum InstructionLabels: String {
		case longPress = "Long press to add new travel location"
		case release = "Release finger to add pin"
		case downloading = "Downloading Map Information"
	}

	func setInstructionLabel(_ label: InstructionLabels){
		self.text = label.rawValue
	}

}
