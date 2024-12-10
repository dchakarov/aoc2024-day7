//
//  main.swift
//  No rights reserved.
//

import Foundation

struct Calibration {
    let leftSide: Int
    let rightSide: [Int]
}

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }
    
    var calibrations: [Calibration] = []
    
    lines.forEach { line in
        let components = line.components(separatedBy: ":")
        let left = Int(components[0].trimmingCharacters(in: .whitespacesAndNewlines))!
        let subcomp = components[1].components(separatedBy: " ")
        let right = subcomp.compactMap { Int($0) }
        calibrations.append(Calibration(leftSide: left, rightSide: right))
    }
    
    let operators = ["+", "*"]
    let result = calibrations.filter { isTrueEquation($0, operators: operators) }.reduce(0) { $0 + $1.leftSide }
    
    print(result)
    
    let operators2 = ["+", "*", "||"]
    let result2 = calibrations.filter { isTrueEquation($0, operators: operators2) }.reduce(0) { $0 + $1.leftSide }
    
    print(result2)
}

func isTrueEquation(_ calibration: Calibration, operators: [String]) -> Bool {
    let operatorCount = calibration.rightSide.count - 1
    
    let permutations = permutationsWithRepetition(elements: operators, length: operatorCount)
    
    for permutation in permutations {
        let result = executeAllOperators(numbers: calibration.rightSide, operators: permutation)
        
        if result.numbers[0] == calibration.leftSide {
            return true
        }
    }

    return false
}

func executeAllOperators(numbers: [Int], operators: [String]) -> (numbers: [Int], operators: [String]) {
    if operators.isEmpty {
        return (numbers, operators)
    }
    
    var operators = operators
    var numbers = numbers
    
    let op = operators.removeFirst()
    let first = numbers.removeFirst()
    let second = numbers.removeFirst()
    let number = executeOperator(first, second, op)
    numbers.insert(number, at: 0)

    return executeAllOperators(numbers: numbers, operators: operators)
}

func executeOperator(_ left: Int, _ right: Int, _ op: String) -> Int {
    switch op {
    case "+":
        return left + right
    case "*":
        return left * right
    case "||":
        return Int("\(left)\(right)")!
    default: fatalError()
    }
}

func permutationsWithRepetition<T>(elements: [T], length: Int) -> [[T]] {
    guard length > 0 else {
        return [[]]
    }
    
    let subPermutations = permutationsWithRepetition(elements: elements, length: length - 1)
    
    var result: [[T]] = []
    for element in elements {
        for subPermutation in subPermutations {
            result.append([element] + subPermutation)
        }
    }
    
    return result
}

main()
