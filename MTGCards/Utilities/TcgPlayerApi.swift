//
//  TcgHandler.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/6/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation

class TcgPlayerApi {
    static let handler = TcgPlayerApi()
    
    private let clientid = "4855043C-461A-4C83-AB56-303F5906B475"
    private let clientSecret = "7A65BBC3-8B1A-43D8-998E-476949A4A6E8"
    
    private let tokenURL = "https://api.tcgplayer.com/token"
    private let pricesURL = "http://api.tcgplayer.com/v1.27.0/pricing/product/"
    private var token: TcgToken? = nil
    
    private func getToken( completion: @escaping (_ success: Bool) -> Void) {
        if let url = URL(string: tokenURL) {
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Header")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let data = "grant_type=client_credentials&client_id=\(clientid)&client_secret=\(clientSecret)".data(using:String.Encoding.utf8, allowLossyConversion: false)
            request.httpBody = data
            request.httpMethod = "POST"
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                DispatchQueue.main.async {
                    if let error = responseError {
                        print(error)
                    } else if let jsonData = responseData {
                        let decoder = JSONDecoder()
                        do {
                            let token = try decoder.decode(TcgToken.self, from: jsonData)
                            self.token = token
                            print("token recieved: \(String(describing: self.token?.accessToken))")
                            completion(true)
                        } catch {
                            print(error)
                        }
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    public func getPrices(for cardIds: [Int32], completion: @escaping (_ prices: TcgPrices) -> Void){
        let group = DispatchGroup()
        group.enter()
        if let tkn = self.token {
            if !tkn.isValid() {
                self.getToken() { success in
                    group.leave()
                }
            } else {
                group.leave()
            }
        } else {
            self.getToken() { success in
                group.leave()
            }
        }
        group.notify(queue: .main){
            let ids = cardIds.map({"\($0)"}).joined(separator: ",")
            if let url = URL(string: self.pricesURL + ids){
                print(url)
                var request = URLRequest(url: url)
                if let bearer = self.token?.accessToken {
                    request.setValue("bearer \(bearer)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "GET"
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    let task = session.dataTask(with: request) { (responseData, response, responseError) in
                        DispatchQueue.main.async {
                            if let error = responseError {
                                print(error)
                            } else if let jsonData = responseData {
                                let decoder = JSONDecoder()
                                do {
                                    let prices = try decoder.decode(TcgPrices.self, from: jsonData)
                                    if prices.errors.isEmpty {
                                        //print("Prices recieved for \(cardIds): \(String(describing: prices.results[0].midPrice))")
                                        completion(prices)
                                    }
                                } catch {
                                    print(error)
                                }
                            } else {
                                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                                print(error)
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
    }
}

