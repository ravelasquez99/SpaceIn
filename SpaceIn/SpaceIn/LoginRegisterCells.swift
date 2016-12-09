//
//  LoginRegisterCells.swift
//  SpaceIn
//
//  Created by Richard Velazquez on 12/8/16.
//  Copyright © 2016 Ricky. All rights reserved.
//

import UIKit

class LoginRegisterCell: UITableViewCell {
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class RoundedButtonCell: LoginRegisterCell {
    
}

class TextCell: LoginRegisterCell {
    
}

class TextFieldCell: LoginRegisterCell {
    
}


