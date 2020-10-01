//
//  File.swift
//  CollectionLikeTable
//
//  Created by 12dot on 24.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation


func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

func randomLength(max : Int) -> Int {
    let random = Int.random(in: 50...max)
    return random
}
