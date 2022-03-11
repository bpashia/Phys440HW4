//
//  ContentView.swift
//  Shared
//
//  Created by Broc Pashia on 2/25/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var potential = Potential(doInit: true)
    @ObservedObject var dataClass = PlotDataClass(fromLine:true)
    @ObservedObject var rk4 = RungeKutta()
    enum Display: String, CaseIterable, Identifiable {
        case potential, waveEq, functional
        var id: Self { self }
    }

    @State private var selectedDisplay: Display = .potential
    @State private var selectedEigenEnergy: Int = 0
    @State private var selectedPotential: String = "Square Well"

    var potentials: [String] = ["Square Well", "Linear Well", "Parabolic Well","Square + Linear Well", "Square Barrier","Triangle Barrier", "Coupled Parabolic Well", "Coupled Square Well + Field" ]
    
    var body: some View {
        VStack{
        List {
            Picker("Potential", selection: $selectedPotential) {
                ForEach(potentials, id: \.self) {
                    Text($0).tag($0)
                }.onChange(of: selectedPotential){newVal in onPotentialChange()}
            }
            
            Picker("Display", selection: $selectedDisplay) {
                Text("Potential").tag(Display.potential)
                Text("Functional").tag(Display.functional)
                Text("Wave Function").tag(Display.waveEq)
                
            }
            if (selectedDisplay==Display.waveEq){
                Picker("Energy", selection: $selectedEigenEnergy) {
                    ForEach(0..<rk4.eigenEnergies.count, id: \.self) { i in
                        Text("\(rk4.eigenEnergies[i].formatted(.number.grouping(.never)))").tag(i)
                    }
                }
                    
                
            }
            Button("Submit", action: {selectedDisplay == Display.potential ? calculateSquareWellPotential() : selectedDisplay == Display.waveEq ? calculateSquareWellWaveFunction() : calculateFunctional()})
            Text("Submit with Display set to Potential to initialize. Then submit with Display set to Functional. This will take a while as it calculates the eigenenergies from 0 - 100. Finally submit with Display set to Wave Function with an eigenenergy value selected.").foregroundColor(SwiftUI.Color.red)
        }

        }
        
        CorePlot(dataForPlot: selectedDisplay == Display.potential ? $potential.contentArray : selectedDisplay == Display.waveEq ? $rk4.waveEquationContentArray : $rk4.functionalContentArray, changingPlotParameters: $dataClass.changingPlotParameters).padding([.top], -200)
//        CorePlot(dataForPlot: $rk4.contentArray, changingPlotParameters: $dataClass.changingPlotParameters)

    }
    func onPotentialChange(){
        rk4.eigenEnergies=[]
        rk4.functionalContentArray=[]
        rk4.waveEquationContentArray=[]
        potential.getPotential(potentialType: selectedPotential, xMin: 0, xMax: 10, xStep: 0.01, dataClass: dataClass)
    }
    
    func calculateSquareWellPotential(){
        dataClass.changingPlotParameters.xMax = 10.0
        
        dataClass.changingPlotParameters.yMax = 10.0
        dataClass.changingPlotParameters.lineColor = .green()
        dataClass.changingPlotParameters.title = "Potential"
        potential.getPotential(potentialType: selectedPotential, xMin: 0, xMax: 10, xStep: 0.01, dataClass: dataClass
        )
       
}
    func calculateSquareWellWaveFunction(){
        dataClass.changingPlotParameters.xMax = 10.0
        dataClass.changingPlotParameters.yMax = 1.0
        dataClass.changingPlotParameters.lineColor = .green()

        let Energy = rk4.eigenEnergies[selectedEigenEnergy]
        dataClass.changingPlotParameters.title = String(format:"Wave Function: %2.4f",Energy)

        print("Selected: " + String(selectedEigenEnergy) + " " + String(Energy))
        
        
        rk4.rk4(x0:0.0, h:0.1, energy: Energy, xMax:10.0, potential: potential)
//        print(rk4.contentArray)
}
    
    func calculateFunctional(){
        dataClass.changingPlotParameters.lineColor = .green()
        dataClass.changingPlotParameters.xMax = 100.0
        dataClass.changingPlotParameters.yMax = 1.0
        dataClass.changingPlotParameters.title = "Functional"


        rk4.calculateFunctional(x0:0.0, h:0.1, xMax:10.0, potential: potential)
//        print(rk4.contentArray)
}

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
