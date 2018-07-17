import Vapor
import Vapor

struct CityController: RouteCollection {

    static let stubbedData: Bool = true

    func boot(router: Router) throws {

        let cityRoutes = router.grouped("api", "pm10")
        cityRoutes.get(use: getCityHandler)
    }

    func getCityHandler(_ req: Request) throws -> Future<ItemsResponse<City>> {
        let parser = WebPageParser(url: Configuration.ArpavUrl)

        let promise = req.eventLoop.newPromise(ItemsResponse<City>.self)
        do {
            let cities = CityController.stubbedData ? City.stubbed() : try parser.fetchCityPage()
            promise.succeed(result: ItemsResponse(items: cities))
        } catch let error as WebPageParsingError {
            promise.fail(error: error)
        }
        return promise.futureResult
    }
}


