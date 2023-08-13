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
            for indice in reservation.clientslist.indices {
                print( "lista de clientes: ", reservation.clientslist[indice].name)
            }
            //var clientReservationList = reservation.clientslist
            //var namesClients: Array<Int> = []
            //print(clientReservationList)
            
            /*
            for client in reservation.clientslist {
                //namesClients.append(clientes.name)
                //append(clientes.name)
                //print("Long Lista: \(clientReservationList[client].name)")
                print("Clientes:", clientReservationList)
            }
            
            
            print("Nº de reserva:", reservation.id, "Clientes: ", reservation.clientslist[0].name)*/
        }
        return reservationList
    }
    
    
}

let Antonio = Client(name: "Antonio", age: 56, heigh: 1.60)
let Ascension = Client(name: "Ascension", age: 51, heigh: 1.62)

let Tomas = Client(name: "Tomás", age: 33, heigh: 1.82)
let Inma = Client(name: "Inma", age: 32, heigh: 1.60)



let reserva1 = try? HotelReservationManager().addNewReservation(clientslistNew: [Antonio,Ascension], daysInHotelNew: 5, breakfastNew: false)
let reserva2 = try HotelReservationManager().addNewReservation(clientslistNew: [Tomas, Inma], daysInHotelNew: 5, breakfastNew: true)

let allReservations = HotelReservationManager().AllResevations()
