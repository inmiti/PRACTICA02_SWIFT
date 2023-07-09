import Foundation

struct Client: Equatable {
    let name: String
    let age: Int
    let heigh: Int
}

struct Reservation: Equatable {
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
    
    private var reservationList: [Reservation] = [] // Habría que utilizar algun metodo para importar de la base de datos.
    let hotelName: String
    let unitPrice: Double
    
   
    // Constructor con parametros por defecto:
    init(hotelName: String = "Hotel Luchadores", unitPrice: Double = 20.00  ) {
        self.hotelName = hotelName
        self.unitPrice = unitPrice
    }
    
    // Método para añadir reservas:
    func addNewReservation(clientslistNew: [Client], daysInHotelNew: Int, breakfastNew: Bool) throws -> Reservation {
        
        let newId = ( reservationList.count ) + 1
        
        // Verificar que no se duplica el identificador de reservas, si se repite salta error.
        for reservation in reservationList {
            if reservation.id == newId {
                throw ReservationError.sameId
            }
        }
        
        // Verificar que no se duplica un cliente si ya tiene hecha una reserva:
        for newclient in clientslistNew {
            for reservation in reservationList {
                if reservation.clientslist.contains(newclient) {
                    throw ReservationError.reserved
                }
            }
        }
        
       // Calcular precio total según numero de clientes:
        var priceNew = Double(clientslistNew.count) * Double(daysInHotelNew) * unitPrice
        if breakfastNew {
            priceNew = priceNew * 1.25
        }
        
        // Crear reserva y añadir al listado de reservas:
        let newReservation = Reservation(id: newId, hotelName: hotelName, clientslist: clientslistNew, daysInHotel: daysInHotelNew, price: priceNew, breakfast: breakfastNew)
        
        reservationList.append(newReservation)
        print("Se ha realizado la reserva nº \(newReservation.id)")
        
        return newReservation
    }
    
    //Método para cancelar las reservas:
    func cancelReservation(idRemove: Int) throws {
        for reservation in reservationList {
            if idRemove == reservation.id {
                reservationList.remove(at: idRemove)
                print("La reserva nº \(idRemove) se ha cancelado")
            } else {
                ReservationError.notReserved
                print("La reserva no existe")
            }
        }
    }
    
    //Método para obtener todas las reservas actuales:
    func AllResevations () -> [Reservation] {
        for reservation in reservationList {
            print(reservation)
        return reservationList
        
        }
    }
    
}

// Test:

func testAddReservation() {
    let hotelReservation = HotelReservationManager()
    
    let cliente1 = Client(name: "Inma", age: 44, heigh: 160)
    let cliente2 = Client(name: "Tom", age: 45, heigh: 182)
    
    // Cliente duplicado
    do {
        try hotelReservation.addNewReservation(clientslistNew: [cliente2], daysInHotelNew: 1, breakfastNew: false)
    } catch ReservationError.reserved {
        print("Ya existe una reserva de este cliente.")
        
    }
    
    // id duplicada
    
    // Añade correctamente las reservas
    do {
        try hotelReservation.addNewReservation(clientslistNew: [cliente1], daysInHotelNew: 3, breakfastNew: true)
        assert(hotelReservation.AllResevations().count == 1, "Debe haber 1 reserva")
        try hotelReservation.addNewReservation(clientslistNew: [cliente2], daysInHotelNew: 4, breakfastNew: false)
        assert(hotelReservation.AllResevations().count == 2, "Debe haber 2 reserva")
    } catch {
        assertionFailure("Error al añadir la reserva")
    }
}


