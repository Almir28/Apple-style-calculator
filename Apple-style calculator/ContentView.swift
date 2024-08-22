//
//  ContentView.swift
//  Apple-style calculator
//
//  Created by Almir Khialov on 22.08.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var display: String = "0"
    @State private var firstNumber: Double = 0
    @State private var currentOperation: String = ""
    @State private var inOperationMode: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let isPortrait = geometry.size.height > geometry.size.width
            
            VStack(spacing: 12) {
                Spacer()
                
                // Экран вывода
                Text(display)
                    .font(.system(size: isPortrait ? 72 : 48))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                
                // Кнопки калькулятора
                VStack(spacing: 12) {
                    if isPortrait {
                        portraitButtons
                    } else {
                        landscapeButtons(geometry)
                    }
                }
                .padding(.bottom)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
    
    // Кнопки для портретного режима
    var portraitButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                CalculatorButton(label: "AC", color: .gray) {
                    clearDisplay()
                }
                CalculatorButton(label: "+/-", color: .gray) {
                    toggleSign()
                }
                CalculatorButton(label: "%", color: .gray) {
                    applyPercentage()
                }
                CalculatorButton(label: "/", color: .orange) {
                    performOperation("/")
                }
            }
            HStack(spacing: 12) {
                CalculatorButton(label: "7") { appendNumber("7") }
                CalculatorButton(label: "8") { appendNumber("8") }
                CalculatorButton(label: "9") { appendNumber("9") }
                CalculatorButton(label: "*", color: .orange) {
                    performOperation("*")
                }
            }
            HStack(spacing: 12) {
                CalculatorButton(label: "4") { appendNumber("4") }
                CalculatorButton(label: "5") { appendNumber("5") }
                CalculatorButton(label: "6") { appendNumber("6") }
                CalculatorButton(label: "-", color: .orange) {
                    performOperation("-")
                }
            }
            HStack(spacing: 12) {
                CalculatorButton(label: "1") { appendNumber("1") }
                CalculatorButton(label: "2") { appendNumber("2") }
                CalculatorButton(label: "3") { appendNumber("3") }
                CalculatorButton(label: "+", color: .orange) {
                    performOperation("+")
                }
            }
            HStack(spacing: 12) {
                CalculatorButton(label: "0") { appendNumber("0") }
                CalculatorButton(label: ".") { appendDecimal() }
                CalculatorButton(label: "=", color: .orange) {
                    calculateResult()
                }
            }
        }
    }
    
    // Кнопки для ландшафтного режима
    func landscapeButtons(_ geometry: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                CalculatorButton(label: "AC", color: .gray, width: buttonWidth(geometry, 5)) {
                    clearDisplay()
                }
                CalculatorButton(label: "+/-", color: .gray, width: buttonWidth(geometry, 5)) {
                    toggleSign()
                }
                CalculatorButton(label: "%", color: .gray, width: buttonWidth(geometry, 5)) {
                    applyPercentage()
                }
                CalculatorButton(label: "/", color: .orange, width: buttonWidth(geometry, 5)) {
                    performOperation("/")
                }
                CalculatorButton(label: "*", color: .orange, width: buttonWidth(geometry, 5)) {
                    performOperation("*")
                }
            }
            HStack(spacing: 12) {
                CalculatorButton(label: "7", width: buttonWidth(geometry, 5)) { appendNumber("7") }
                CalculatorButton(label: "8", width: buttonWidth(geometry, 5)) { appendNumber("8") }
                CalculatorButton(label: "9", width: buttonWidth(geometry, 5)) { appendNumber("9") }
                CalculatorButton(label: "-", color: .orange, width: buttonWidth(geometry, 5)) {
                    performOperation("-")
                }
                CalculatorButton(label: "+", color: .orange, width: buttonWidth(geometry, 5)) {
                    performOperation("+")
                }
            }
            HStack(spacing: 12) {
                CalculatorButton(label: "4", width: buttonWidth(geometry, 5)) { appendNumber("4") }
                CalculatorButton(label: "5", width: buttonWidth(geometry, 5)) { appendNumber("5") }
                CalculatorButton(label: "6", width: buttonWidth(geometry, 5)) { appendNumber("6") }
                CalculatorButton(label: "1", width: buttonWidth(geometry, 5)) { appendNumber("1") }
                CalculatorButton(label: "2", width: buttonWidth(geometry, 5)) { appendNumber("2") }
            }
            HStack(spacing: 12) {
                CalculatorButton(label: "3", width: buttonWidth(geometry, 5)) { appendNumber("3") }
                CalculatorButton(label: "0", width: buttonWidth(geometry, 5)) { appendNumber("0") }
                CalculatorButton(label: ".", width: buttonWidth(geometry, 5)) { appendDecimal() }
                CalculatorButton(label: "=", color: .orange, width: buttonWidth(geometry, 5)) {
                    calculateResult()
                }
            }
        }
    }
    
    // Логика калькулятора
    func appendNumber(_ number: String) {
        if inOperationMode {
            display = number
            inOperationMode = false
        } else {
            display = display == "0" ? number : display + number
        }
    }
    
    func appendDecimal() {
        if !display.contains(".") {
            display += "."
        }
    }
    
    func clearDisplay() {
        display = "0"
        firstNumber = 0
        currentOperation = ""
    }
    
    func toggleSign() {
        if let value = Double(display) {
            display = String(value * -1)
        }
    }
    
    func applyPercentage() {
        if let value = Double(display) {
            display = String(value / 100)
        }
    }
    
    func performOperation(_ operation: String) {
        firstNumber = Double(display) ?? 0
        currentOperation = operation
        inOperationMode = true
    }
    
    func calculateResult() {
        guard let secondNumber = Double(display) else { return }
        
        var result: Double = 0
        
        switch currentOperation {
        case "+":
            result = firstNumber + secondNumber
        case "-":
            result = firstNumber - secondNumber
        case "*":
            result = firstNumber * secondNumber
        case "/":
            if secondNumber != 0 {
                result = firstNumber / secondNumber
            } else {
                display = "Error"
                return
            }
        default:
            return
        }
        
        display = String(result)
        inOperationMode = false
    }
    
    // Подсчет ширины кнопок в зависимости от количества колонок
    func buttonWidth(_ geometry: GeometryProxy, _ columns: CGFloat) -> CGFloat {
        return (geometry.size.width - (columns + 1) * 12) / columns
    }
}

struct CalculatorButton: View {
    let label: String
    var color: Color = .gray
    var width: CGFloat? = 80
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.largeTitle)
                .frame(width: width, height: 80)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(40)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
        
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
