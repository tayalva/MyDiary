//
//  DateFormatter.swift
//  MyDiary
//
//  Created by Taylor Smith on 2/2/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import Foundation


let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter
}()
