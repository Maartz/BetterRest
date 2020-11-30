//
//  ContentView.swift
//  BetterRest
//
//  Created by William Martin on 26/11/2020.
//

import SwiftUI

struct ContentView: View {
  @State private var wakeUp = defaultWakeTime
  @State private var sleepAmount = 8.0
  @State private var coffeeAmount = 1
  
  @State private var alertTitle = ""
  @State private var alertMessage = "00:00 AM"
  @State private var showingAlert = false
  
  static var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
  }
  
  func calculateBedTime() -> String {
    let model = SleepCalculator()
    let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
    let hour = (components.hour ?? 0) * 60 * 60
    let minute = (components.minute ?? 0) * 60
    
    var bedTime = ""
    
    do {
      let prediction = try model.prediction(
        wake: Double(hour + minute),
        estimatedSleep: sleepAmount,
        coffee: Double(coffeeAmount)
      )
      let sleepTime = wakeUp - prediction.actualSleep
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      bedTime = formatter.string(from: sleepTime)
      
    } catch {
      bedTime = "Error"
    }
    return bedTime
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Text("Your ideal bedtime is…")
            .font(.headline)
          Text(calculateBedTime()).font(.title)
        }
        
        Text("When do you want to wake up?")
          .font(.headline)
        
        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
          .labelsHidden()
          .datePickerStyle(WheelDatePickerStyle())
        
        Section {
          Text("Desired amount of sleep")
            .font(.headline)
          
          
          Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
            Text("\(sleepAmount, specifier: "%g") hours")
          }
        }
        
        Section {
          Text("Daily coffee intake")
            .font(.headline)
          
          Picker("Cup of coffee",
                 selection: $coffeeAmount) {
            ForEach(1..<21) {
              if $0 == 1 {
                Text("\($0.description) cup").tag($0)
              } else {
                Text("\($0.description) cups").tag($0)
              }
            }
          }.pickerStyle(InlinePickerStyle()
          )
        }
      }
      .navigationBarTitle("BetterRest")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
