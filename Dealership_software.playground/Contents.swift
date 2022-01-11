import UIKit
import CoreGraphics

//Часть 1.
//Для начала нужно описать машину минимальным набором параметров, используя протокол.
//
//Алгоритм выполнения
//Создайте протокол 'Car'
//Добавьте в него свойства:
//'model' (только для чтения): марка
//'color' (только для чтения): цвет
//'buildDate' (только для чтения): дата выпуска
//'price' (чтение и запись): цена авто
//'accessories' (чтение и запись): дополнительное оборудование (тонировка, сингнализация, спортивные диски)
//'isServiced' (чтение и запись): сделана ли предпродажная подготовка. Обычно ее делают в дилерских центрах перед постановкой машины в салон.

protocol Car {
    
    var model: String { get }
    var color: String { get }
    var buildDate: Int { get }
    var price: Double { get set }
    var accessories: [Accessories] { get set }
    var isServiced: Bool { get set }
}
 
struct Accessories {
    
    var name: String
    var price: Int
}

class Helper {
    
    // Устанавливает рандомное Id для каждого автомобиля
    class func setId() -> Int {
        return Int.random(in: 0...100000)
    }
    
    // Метод принимает 2 парамeтра машину и массив машин. Возврщает индекс элемента в массиве.
    class func getIndex(car: CarObject, cars: [CarObject]) -> Int {
        let index = cars.firstIndex(where: ) {
            return $0.id == car.id
        }
        
        if let index = index {
            return index
        } else {
            return -1
        }
    }
}


//Часть 2.
//По аналогии с протоколом 'Car', нужно описать дилерский центр минимальным набором свойств и методов, используя протокол.
//
//Алгоритм выполнения
//Создайте протокол 'Dealership'
//Добавьте свойства:
//'name' (только для чтения): название дилерского центра (назвать по марке машины для упрощения)
//'showroomCapacity' (только для чтения): максимальная вместимость автосалона по количеству машин.
//'stockCars' (массив, чтение и запись): машины, находящиеся на парковке склада. Представим, что парковка не имеет лимита по количеству машин.
//'showroomCars' (массив, чтение и запись): машины, находящиеся в автосалоне.
//'cars' (массив, чтение и запись): хранит список всех машин в наличии.
//Добавьте методы:
//'offerAccesories(_ :)': принимает массив акксесуаров в качестве параметра. Метод предлагает клиенту купить доп. оборудование.
//'presaleService(_ :)': принимает машину в качестве параметра. Метод отправляет машину на предпродажную подготовку.
//'addToShowroom(_ :)': также принимает машину в качестве параметра. Метод перегоняет машину с парковки склада в автосалон, при этом выполняет предпродажную подготовку.
//'sellCar(_ :)': также принимает машину в качестве параметра. Метод продает машину из автосалона при этом проверяет, выполнена ли предпродажная подготовка. Также, если у машины отсутсвует доп. оборудование, нужно предложить клиенту его купить. (давайте представим, что клиент всегда соглашается и покупает :) )
//'orderCar()': не принимает и не возвращает параметры. Метод делает заказ новой машины с завода, т.е. добавляет машину на парковку склада.
//Обратите внимание! Каждый метод должен выводить в консоль информацию о машине и выполненном действии с ней.

protocol Dealership {
    
    var name: String { get }
    var showroomCapacity: Int { get }
    var stockCars: [CarObject] { get set}
    var showroomCars: [CarObject] { get set}
    var cars: [CarObject] { get set}
}
 
extension Dealership {
    
    func offerAccesories(accessories: [Accessories]) {
        print("Покупка доп. оборудования:")
        accessories.forEach({ print($0.name, $0.price) })
    }
    
    func presaleService(car: inout CarObject) {
        if car.isServiced {
            print("Автомобиль \(car.model) уже прошел предпродажную подготовку")
        }
        else {
            car.isServiced = true
            
            print("Автомобиль \(car.model) прошел предпродажную подготовку")
        }
    }
    
    mutating func addToShowroom(car: inout CarObject) {
        if self.showroomCars.count >= self.showroomCapacity {
            print("В салоне больше нет места")
            
            return
        }
        
        let index = Helper.getIndex(car: car, cars: self.stockCars)
        
        if index >= 0 {
            if car.isServiced {
                self.showroomCars.append(car)
                self.stockCars.remove(at: index)
                
                print("Машина уже отправлена с парковки склада в автосалон.")
            } else {
                car.isServiced = true
                self.showroomCars.append(car)
                
                print("Машина отправлена с парковки склада в автосалон.")
            }
        } else {
            print("Автомобиль \(car.model) не найден")
        }
    }
    
   mutating func sellCar(car: CarObject) {
        if !car.isServiced {
            print("Нельзя продать автомобиль \(car.model), не выполнена предпродажная подготовка")
            
            return
        }
        
       let index = Helper.getIndex(car: car, cars: self.showroomCars)
        
        if index >= 0 {
            self.showroomCars.remove(at: index)
            
            print("Автомобиль \(car.model) продан ")
            
            let i = Helper.getIndex(car: car, cars: self.cars)
            
            if i >= 0 {
                self.cars.remove(at: i)
            }
            
        } else {
            print("Невозможно продать \(car.model), такого автомобиля нет")
        }
    }
    
    mutating func orderCar() {
        print("Заказ новой машины с завода.")
        
        let year = Calendar.current.component(.year, from: Date())
        
        let car = CarObject(model: "Заводская \(self.name)",
                            color: "White",
                            buildDate: year,
                            price: 20000,
                            accessories: [Accessories](),
                            isServiced: false,
                            id: Helper.setId())
        self.stockCars.append(car)
        self.cars.append(car)
    }
}

//Часть 3.
//Настало время добавить классы и структуры, реализующие созданные ранее протоколы.
//
//Алгоритм выполнения
//Используя структуры, создайте несколько машин разных марок (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Car'.
//Используя классы, создайте пять различных дилерских центров (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Dealership'. Каждому дилерскому центру добавьте машин на парковку и в автосалон (используйте те машины, которые создали ранее).
//Создайте массив, положите в него созданные дилерские центры. Пройдитесь по нему циклом и выведите в консоль слоган для каждого дилеского центра (слоган можно загуглить).
//Обратите внимание! Используйте конструкцию приведения типа данных для решения этой задачи.

struct CarObject: Car {
    
    var model: String
    var color: String
    var buildDate: Int
    var price: Double
    var accessories: [Accessories]
    var isServiced: Bool
    var id: Int // Уникальный айди для каждого автомобиля
    
}
var accessories: [Accessories] = [
    Accessories(name: "Тонировка", price: 100),
    Accessories(name: "Сингнализация", price: 200),
    Accessories(name: "Спортивные диски", price: 300),
]

var bmwX3 = CarObject(model: "BMW X3", color: "White", buildDate: 2008, price: 210000, accessories: accessories, isServiced: true, id: Helper.setId())

var bmwX5 = CarObject(model: "BMW X5", color: "Black", buildDate: 2010, price: 200000, accessories: accessories, isServiced: true, id: Helper.setId())

var bmwX6 = CarObject(model: "BMW X6", color: "Red", buildDate: 2018, price: 230000, accessories: accessories, isServiced: true, id: Helper.setId())

var hondaFit = CarObject(model: "Honda Fit", color: "Black", buildDate: 2012, price: 220000, accessories: accessories, isServiced: true, id: Helper.setId())

var hondaAccord = CarObject(model: "Honda Accord", color: "Red", buildDate: 2013, price: 230000, accessories: accessories, isServiced: true, id: Helper.setId())

var hondaLegend = CarObject(model: "Honda Legend", color: "Yellow", buildDate: 2015, price: 250000, accessories: accessories, isServiced: true, id: Helper.setId())

var audiQ1 = CarObject(model: "Audi Q1", color: "Grey", buildDate: 2016, price: 240000, accessories: accessories, isServiced: true, id: Helper.setId())

var audiQ2 = CarObject(model: "Audi Q2", color: "Black", buildDate: 2017, price: 250000, accessories: accessories, isServiced: true, id: Helper.setId())

var audiQ3 = CarObject(model: "Audi Q3", color: "Red", buildDate: 2018, price: 260000, accessories: accessories, isServiced: true, id: Helper.setId())

var lexusRX = CarObject(model: "lexusRX", color: "Red", buildDate: 2019, price: 270000, accessories: accessories, isServiced: true, id: Helper.setId())

var lexusLS = CarObject(model: "lexusLS", color: "Green", buildDate: 2019, price: 260000, accessories: accessories, isServiced: true, id: Helper.setId())

var lexusES = CarObject(model: "lexusES", color: "White", buildDate: 2019, price: 280000, accessories: accessories, isServiced: true, id: Helper.setId())

var volvoS40 = CarObject(model: "volvoS40", color: "White", buildDate: 2015, price: 210000, accessories: accessories, isServiced: false, id: Helper.setId())

var volvoS60 = CarObject(model: "volvoS60", color: "Black", buildDate: 2017, price: 220000, accessories: accessories, isServiced: true, id: Helper.setId())

var volvoS80 = CarObject(model: "volvoS80", color: "Gray", buildDate: 2018, price: 230000, accessories: accessories, isServiced: true, id: Helper.setId())


class DealershipObject: Dealership {
    
    var name: String
    var showroomCapacity: Int
    var stockCars: [CarObject]
    var showroomCars: [CarObject]
    var cars: [CarObject]
    var slogan: String
    
    init(name: String, showroomCapacity: Int, stockCars: [CarObject], showroomCars: [CarObject], cars: [CarObject], slogan: String) {
        self.name = name
        self.showroomCapacity = showroomCapacity
        self.stockCars = stockCars
        self.showroomCars = showroomCars
        self.cars = cars
        self.slogan = slogan

    }
}

var bmwStockCars: [CarObject] = [ bmwX3, bmwX5, bmwX6 ]
var bmwShowroomCars: [CarObject] = []
var bmwCars: [CarObject] = [ bmwX3, bmwX5 ]

var bmwDealership = DealershipObject(name: "BMW", showroomCapacity: 20, stockCars: bmwStockCars, showroomCars: bmwShowroomCars, cars: bmwCars, slogan: "С удовольствием за рулем!")

var hondaStockCars: [CarObject] = [ hondaFit, hondaAccord, hondaLegend ]
var hondaShowroomCars: [CarObject] = [ ]
var hondaCars: [CarObject] = [ hondaFit, hondaAccord ]

var hondaDealership = DealershipObject(name: "Honda", showroomCapacity: 23, stockCars: hondaStockCars, showroomCars: hondaShowroomCars, cars: hondaCars, slogan: "Сначала человек, потом машина.")

var audiStockCars: [CarObject] = [ audiQ1, audiQ2, audiQ3 ]
var audiShowroomCars: [CarObject] = [ ]
var audiCars: [CarObject] = [ audiQ1, audiQ2 ]

var audiDealership = DealershipObject(name: "Audi", showroomCapacity: 28, stockCars: audiStockCars, showroomCars: audiShowroomCars, cars: audiCars, slogan: "Продвижение через технологии.")

var lexusStockCars: [CarObject] = [ lexusRX, lexusLS, lexusES ]
var lexusShowroomCars: [CarObject] = [ lexusRX, lexusLS, lexusES ]
var lexusCars: [CarObject] = [ lexusRX, lexusLS, lexusES ]

var lexusDealership = DealershipObject(name: "Lexus", showroomCapacity: 26, stockCars: lexusStockCars, showroomCars: lexusShowroomCars, cars: lexusCars, slogan: "Неудержимое стремление к совершенству.")

var volvoStockCars: [CarObject] = [ volvoS40, volvoS60, volvoS80 ]
var volvoShowroomCars: [CarObject] = [ volvoS40, volvoS60, volvoS80 ]
var volvoCars: [CarObject] = [ volvoS40, volvoS60, volvoS80 ]

var volvoDealership = DealershipObject(name: "Volvo", showroomCapacity: 26, stockCars: volvoStockCars, showroomCars: volvoShowroomCars, cars: volvoCars, slogan: "Volvo для жизни.")

var dealerships: [DealershipObject] = [ bmwDealership, hondaDealership, audiDealership, lexusDealership, volvoDealership ]

dealerships.forEach { dealership in
    print("\(dealership.name) - \(dealership.slogan)\n")
}

//Часть 4.
//Работа с расширениями. Нам нужно добавить спецпредложение для "прошлогодних" машин.
//
//Алгоритм выполнения
//Создайте протокол SpecialOffer.
//Добавьте методы:
//'addEmergencyPack()': не принимает никаких параметров. Метод добавляет аптечку и огнетушитель к доп. оборудованию машины.
//'makeSpecialOffer()': не принимает никаких параметров. Метод проверяет дату выпуска авто, если год выпуска машины меньше текущего, нужно сделать скидку 15%, а также добавить аптеку и огнетушитель.
//Используя расширение, реализуйте протокол 'SpecialOffer' для любых трех дилерских центров.
//Проверьте все машины в дилерском центре (склад + автосалон), возможно они нуждаются в специальном предложении. Если есть машины со скидкой на складе, нужно перегнать их в автосалон.


protocol SpecialOffer {
    
    mutating func addEmergencyPack()
    mutating func makeSpecialOffer()
}

extension CarObject: SpecialOffer {
   
        mutating func addEmergencyPack() {
            self.accessories.append(Accessories(name: "Огнетушитель", price: 0))
            self.accessories.append(Accessories(name: "Аптечка", price: 0))
            
            print("В автомобиль \(self.model) добавленны аптечка и огнетушитель")
        }
    
    
        mutating func makeSpecialOffer() {
            let year = Calendar.current.component(.year, from: Date())
        
            if self.buildDate < year {
                self.price -= self.price * 0.15
                self.addEmergencyPack()
            
                print("На автомобиль \(self.model) \(self.buildDate) года установлена скидка")
        }
    }
    
}

var index = 0
for var dealer in dealerships {
    if index == 3 {
        break
    }

    print("\nПроверяем автомобили в салоне \(dealer.name)\n")

    for indexShowroomCars in dealer.showroomCars.indices {
        dealer.showroomCars[indexShowroomCars].makeSpecialOffer()
    }

    print("\nПроверяем автомобили на складе \(dealer.name)\n")

    var indexStockCars = dealer.stockCars.count - 1

    while indexStockCars >= 0 {

        let oldPrice = dealer.stockCars[indexStockCars].price
        dealer.stockCars[indexStockCars].makeSpecialOffer()


        if oldPrice != dealer.stockCars[indexStockCars].price {
            var car = dealer.stockCars[indexStockCars]
            dealer.addToShowroom(car: &car)
        }

        indexStockCars -= 1
    }

    index += 1
}

dealerships

bmwDealership.addToShowroom(car: &bmwX6)
bmwDealership.sellCar(car: bmwX6)
bmwDealership.orderCar()

print(bmwDealership.cars)

