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
        let newId = (reservationList.last?.id ?? 0) + 1
        
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
        print("La reserva nº \(idRemove) se ha cancelado.")
      }

    
    //Método para obtener todas las reservas actuales:
    // OJO VER CustomStringConvertible
    func AllResevations () -> [Reservation] {
        print("* TODAS LAS RESERVAS: ")
        
        if !reservationList.isEmpty {
            for reservation in reservationList {
                var namesClientsList: Array<String> = []
                
                for indice in reservation.clientslist.indices {
                    var nameOfClient = reservation.clientslist[indice].name
                    namesClientsList.append(nameOfClient)
                }
                print("Nº: ", reservation.id,  "; Clientes: ", namesClientsList, "; Precio: ", reservation.price, " €." )
            }
        }
            else {
                print("No hay reservas.")
            }
        
        return reservationList
    }
    
    
}

// Clientes:
let Goku = Client(name: "Goku", age: 56, heigh: 1.60)
let Pikolo = Client(name: "Pikolo", age: 51, heigh: 1.62)
let Vegeta = Client(name: "Vegeta", age: 33, heigh: 1.82)
let Bulma = Client(name: "Bulma", age: 32, heigh: 1.72)


// Test

func testAddReservation() {
    let clients = [Goku, Pikolo]
    let clients2 = [Vegeta, Bulma]
    let clients3 = [Goku, Bulma]
    let manager = HotelReservationManager()
    // Nuevas reservas
    do {
        let reserva1 = try manager.addNewReservation(clientslistNew: clients, daysInHotelNew: 5, breakfastNew: false)
        assert(manager.AllResevations().count == 1)
        assert(reserva1.id == 1)
        assert(reserva1.clientslist == clients)
    } catch {
        assertionFailure("Ojo! Debería haber entrado en el do. No espero error.")
    }
    
    do {
        let reserva2 = try manager.addNewReservation(clientslistNew: clients2, daysInHotelNew: 5, breakfastNew: true)
        assert(manager.AllResevations().count == 2)
        assert(reserva2.id == 2)
    } catch {
        assertionFailure("Ojo! Debería haber entrado en el do. No espero error.")
    }
    
    // Reserva con cliente duplicado
    do {
        let reservaSameClient = try manager.addNewReservation(clientslistNew: clients3, daysInHotelNew: 3, breakfastNew: false)
        assert(manager.AllResevations().count == 2)
        print("Ojo! Debería haber entrado en el catch. Se esperaba error.")
    } catch {
        let exception = error as? ReservationError
        assert(exception == ReservationError.reserved)
        print("Es correcto que ocurra la excepción.")
    }
}

func testCancelReservation() {
    let clients3 = [Goku, Bulma]
    let hotelManager = HotelReservationManager()
    do {
        let reserva = try hotelManager.addNewReservation(clientslistNew: clients3, daysInHotelNew: 5, breakfastNew: false)
    } catch {
        assertionFailure("No se espera ningún error")
    }
    // Cancelando reserva existente
    do {
        let cancelacion = try hotelManager.cancelReservation(idRemove: 1)
        assert(hotelManager.AllResevations().count == 0)
    } catch {
        assertionFailure("Ojo! Debería haber entrado en el do. No espero error.")
    }
    // Cancelando reserva no existente
    do {
        let cancelacion = try hotelManager.cancelReservation(idRemove: 4)
        assertionFailure("Ojo! Debería haber entrado en el catch. Se espera error.")
        
    } catch {
        let excepcion = error as? ReservationError
        assert(excepcion == ReservationError.notReserved)
    }
}

func testReservationPrice() {
    let clients = [Goku, Pikolo]
    let clients2 = [Vegeta, Bulma]
    let hotelManager = HotelReservationManager()
    // Dos reservas iguales a excepto el nombre de los clientes para comprobar que el precio es el mismo
    do {
        let reserva1 = try hotelManager.addNewReservation(clientslistNew: clients, daysInHotelNew: 5, breakfastNew: false)
        let reserva2 = try hotelManager.addNewReservation(clientslistNew: clients2, daysInHotelNew: 5, breakfastNew: false)
        assert(reserva1.price == reserva2.price)
        print("El precio de la reserva 1 es \(reserva1.price) siendo igual al precio de la reserva 2 que es \(reserva2.price)." )
    } catch {
        assertionFailure("No se espera ningún error")
    }  
}

print("----Test Add Reservation ----")
testAddReservation()
print("----Test Cancel Reservation ----")
testCancelReservation()
print("----Test Reservation Price----")
testReservationPrice()
