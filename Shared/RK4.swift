
//  RK4.swift
//  Phys440HW4
//
//  Created by Broc Pashia on 2/25/22.


import Foundation
//
//
//Normalize Equation Afterward
class RungeKutta: NSObject, ObservableObject{
    
    @Published var waveEquationContentArray: [plotDataType]=[]
    @Published var functionalContentArray: [plotDataType]=[]
    @Published var eigenEnergies: [Double]=[]
    
    
   

    let hbar = 6.582119 * pow(10.0,-16)
    
    
    
    func f1(x:Double, psi:Double, psiPrime:Double,energy:Double, potential:Potential)->Double{
        return psiPrime
    }
    
    func f2(x:Double, psi:Double, psiPrime:Double,energy:Double, potential:Potential)->Double{
//        let result = 2.0/7.63 * (potential.potFunction(x) - energy) * psi
        let result = 2.0/7.63 * (potential.potFunction(x) - energy) * psi

        return result
    }
    
    
    func rk4(x0: Double, h:Double,energy:Double, xMax: Double, potential:Potential ) {
        waveEquationContentArray = []
        var tempResults: [(xVal:Double, yVal:Double)]=[]
        let n = Int((xMax-x0)/h)
        let psiInitial = 0.0
        let psiPrimeInitial = 1.0
        var psi = psiInitial
        var psiPrime = psiPrimeInitial
        var k1psi = 0.0
        var k1psiPrime = 0.0
        
        var k2psi = 0.0
        var k2psiPrime = 0.0
        var k3psi = 0.0
        var k3psiPrime = 0.0
        var k4psi = 0.0
        var k4psiPrime = 0.0
        var x = x0
        var sumForNormalization = 0.0
        
        
        for _ in 0...n-1{
            sumForNormalization += pow(psi,2)
            tempResults.append((xVal: x, yVal: psi))
             k1psi = f1(x:x, psi: psi, psiPrime: psiPrime, energy: energy,potential:potential)
             k1psiPrime = f2(x:x, psi: psi, psiPrime: psiPrime, energy: energy,potential:potential)
             k2psi = f1(x:x + h/2.0, psi: psi + h * k1psi * 0.5, psiPrime: psiPrime + h * k1psiPrime * 0.5, energy: energy,potential:potential)
             k2psiPrime = f2(x:x + h/2.0, psi: psi + h * k1psi * 0.5, psiPrime: psiPrime + h * k1psiPrime * 0.5, energy: energy,potential:potential)
             k3psi = f1(x:x + h/2.0, psi: psi + h * k2psi * 0.5, psiPrime: psiPrime + h * k2psiPrime * 0.5, energy: energy,potential:potential)
             k3psiPrime = f2(x:x + h/2.0, psi: psi + h * k2psi * 0.5, psiPrime: psiPrime + h * k2psiPrime * 0.5, energy: energy,potential:potential)
             k4psi = f1(x:x + h, psi: psi + h * k3psi , psiPrime: psiPrime + h * k3psiPrime , energy: energy,potential:potential)
             k4psiPrime = f2(x:x + h, psi: psi + h * k3psi, psiPrime: psiPrime + h * k3psiPrime, energy: energy, potential:potential)
            
            x = x + h
            psi = psi + h/6.0 * (k1psi + 2.0 * k2psi + 2.0 * k3psi + k4psi)
            psiPrime = psiPrime + h/6.0 * (k1psiPrime + 2.0 * k2psiPrime + 2.0 * k3psiPrime + k4psiPrime)
            
        }
        sumForNormalization += pow(psi,2)

        tempResults.append((xVal: x, yVal: psi))
//        print((xVal: x, yVal: psi))
        for i in 0...tempResults.count-1{
            let tempResult = tempResults[i]
//            waveEquationContentArray.append([.X:tempResult.xVal,.Y:tempResult.yVal/sumForNormalization])
            waveEquationContentArray.append([.X:tempResult.xVal,.Y:tempResult.yVal])

        }
    }
    
    func bisect(eMin: Double, eMax:Double, prevFunctionalMaxVal:Double,prevFunctionalMinVal:Double, x0: Double, h:Double, xMax: Double, potential:Potential )->Double{
        print(String(format:"EMin: %.4f , EMax: %.4f, rkMin: %.4f , rkMax: %.4f", eMin,eMax,prevFunctionalMinVal,prevFunctionalMaxVal) )

        waveEquationContentArray = []
        let midEnergy = (eMax+eMin)/2.0
        rk4(x0: x0, h:h,energy:midEnergy, xMax: xMax, potential:potential)
        let rk4Endpoint = waveEquationContentArray[waveEquationContentArray.count-1][.Y]!
        if (abs(rk4Endpoint) <= pow(10,-1)){
            return midEnergy
        } else {
            if (rk4Endpoint > 0 && prevFunctionalMaxVal > 0){
            return bisect(eMin:eMin, eMax:midEnergy,prevFunctionalMaxVal:rk4Endpoint,
                          prevFunctionalMinVal:prevFunctionalMinVal,x0:x0,h:h,xMax:xMax, potential:potential)
            } else if (rk4Endpoint < 0 && prevFunctionalMinVal < 0){
                return bisect(eMin:midEnergy, eMax:eMax,prevFunctionalMaxVal:prevFunctionalMaxVal,
                              prevFunctionalMinVal:rk4Endpoint,x0:x0,h:h,xMax:xMax, potential:potential)
                }
            else if (rk4Endpoint < 0 && prevFunctionalMinVal > 0){
                return bisect(eMin:eMin, eMax:midEnergy,prevFunctionalMaxVal:rk4Endpoint,
                              prevFunctionalMinVal:prevFunctionalMinVal,x0:x0,h:h,xMax:xMax, potential:potential)
            } else {
                return bisect(eMin:midEnergy, eMax:eMax,prevFunctionalMaxVal:prevFunctionalMaxVal,
                              prevFunctionalMinVal:rk4Endpoint,x0:x0,h:h,xMax:xMax, potential:potential)
            }
        }

    }
    
    
    func newtonRaphson(eMax:Double, prevFunctionalMaxVal:Double, x0: Double, h:Double, xMax: Double, potential:Potential )->Double{
//        print(String(format:"EMin: %.4f , EMax: %.4f, rkMin: %.4f , rkMax: %.4f", eMin,eMax,prevFunctionalMinVal,prevFunctionalMaxVal) )

        waveEquationContentArray = []
        let energyStepForSlope = 0.01
        rk4(x0: x0, h:h,energy:eMax + energyStepForSlope, xMax: xMax, potential:potential)
        let rk4Endpoint = waveEquationContentArray[waveEquationContentArray.count-1][.Y]!
        
        let slope = (rk4Endpoint-prevFunctionalMaxVal)/energyStepForSlope
        let newEVal = eMax - prevFunctionalMaxVal/slope
        
        waveEquationContentArray = []
        rk4(x0: x0, h:h,energy:newEVal, xMax: xMax, potential:potential)
        let newEValrk4Endpoint = waveEquationContentArray[waveEquationContentArray.count-1][.Y]!
        
        if (abs(newEValrk4Endpoint) <= pow(10,-1)){
            return newEVal
        } else {
            return newtonRaphson(eMax: newEVal, prevFunctionalMaxVal:newEValrk4Endpoint, x0: x0, h:h, xMax: xMax, potential:potential )
        }

    }
    
    func calculateFunctional(x0: Double, h:Double, xMax: Double, potential:Potential ){
        eigenEnergies = []
        let energyStep = 0.05
        let n = Int((100)/energyStep)
        
        for i in 0...n{
            rk4(x0: x0, h:h,energy:Double(i) * energyStep, xMax: xMax, potential:potential)
            functionalContentArray.append([.X: Double(i) * energyStep, .Y: waveEquationContentArray[waveEquationContentArray.count-1][.Y]!])
            if ( i >= 1){
            let current = functionalContentArray[functionalContentArray.count-1][.Y]!
            let prev = functionalContentArray[functionalContentArray.count-2][.Y]!
                if ((current >= 0.0 && prev <= 0.0) || (current <= 0.0 && prev >= 0.0)){
                    //Bisect
//                    let eigenEnergy = bisect(eMin:(Double(i)-1.0) * energyStep, eMax:Double(i) * energyStep,prevFunctionalMaxVal:prev,
//                                  prevFunctionalMinVal:current,x0:x0,h:h,xMax:xMax, potential:potential)
                    let eigenEnergy = newtonRaphson(eMax: energyStep * Double(i), prevFunctionalMaxVal: current, x0: x0, h: h, xMax: xMax, potential: potential)
                    print(eigenEnergy, energyStep * Double(i))
                    eigenEnergies.append(eigenEnergy)
                }
                }
            }
        
    waveEquationContentArray = []

    }

}
