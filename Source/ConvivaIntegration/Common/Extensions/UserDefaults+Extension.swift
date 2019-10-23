//
//  Utils.swift
//  CVAReferenceApp
//
//  Created by Gaurav Tiwari on 29/08/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

extension UserDefaults {
  static func getConvivaCustomerKey() -> String? {
    return UserDefaults.standard.value(forKey: "Conviva_Customer_Key") as? String
  }

  static func getConvivaGatewayURL() -> String? {
    return UserDefaults.standard.value(forKey: "Conviva_Gateway_URL") as? String
  }
  
  static func setConvivaCustomerKey(customerKey : String) {
    UserDefaults.standard.set("1a6d7f0de15335c201e8e9aacbc7a0952f5191d7", forKey: "Conviva_Customer_Key")
  }
  
  static func setConvivaGatewayURL(gatewayURL : String) {
    UserDefaults.standard.set("https://conviva.testonly.conviva.com", forKey: "Conviva_Gateway_URL")
  }
  
  // Other setters and getters related to UserDefaults
  static func setFavouriteTeamName(teamName : String) {
    UserDefaults.standard.set(teamName, forKey: "Team_Name")
  }

  static func getFavouriteTeamName() -> String? {
    return UserDefaults.standard.value(forKey: "Team_Name") as? String
  }
}
