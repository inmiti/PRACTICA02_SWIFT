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

enum ReservationError: Error {
    case sameId
    case reserved
    case notReserved
}

private var reservationList: [Reservation] = []

class HotelReservationManager {
    
    //private var reservationList: [Reservation] = [] // Habría que utilizar algun metodo para importar de la base de datos.
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
        print("Se ha realizado la reserva nº \(newReservation.id) para \(clientslistNew.count) clientes y \(daysInHotelNew) días, por un importe total de \(priceNew) € en el \(hotelName).")
        
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
                // buscar otra opcion porque sale repetido en cada reserva.
            }
        }
    }
    
    //Método para obtener todas las reservas actuales:
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

// EJEMPLOS RESERVA:
let reserva1 = try? HotelReservationManager().addNewReservation(clientslistNew: [Antonio,Ascension], daysInHotelNew: 5, breakfastNew: false)
let reserva2 = try HotelReservationManager().addNewReservation(clientslistNew: [Tomas, Inma], daysInHotelNew: 5, breakfastNew: true)

// EJEMPLO ERRORES RESERVA:

// Error id igual no puedo comprobar porque siempre suma y no da la opcion de meter reserva con id.

// Error crear reserva con igual cliente, lanza error "ReservationError.reserved":
let reserva3 = try? HotelReservationManager().addNewReservation(clientslistNew: [Rosa, Elena, Antonio], daysInHotelNew: 3, breakfastNew: false)
print(reserva3 ?? ReservationError.self)

let reserva4 = try? HotelReservationManager().addNewReservation(clientslistNew: [Rosa, Elena], daysInHotelNew: 3, breakfastNew: false)
print(reserva4 ?? ReservationError.self)


// EJEMPLO VER RESERVAS CON EL MÉTODO ALLRESERVATIONS:
let allReservations = HotelReservationManager().AllResevations()

//print(allReservations)

// CANCELANDO LA RESERVA 4: Ha de dar error

let cancelacion1 = try HotelReservationManager().cancelReservation(idRemove: 4)
// Hay que modificar porque sale repetido el mensaje de que no existe, el print pero no arroja error. Hay que quitar la repetición.

// Cancelando la RESERVA 2:

let cancelacion2 = HotelReservationManager().cancelReservation(idRemove: 2)
// despues de borrar vuelve a iterar y da no existe... corregir

// Comprobando que la reserva 2 se ha borrado:

let todasReservas = HotelReservationManager().AllResevations()
//Me ha eliminado la ultima reserva, no la reserva 2. Hay que corregir. Se debe a que remove(at) elimina el elemento del índice dado, no del id...
