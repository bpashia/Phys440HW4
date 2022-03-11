//
//  SquarePotential.swift
//  Phys440HW4
//
//  Created by Broc Pashia on 2/25/22.
//

import Foundation

class Potential: NSObject, ObservableObject{
    
    
@MainActor @Published var contentArray:[plotDataType]=[]
@Published var potFunction: (Double) -> Double
    
    init(doInit:Bool){
        func initialPotFunc (x:Double)->Double{return x}
        potFunction = initialPotFunc
    }

@MainActor func getPotential(potentialType: String, xMin: Double, xMax: Double, xStep: Double, dataClass: PlotDataClass){
    contentArray = []
    var oneDPotentialXArray:[Double] = []
    var oneDPotentialYArray:[Double] = []
    var count = 0
    var dataPoint: plotDataType = [:]
    
    switch potentialType{
    
    case "Linear Well":

    func linearWellPotFunc(x:Double)->Double{
           if(x < xMax && x > xMin){
               return (x-xMin) * 4.0 * 1.3
           }
           else{
               return pow(10,5)
           }
       }
       potFunction = linearWellPotFunc
    for i in stride(from: xMin+xStep, through: xMax-xStep, by: xStep) {

                   oneDPotentialXArray.append(i)
                   oneDPotentialYArray.append((i-xMin)*4.0*1.3)
                   //oneDPotentialYArray.append((i-xMin)*0.25)

                   count = oneDPotentialXArray.count
                   dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                   contentArray.append(dataPoint)

    }
        
    case "Parabolic Well":
        func parabolicWellPotFunc(x:Double)->Double{
               if(x < xMax && x > xMin){
                   return pow((x-(xMax+xMin))/2.0, 2.0)
               }
               else{
                   return pow(10,3)
               }
           }
           potFunction = parabolicWellPotFunc
    for i in stride(from: xMin+xStep, through: xMax-xStep, by: xStep) {
    
                   oneDPotentialXArray.append(i)
                    oneDPotentialYArray.append((pow((i-(xMax+xMin)/2.0), 2.0)/1.0))
    
                    count = oneDPotentialXArray.count
                    dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                    contentArray.append(dataPoint)
    
                }
        
    
    
    case "Square + Linear Well":
        
        func squareLinearWellPotFunc(x:Double)->Double{
               if( x > xMin && x < (xMax+xMin)/2.0){
                   return 0
               }else if( x < xMax && x > (xMax+xMin)/2.0){
                   return (x-(xMin+xMax)/2.0)*4.0*0.1
               }
               else{
                   return pow(10,3)
               }
           }
           potFunction = squareLinearWellPotFunc
        
    for i in stride(from: xMin+xStep, to: (xMax+xMin)/2.0, by: xStep) {

                    oneDPotentialXArray.append(i)
                    oneDPotentialYArray.append(0.0)

                    count = oneDPotentialXArray.count
                    dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                    contentArray.append(dataPoint)

                }
    for i in stride(from: (xMin+xMax)/2.0, through: xMax-xStep, by: xStep) {

                    oneDPotentialXArray.append(i)
                    oneDPotentialYArray.append(((i-(xMin+xMax)/2.0)*4.0*0.1))

                    count = oneDPotentialXArray.count
                    dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                    contentArray.append(dataPoint)

                }
    
case "Square Barrier":
        
        func squareBarrierPotFunc(x:Double)->Double{
               if( x > xMin && x < (xMin + (xMax-xMin)*0.4)){
                   return 0
               }else if( x < xMax && x > xMin + (xMax-xMin)*0.6){
                   return 0
               } else if (x < xMin + (xMax-xMin)*0.6 && x > (xMin + (xMax-xMin)*0.4)){
                return 15.00000000
               }
               else{
                   return pow(10,3)
               }
           }
           potFunction = squareBarrierPotFunc


            for i in stride(from: xMin+xStep, to: xMin + (xMax-xMin)*0.4, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append(0.0)

                count = oneDPotentialXArray.count
                dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                contentArray.append(dataPoint)

            }

            for i in stride(from: xMin + (xMax-xMin)*0.4, to: xMin + (xMax-xMin)*0.6, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append(15.000000001)

                count = oneDPotentialXArray.count
                dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                contentArray.append(dataPoint)

            }

            for i in stride(from: xMin + (xMax-xMin)*0.6, to: xMax, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append(0.0)

                count = oneDPotentialXArray.count
                dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                contentArray.append(dataPoint)
            }
case "Triangle Barrier":

        func triBarrierPotFunc(x:Double)->Double{
               if( x > xMin && x < (xMin + (xMax-xMin)*0.4)){
                   return 0
               }else if( x < xMax && x > xMin + (xMax-xMin)*0.6){
                   return 0
               } else if (x < xMin + (xMax-xMin)*0.5 && x > (xMin + (xMax-xMin)*0.4)){
                return abs(x - (xMin + (xMax-xMin)*0.4))*3.0
               }else if (x < xMin + (xMax-xMin)*0.6 && x > (xMin + (xMax-xMin)*0.5)){
                   return abs(x - (xMax - (xMax-xMin)*0.4))*3.0
                  }
               else {
                   return pow(10,3)
               }
           }
           potFunction = triBarrierPotFunc

            for i in stride(from: xMin+xStep, to: xMin + (xMax-xMin)*0.4, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append(0.0)

                count = oneDPotentialXArray.count
                dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                contentArray.append(dataPoint)
            }

            for i in stride(from: xMin + (xMax-xMin)*0.4, to: xMin + (xMax-xMin)*0.5, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append((abs(i-(xMin + (xMax-xMin)*0.4))*3.0))

                count = oneDPotentialXArray.count
                dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                contentArray.append(dataPoint)

            }

            for i in stride(from: xMin + (xMax-xMin)*0.5, to: xMin + (xMax-xMin)*0.6, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append((abs(i-(xMax - (xMax-xMin)*0.4))*3.0))

                count = oneDPotentialXArray.count
                dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                contentArray.append(dataPoint)

            }

            for i in stride(from: xMin + (xMax-xMin)*0.6, to: xMax, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append(0.0)

                count = oneDPotentialXArray.count
                dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                contentArray.append(dataPoint)
            }
case "Coupled Parabolic Well":

        func coupledParabolicPotFunc(x:Double)->Double{
               if( x > xMin && x < (xMin + (xMax-xMin)*0.5)){
                   return pow((x-(xMin+(xMax-xMin)/4.0)), 2.0)
               }else if( x < xMax && x > xMin + (xMax-xMin)*0.5){
                   return pow((x-(xMax-(xMax-xMin)/4.0)), 2.0)
               }
               else {
                   return pow(10,3)
               }
           }
           potFunction = coupledParabolicPotFunc

            for i in stride(from: xMin+xStep, to: xMin + (xMax-xMin)*0.5, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append((pow((i-(xMin+(xMax-xMin)/4.0)), 2.0)))

                count = oneDPotentialXArray.count
                dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                contentArray.append(dataPoint)
            }

            for i in stride(from: xMin + (xMax-xMin)*0.5, through: xMax-xStep, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append((pow((i-(xMax-(xMax-xMin)/4.0)), 2.0)))

                count = oneDPotentialXArray.count
                dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
                contentArray.append(dataPoint)

            }

case "Coupled Square Well + Field":

        func coupledSqWellFieldPotFunc(x:Double)->Double{
               if( x > xMin && x < (xMin + (xMax-xMin)*0.4)){
                   return 0.0
               }else if( x < xMax && x > xMin + (xMax-xMin)*0.6){
                   return 0
               }else if( x < xMin + (xMax-xMin)*0.6 && x > xMin + (xMax-xMin)*0.4){
                   return 4.0 + (x-xMin)*4.0*0.1
               }
               else {
                   return pow(10,3)
               }
           }
           potFunction = coupledSqWellFieldPotFunc
        

            for i in stride(from: xMin+xStep, to: xMin + (xMax-xMin)*0.4, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append(0.0)

            }

            for i in stride(from: xMin + (xMax-xMin)*0.4, to: xMin + (xMax-xMin)*0.6, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append(4.0)

            }

            for i in stride(from: xMin + (xMax-xMin)*0.6, to: xMax, by: xStep) {

                oneDPotentialXArray.append(i)
                oneDPotentialYArray.append(0.0)

            }

            for i in 1 ..< (oneDPotentialXArray.count) {

                oneDPotentialYArray[i] += ((oneDPotentialXArray[i]-xMin)*4.0*0.1)
                dataPoint = [.X: oneDPotentialXArray[i], .Y: oneDPotentialYArray[i]]
                contentArray.append(dataPoint)
            }

    
//Harmonic Oscillator
//    let xMinHO = -20.0
//               let xMaxHO = 20.0
//               let xStepHO = 0.001
//        dataClass.changingPlotParameters.xMin = -20.0
//        dataClass.changingPlotParameters.yMin = 0.0
//        dataClass.changingPlotParameters.xMax = 20.0
//        dataClass.changingPlotParameters.yMax = 20.0
//
//
//               for i in stride(from: xMinHO+xStepHO, through: xMaxHO-xStepHO, by: xStepHO) {
//
//                   oneDPotentialXArray.append(i+xMaxHO)
//                   oneDPotentialYArray.append((pow((i-(xMaxHO+xMinHO)/2.0), 2.0)/15.0))
//
//                   count = oneDPotentialXArray.count
//                   dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
//                   contentArray.append(dataPoint)
//               }
default:
func squareWellPotFunc(x:Double)->Double{
    if(x <= xMax && x >= xMin){
        return 0.0
    }
    else{
        return pow(10,5)
    }
}
potFunction = squareWellPotFunc

for i in stride(from: xMin+xStep, through: xMax-xStep, by: xStep) {

    oneDPotentialXArray.append(i)
    oneDPotentialYArray.append(0.0)

    count = oneDPotentialXArray.count
    dataPoint = [.X: oneDPotentialXArray[count-1], .Y: oneDPotentialYArray[count-1]]
    contentArray.append(dataPoint)
}}
}
}
