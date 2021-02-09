import Foundation
import UIKit

class WaterViewModel: ObservableObject {
    @Published
    var drinkingAmount: Double = 100.0
    var drinkingTarget = 2000.0
    var waterLevel: CGFloat = .zero
    var firstLaunchKey = "firstLaunch"
    var isFirstStart: Bool {
        if let status = UserDefaults.standard.value(forKey: firstLaunchKey) as? Bool {
            print("It has already asked for permision")
            return status
        } else {
            print("First Launch!")
            return true
        }
    }
    
    var isGoalReached: Bool {
        round(drinkingTarget) == .zero
    }
    
    var targetText: String {
        isGoalReached
            ? "💦 Nice job! 💦"
            : "Target: \(drinkingTarget.toMilliliters())"
    }
    
    var minimumInterval: Double {
        min(50, drinkingTarget)
    }
    
    var drinkText: String {
        drinkingAmount.toMilliliters()
    }
    
    func didTapDrink() {
        let healthKit = HealthKitSetupAssistant()
        if isFirstStart {
            healthKit.requestPermissions()
            UserDefaults.standard.setValue(false, forKey: firstLaunchKey)
            print("Asked for permision")
        }
        guard floor(drinkingTarget - drinkingAmount) >= .zero else { return }
        drinkingTarget -= round(drinkingAmount)
        waterLevel += CGFloat(drinkingAmount / 10)
        drinkingAmount = min(drinkingAmount, drinkingTarget)
        healthKit.addWater(waterAmount: drinkingAmount, forDate: Date())
    }
    
    func didTapReset() {
        waterLevel = .zero
        drinkingTarget = 2000
        drinkingAmount = 100
    }
}
