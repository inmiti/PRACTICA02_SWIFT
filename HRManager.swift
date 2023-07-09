//
//  HRManager.swift
//  
//
//  Created by ibautista on 9/7/23.
//

import Foundation

struct Client {
    let name: String
    let age: Int
    let heigh: Double
}

struct Reservation {
    let id: Int
    let hotelName: String
    let clients: []
    let days: Int
    let price: Double
    let breakfast: Bool
}

enum ReservationError {
    case id
    case reserved
    case notReserved
}

class HotelReservationManager {
    var reservationList: [Reservation] = []
    
    func reservationAdd(hotelName: String,clientslist: [Client], daysInHotel: Int, price: Double, breakfast: Bool) -> Reservation {
        
        let newId = (reservationList.last?.id ?? 0 ) + 1
        
        let newReservation = Reservation(id: newId, hotelName: hotelName, clientslist: clientslist, daysInHotel: daysInHotel, price: price, breakfast: breakfast)
        reservationList.append(newReservation)
        
        return newReservation
    }
}

    
