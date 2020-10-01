//
//  ConsoleIO.swift
//  User
//
//  Created by 12dot on 01.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation

enum OutputType {
  case error
  case standard
}


class ConsoleIO {
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
      switch to {
      case .standard:
        print("\(message)")
      case .error:
        fputs("Error: \(message)\n", stderr)
      }
    }
    
    func printUsage() {

      let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
            
      writeMessage("usage:")
      writeMessage("\(executableName) -a name username phone")
      writeMessage("or")
      writeMessage("\(executableName) -s ")
      writeMessage("or")
      writeMessage("\(executableName) -d number")
      writeMessage("Type \(executableName) without an option to enter interactive mode.")
    }
    
    
    func getInput() -> String {
      let keyboard = FileHandle.standardInput
      let inputData = keyboard.availableData
      let strData = String(data: inputData, encoding: String.Encoding.utf8)!
      return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
    
}
