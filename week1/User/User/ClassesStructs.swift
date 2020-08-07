//
//  ClassesStructs.swift
//  User
//
//  Created by 12dot on 01.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation


enum OptionType: String {
    case add = "a"
    case show = "s"
    case delete = "d"
    case help = "h"
    case quit = "q"
    
    case unknown
      
    init(value: String) {
        switch value {
        case "a": self = .add
        case "s": self = .show
        case "d": self = .delete
        case "h": self = .help
        case "q": self = .quit
        default: self = .unknown
        }
      }
}

class UserComposer {

    let consoleIO = ConsoleIO()
    lazy var userArray = [User]()

    func staticMode() {
        let argCount = CommandLine.argc
        let argument = CommandLine.arguments[1]
        let (option, value) = getOption(String(argument.suffix(from: argument.index(argument.startIndex, offsetBy: 1))))
        
        switch option {
        case .add:
            if argCount != 5 {
                if argCount > 5 {
                    consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
                } else {
                    consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
                }
                consoleIO.printUsage()
            } else {
                let name = CommandLine.arguments[2]
                let surname = CommandLine.arguments[3]
                let phone = CommandLine.arguments[4]
                userArray.append(User(name: name, surname: surname, phone: phone))
                consoleIO.writeMessage("User was successfully added")
                var i = 0
                for user in userArray {
                    i+=1
                    consoleIO.writeMessage("\(i). \(user.name) \(user.surname) \(user.phone)")
                }
            }
        case .show:
            if argCount != 2 {
                if argCount > 2 {
                    consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
                } else {
                    consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
                }
                consoleIO.printUsage()
            } else {
                if userArray.isEmpty{
                    consoleIO.writeMessage("There are no users")
                    consoleIO.printUsage()
                }else{
                    consoleIO.writeMessage("User list:")
                    var i = 0
                    for user in userArray {
                        consoleIO.writeMessage("\(i+=1). \(user.name) \(user.surname) \(user.phone)")
                    }
                }
                //consoleIO.writeMessage("\(s) is \(isPalindrome ? "" : "not ")a palindrome")
            }
        case .delete:
            if argCount != 3{
                if argCount > 3 {
                    consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
                } else {
                    consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
                }
                consoleIO.printUsage()
            }else{
                let counter = Int(CommandLine.arguments[2]) ?? 0
                if counter <= 0 && counter > userArray.count {
                    consoleIO.writeMessage("Invalid number")
                    consoleIO.printUsage()
                }else{
                    userArray.remove(at: counter-1)
                    consoleIO.writeMessage("User was successfully deleted")
                }
            }
        case .help:
            consoleIO.printUsage()
        case .unknown, .quit:
            consoleIO.writeMessage("Unknown option \(value)")
            consoleIO.printUsage()
        }
        
    }
    
    func interactiveMode() {
        consoleIO.writeMessage("This is 65apps's first task.")
        var isEnding = false
    
        while !isEnding{
            consoleIO.writeMessage("You can add user if you print -a, show all users if you print -s, delete user by its number if you print -d. If you want to end task, print -q then.")
            let (option, value) = getOption(consoleIO.getInput())
            
            switch option {
            case .add:
                consoleIO.writeMessage("Write it's name: ")
                let name = consoleIO.getInput()
                consoleIO.writeMessage("Write it's surnamename: ")
                let surname = consoleIO.getInput()
                consoleIO.writeMessage("Write it's phone: ")
                let phone = consoleIO.getInput()
                userArray.append(User(name: name, surname: surname, phone: phone))
                consoleIO.writeMessage("User was successfully added")
            case .show:
                if userArray.isEmpty{
                    consoleIO.writeMessage("There are no users")
                    consoleIO.printUsage()
                }else{
                    consoleIO.writeMessage("User list:")
                    var i = 0
                    for user in userArray {
                        i+=1
                        consoleIO.writeMessage("\(i). \(user.name) \(user.surname) \(user.phone)")
                    }
                }
            case .delete:
                consoleIO.writeMessage("Write user's number: ")
                let counter = Int(consoleIO.getInput()) ?? 0
                if counter <= 0 && counter > userArray.count {
                    consoleIO.writeMessage("Invalid number")
                    consoleIO.printUsage()
                }else{
                    userArray.remove(at: counter-1)
                    consoleIO.writeMessage("User was successfully deleted")
                }
            
            case .quit:
                isEnding = true
            default:
                consoleIO.writeMessage("Unknown option \(value)", to: .error)
            }
        }
    }
    
        
    func getOption(_ option: String) -> (option:OptionType, value: String) {
      return (OptionType(value: option), option)
    }
    

}


struct User {
    
    let name : String
    let surname : String
    let phone : String
    
    init (name : String, surname: String,  phone : String) {
        self.name = name
        self.surname = surname
        self.phone = phone
    }
    
}
