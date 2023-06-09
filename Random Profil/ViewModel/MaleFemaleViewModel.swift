//
//  MaleFemaleViewModel.swift
//  Random Profil
//
//  Created by Jaehwa Noh on 2023/03/31.
//

import Foundation
import UIKit

class MaleFemaleViewModel: ObservableObject {
    
    @Published var people: [ProfileListStruct] = [ProfileListStruct]()
    @Published var isServerError: Bool = false
    private var imageCaching = ImageCaching()
    
    init(isMale: Bool) {
        self.getGenderList(isMale: isMale)
    }
    
    func getMoreList(isMale: Bool) {
        let url = RandomUserClient.Endpoints.getPersonList(gender: isMale ? "male" : "female").url
//        print(url)
        Task {
            do {
                await MainActor.run {
                    isServerError = false
                }
                
                let getPeople = try await loadDataFromServer(url: url)
                let filteredPeople = getPeople.filter {
                    aPeople in
                    if people.contains(aPeople) {
                        print(aPeople)
                    }
                    return !people.contains(aPeople)
                }
                
                await MainActor.run {
                    people += filteredPeople
                }
                
            } catch {
                await MainActor.run {
                    isServerError = true
                }
            }
        }
    }
    
    func getGenderList(isMale: Bool) {
        let url = RandomUserClient.Endpoints.getPersonList(gender: isMale ? "male" : "female").url
//        print(url)
        Task {
            do {
                await MainActor.run {
                    isServerError = false
                }
                
                let getPeople = try await loadDataFromServer(url: url)
                
                await MainActor.run {
                    people = [ProfileListStruct]()
                    imageCaching.cachingImage.removeAllObjects()
                    people = getPeople
                }
                
            } catch {
                await MainActor.run {
                    isServerError = true
                }
            }
        }
    }
    
    func fetchImageFromNetwork(url: String) async throws -> UIImage? {
        if let imageCache = imageCaching[url] {
            return imageCache
        }
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        
        let image = UIImage(data: data)
        if let image = image {
            if let imageCache = imageCaching[url] {
                return imageCache
            }
            imageCaching.set(forKey: url, image: image)
            return image
        } else {
            return nil
        }
    }
    
    func loadDataFromServer(url: String) async throws -> [ProfileListStruct] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else {
            throw NSError(domain: "HTTP Connect Fail", code: 404)
        }
        let profileStructs = try await readDecoder(data: data)
        let profileListStructs = profileStructs.asProfileListStruct()
        
        return profileListStructs
    }
    
    func readDecoder(data: Data) async throws -> [ProfileStruct] {
        let decoder = JSONDecoder()
        do {
            let responseObject = try decoder.decode(RandomUserResponseStruct.self, from: data)
            return responseObject.results
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print(error.localizedDescription)
        }
        return [ProfileStruct]()
    }
    
    
}
