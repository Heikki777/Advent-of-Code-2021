//
//  main.swift
//  AdventOfCode2024_Day3
//
//  Created by Hämälistö Heikki on 3.12.2024.
//

import Foundation
import RegexBuilder

func readLines(fromFile file: String) -> [String] {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            var lines = content.components(separatedBy: .newlines)
            
            // Remove any trailing empty line
            if let lastLine = lines.last, lastLine.isEmpty {
                lines.removeLast()
            }
            
            return lines
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    
    return []
}

let lines = readLines(fromFile: "input")

func part1() {
    let intCapture = TryCapture {
        OneOrMore(.digit)
    } transform: {
        Int($0)
    }
    
    let pattern = Regex {
        "mul("
        intCapture
        ","
        intCapture
        ")"
    }
    let result = lines.reduce(into: 0) { lineResult, line in
        let matches = line.matches(of: pattern)
        lineResult += matches.reduce(into: 0) { partialResult, match in
            partialResult += match.output.1 * match.output.2
        }
    }
    print("Part 1:", result)
}

func part2() {
    let intCapture = TryCapture {
        OneOrMore(.digit)
    } transform: {
        Int($0)
    }
    
    let pattern = Regex {
        ChoiceOf {
            Regex {
                "mul("
                intCapture
                ","
                intCapture
                ")"
            }
            "do()"
            "don't()"
        }
    }
    var isEnabled = true
    let result = lines.reduce(into: 0) { lineResult, line in
        let matches = line.matches(of: pattern)
        lineResult += matches.reduce(into: 0) { partialResult, match in
            if match.output.0 == "don't()" {
                isEnabled = false
            } else if match.output.0 == "do()" {
                isEnabled = true
            } else if isEnabled, let firstInt = match.output.1, let secondInt = match.output.2 {
                partialResult += firstInt * secondInt
            }
        }
    }
    print("Part 2:", result)
}

part1()
part2()

