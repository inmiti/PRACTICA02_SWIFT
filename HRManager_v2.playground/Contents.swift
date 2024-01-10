import Foundation

struct Client: Equatable {
    let name: String
    let age: Int
    let heigh: Double
}

struct Reservation: Equatable {
    let id: Int
    let hotelName: String
    let clientslist: [ Client ]
    let daysInHotel: Int
    let price: Double
    let breakfast: Bool
}

enum ReservationError: LocalizedError {
    case sameId
    case reserved
    case notReserved
    
    var errorDescription: String? {
        switch self {
            case .sameId:
                return "Se encontró reserva con el mismo Id"
            case .reserved:
                return "El cliente ya tiene una reserva"
            case .notReserved:
                return "No se ha encontrado la reserva"
        }
    }
}

class HotelReservationManager {
    private var reservationList: [Reservation] = []
    let hotelName: String
    let unitPrice: Double
    
    // Constructor con parametros por defecto:
   init(hotelName: String = "Hotel Luchadores", unitPrice: Double = 20.00) {
        self.hotelName = hotelName
        self.unitPrice = unitPrice
    }
    
    // Método para añadir reservas:
    func addNewReservation(clientslistNew: [Client], daysInHotelNew: Int, breakfastNew: Bool) throws -> Reservation {
        
        var newId = (reservationList.last?.id ?? 0) + 1
        
        // Verificar que no se duplica el identificador de reservas, si se repite salta error.
        for reservation in reservationList {
            if reservation.id == newId {
                throw ReservationError.sameId
            }
        }
        
        
        // Verificar que no se duplica un cliente si ya tiene hecha una reserva:
        
        for newClient in clientslistNew {
            if reservationList.contains(where: { $0.clientslist.contains(where: { $0.name == newClient.name }) }) {
                throw ReservationError.reserved
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

        print("Se ha realizado la reserva nº \(newReservation.id) para \(clientslistNew.count) clientes y \(daysInHotelNew) días, por un importe total de \(priceNew) € en el \(hotelName).")
        
        return newReservation
    }
    
    //Método para cancelar las reservas:
    func cancelReservation(idRemove: Int) throws {
        guard let deleteReservation = reservationList.firstIndex(where: {$0.id == idRemove}) else {
            throw ReservationError.notReserved
          }
        reservationList.remove(at: deleteReservation)
        print("La reserva nº \(idRemove) se ha cancelado")
      }

    
    //Método para obtener todas las reservas actuales:
    // OJO VER CustomStringConvertible
    func AllResevations () -> [Reservation] {
        
        for reservation in reservationList {
            var namesClientsList: Array<String> = []

            for indice in reservation.clientslist.indices {
                var nameOfClient = reservation.clientslist[indice].name
                namesClientsList.append(nameOfClient)
            }
            print("Número de reserva: ", reservation.id,  "; Clientes: ", namesClientsList, "; Precio: ", reservation.price, " €" )
        }
        return reservationList
    }
    
    
}

// EJEMPLOS CLIENTES:
let Antonio = Client(name: "Antonio", age: 56, heigh: 1.60)
let Ascension = Client(name: "Ascension", age: 51, heigh: 1.62)
let Tomas = Client(name: "Tomás", age: 33, heigh: 1.82)
let Inma = Client(name: "Inma", age: 32, heigh: 1.60)
let Rosa =  Client(name: "Rosa", age: 28, heigh: 1.58)
let Elena = Client(name: "Elena", age: 27, heigh: 1.65)

// Test
//
//func testAddReservation() {
//    let manager = HotelReservationManager()
//    let reserva1 = try manager.addNewReservation(clientslistNew: [Antonio,Ascension], daysInHotelNew: 5, breakfastNew: false)
//    let reserva2 = manager.addNewReservation(clientslistNew: [Tomas, Inma], daysInHotelNew: 5, breakfastNew: true)
//
//}

// EJEMPLOS RESERVAS:
let manager = HotelReservationManager()
let reserva1 = try manager.addNewReservation(clientslistNew: [Antonio,Ascension], daysInHotelNew: 5, breakfastNew: false)
let reserva2 = try manager.addNewReservation(clientslistNew: [Tomas, Inma], daysInHotelNew: 5, breakfastNew: true)
//print("reserva 1: \(reserva1)")

// EJEMPLO ERRORES RESERVA:

// Error id igual: se hace en test

// Error crear reserva con igual cliente, lanza error "ReservationError.reserved":
do {
    let reserva4 = try HotelReservationManager().addNewReservation(clientslistNew: [Antonio, Rosa, Elena], daysInHotelNew: 3, breakfastNew: false)
//    print(reserva4)
} catch let error as ReservationError {
    print("Error: \(error.localizedDescription)")
} catch {
    print("Otro error: \(error.localizedDescription)")
}

let reserva3 = try manager.addNewReservation(clientslistNew: [Rosa, Elena], daysInHotelNew: 3, breakfastNew: false)
//print(reserva3)

// EJEMPLO VER RESERVAS CON EL MÉTODO ALLRESERVATIONS:
let allReservations = manager.AllResevations()
//print(allReservations)


// Cancelando la RESERVA 2:

let cancelacion2 = try manager.cancelReservation(idRemove: 2)


// Comprobando que la reserva 2 se ha borrado:

let todasReservas = manager.AllResevations()

// CANCELANDO LA RESERVA 4: Ha de dar error

let cancelacion1 = try HotelReservationManager().cancelReservation(idRemove: 4)
