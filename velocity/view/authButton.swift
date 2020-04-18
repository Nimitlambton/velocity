//
//  authButton.swift
//  velocity
//
//  Created by Nimit on 2020-04-12.
//  Copyright © 2020 Nimit. All rights reserved.
//

import UIKit

class authButton: UIButton {

 
    override init(frame: CGRect) {
        super.init(frame:frame)
                 setTitleColor(.white, for: .normal)
                 heightAnchor.constraint(equalToConstant: 50)
                 backgroundColor = .red

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
