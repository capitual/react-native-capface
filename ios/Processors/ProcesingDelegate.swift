//
//  ProcesingDelegate.swift
//  ReactNativeCapfaceSdk
//
//  Created by Nayara Dias, Bruno Fialho and Daniel Sansão on 04/09/23.
//  Copyright © 2023 Capitual. All rights reserved.
//

import FaceTecSDK

protocol Processor: AnyObject {
    func isSuccess() -> Bool
}
