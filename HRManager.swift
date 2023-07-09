import Foundation

struct Client {
    let name: String
    let age: Int
    let heigh: Double
}

struct Reservation {
    let id: Int
    let hotelName: String
    let clientslist: [ Client ]
    let daysInHotel: Int
    let price: Double
    let breakfast: Bool
}


enum ReservationError: Error {
    case sameId
    case reserved
    case notReserved
}


class HotelReservationManager {
    
    private var reservationList: [Reservation] = [] //habría que construir un metodo que llame al listado de la bbdd. Para el ejercicio la supongo vacía.
    let hotelName: String
    let unitPrice: Double
    
   
    // Constructor con parametros por defecto:
    init(reservationList: Array<Reservation>, hotelName: String = "Hotel Luchadores", unitPrice: Double = 25  ) {
        self.reservationList = reservationList
        self.hotelName = hotelName
        self.unitPrice = unitPrice
    }
    //Obtener el listado de Reservas(nuestra BBDD):
    
    
    
    // Método para añadir reservas:
    func addReservation(clientslist: [Client], daysInHotel: Int, breakfast: Bool) throws -> Reservation {
        
        let newId = ( reservationList.count ) + 1
        
        // Verificar que no se duplica el identificador de reservas, si se repite salta error.
        for reservation in reservationList {
            if reservation.id == newId {
                throw ReservationError.sameId
            }
        }
        // Verificar que no se duplica un cliente si ya tiene hecha una reserva:
        
              
       // Calcular precio total según numero de clientes:
        let price = Double(clientslist.count) * Double(daysInHotel) * unitPrice
        if breakfast {
            let priceWithBreakfast =
        }
        // Crear reserva y añadir al listado de reservas:
        let newReservation = Reservation(id: newId, hotelName: hotelName, clientslist: clientslist, daysInHotel: daysInHotel, price: price, breakfast: breakfast)
        
        reservationList.append(newReservation)
            
        return newReservation
    }
}


