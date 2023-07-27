//
//  ContentView.swift
//  EazyTender
//
//  Created by Kumar Sharma on 26/07/23.
//

import SwiftUI

struct SalesRefundPayoutView: View {
    @State private var selectedOption = 0
    @State private var amount: String = ""
    @State private var selectedCustomer: String = ""
    @State private var calculatorDisplay: String = ""
    @State private var searchText: String = ""
    @State private var isPickerVisible = false
    @State private var amountTitle: String = "Sale Amount"
    @State private var selectedCustomerName: String = "Adam Elliot"
    
    private let customers = ["Customer A", "Customer B", "Customer C"]
    var filteredCustomers: [String] {
            searchText.isEmpty ? customers : customers.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    var body: some View {
        VStack {
            Picker(selection: $selectedOption, label: Text("Options")) {
                Text("Sale").tag(0)
                Text("Refund").tag(1)
                Text("Payout").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color(hex: 0x93C6E7))
            .tint(Color(hex: 0x00425A))
            .font(.largeTitle)
            .onChange(of: selectedOption, perform: { value in
                                    
                if selectedOption == 0 {
                    
                    amountTitle = "Sale Amount"
                } else if selectedOption == 1 {
                    
                    amountTitle = "Refund Amount"
                } else {
                    
                    amountTitle = "Payout Amount"
                }
            })

            VStack {
                Text(amountTitle).foregroundColor(Color(hex: 0x00425A)).font(.headline)
                TextField("Enter amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .disabled(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color(hex: 0xFEDEFF))
            }
            .padding()
            
            HStack {
                
                Text("Customer:").foregroundColor(Color(hex: 0x00425A)).font(.headline)
                Text("\(selectedCustomerName)")
                Button(action: {
                                isPickerVisible = true
                            }) {
                                Text("Select Customer")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                            .popover(isPresented: $isPickerVisible, content: {
                                VStack {
                                    SearchBar(text: $searchText)
                                    List(filteredCustomers, id: \.self) { customer in
                                        Button(action: {
                                            selectedCustomer = customer
                                            isPickerVisible = false
                                        }) {
                                            Text(customer)
                                        }
                                    }
                                }
                                .frame(
                                    width:UIScreen.main.bounds.width,
                                    height:UIScreen.main.bounds.height-150
                                 )
                                .padding()
                            })
            }

            
            CalculatorView(displayText: $calculatorDisplay, onAmountEntered: { newAmount in
                           amount = newAmount
                       })
            
            HStack(spacing: 20) {
                Button("Cash") {
                    // Add your logic for cash payment here
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .fixedSize(horizontal: true, vertical: true)

                Button("Card") {
                    // Add your logic for card payment here
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
            }
            
            .padding()
        }
//        .accentColor(Color.black)
        .background(Color(hex: 0xAEE2FF))
    }
}

struct CalculatorView: View {
    @Binding var displayText: String
    @State private var lastOpSelected: String = ""
    var onAmountEntered: (String) -> Void
    @State private var firstNumber: Double = 0
    @State private var secondNumber: Double = 0
    @State private var shouldInvalidateFirstNumber = false

    private let calculatorButtons = [
        "1", "2", "3",
        "4", "5", "6",
        "7", "8", "9",
        "0", ".", "=",
        "C", "<", "+", "-"
    ]

    var body: some View {
        VStack {
//            Text("Calculator")
//                .font(.headline)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 5) {
                ForEach(calculatorButtons, id: \.self) { buttonTitle in
                    Button(action: {
                        if buttonTitle == "=" {
                            
                            if let number = Double(displayText) {
                                
                                secondNumber = number
                            }
                            
                            if lastOpSelected == "+" {
                                
                                let sum = firstNumber + secondNumber
                                displayText = "\(sum)"
                            } else if lastOpSelected == "-" {
                                
                                let sum = firstNumber - secondNumber
                                displayText = "\(sum)"
                            }
                            
                        } else if buttonTitle == "C" {
                            
                            lastOpSelected = ""
                            displayText = ""
                        } else if buttonTitle == "<" {
                            displayText = ""
                        } else if buttonTitle == "." {
                            
                            if shouldInvalidateFirstNumber {
                                
                                displayText = ""
                            }
                            shouldInvalidateFirstNumber = false
                            if !displayText.contains(".") {
                                
                                displayText += "."
                            }
                        } else if buttonTitle == "+" {
                            
                            if let number = Double(displayText) {
                                
                                
                                if lastOpSelected == "+" {
                                    
                                    firstNumber += number
                                    displayText = "\(firstNumber)"
                                } else if lastOpSelected == "-" {
                                    
                                    firstNumber -= number
                                    displayText = "\(firstNumber)"
                                } else {
                                
                                    firstNumber = number
                                }
                            }
                            lastOpSelected = "+"
                            shouldInvalidateFirstNumber = true
                        } else if buttonTitle == "-" {
                            
                            if let number = Double(displayText) {
                                
                                firstNumber = number
                            }
                            lastOpSelected = "-"
                            shouldInvalidateFirstNumber = true
                        }
                         else {
                             
                             if shouldInvalidateFirstNumber {
                                 
                                 displayText = ""
                             }
                            displayText += buttonTitle
                            shouldInvalidateFirstNumber = false
                        }
                        // Update the amount text field when a numeric button is pressed
                        onAmountEntered(displayText)
                    }) {
                        Text(buttonTitle)
                            .frame(width: 90, height: 75)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .font(.largeTitle)
                    }
                }
            }
        }
        .padding()
    }
}

struct SalesRefundPayoutView_Previews: PreviewProvider {
    static var previews: some View {
        SalesRefundPayoutView()
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $text)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
}
