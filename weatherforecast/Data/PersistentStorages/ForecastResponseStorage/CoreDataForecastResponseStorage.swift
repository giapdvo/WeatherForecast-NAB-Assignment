//
//  CoreDataForecastResponseStorage.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation
import CoreData

final class CoreDataForecastResponseStorage {

    private let coreDataStorage: CoreDataStorage
    private let maxStorageLimit: Int

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared, maxStorageLimit: Int) {
        self.coreDataStorage = coreDataStorage
        self.maxStorageLimit = maxStorageLimit
    }

    // MARK: - Private

    private func fetchRequest(for requestDto: ForecastRequestDTO) -> NSFetchRequest<ForecastRequestEntity> {
        let request: NSFetchRequest = ForecastRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d AND %K = %@",
                                        #keyPath(ForecastRequestEntity.q), requestDto.q,
                                        #keyPath(ForecastRequestEntity.cnt), requestDto.cnt,
                                        #keyPath(ForecastRequestEntity.units), requestDto.units)
        return request
    }

    private func deleteResponse(for requestDto: ForecastRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataForecastResponseStorage: ForecastResponseStorage {

    func getResponse(for requestDto: ForecastRequestDTO, completion: @escaping (Result<ForecastResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDto)
                let requestEntity = try context.fetch(fetchRequest).first
                
                try self.validateExpiredQuery(for: requestEntity)
               
                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(response responseDto: ForecastResponseDTO, for requestDto: ForecastRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)
                try self.cleanUpRequest(for: requestDto, inContext: context)


                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataForecastResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
   // Only cache a request today the function will throw exception if the request createdAt not is in today. The forecast weather should get new for every single day.
    private func validateExpiredQuery(for request: ForecastRequestEntity?) throws {
        guard let createdAt = request?.createdAt, Calendar.current.isDateInToday(createdAt)  else {
            throw CoreDataStorageError.expiredCacheError
        }
    }
    
    private func cleanUpRequest(for requestDto: ForecastRequestDTO, inContext context: NSManagedObjectContext) throws {
        let request: NSFetchRequest = ForecastRequestEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(ForecastRequestEntity.createdAt),
                                                    ascending: false)]
        var result = try context.fetch(request)

        removeDuplicates(for: requestDto, in: &result, inContext: context)
        removeForcastRequest(limit: maxStorageLimit - 1, in: result, inContext: context)
    }

    private func removeDuplicates(for requestDto: ForecastRequestDTO, in queries: inout [ForecastRequestEntity], inContext context: NSManagedObjectContext) {
        queries
            .filter { $0.q == requestDto.q && $0.cnt == requestDto.cnt && $0.units == requestDto.units}
            .forEach { context.delete($0) }
        queries.removeAll { $0.q == requestDto.q && $0.cnt == requestDto.cnt && $0.units == requestDto.units }
    }

    private func removeForcastRequest(limit: Int, in queries: [ForecastRequestEntity], inContext context: NSManagedObjectContext) {
        guard queries.count > limit else { return }

        queries.suffix(queries.count - limit)
            .forEach { context.delete($0) }
    }
    
}


