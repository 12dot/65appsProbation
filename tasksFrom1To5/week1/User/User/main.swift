//
//  main.swift
//  User
//
//  Created by 12dot on 01.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation


let userComposer = UserComposer()

if CommandLine.argc < 2 {
    userComposer.interactiveMode()
} else {
    userComposer.staticMode()
}
