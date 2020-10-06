//
//  RESTUtils.swift
//  natura-ios
//
//  Created by livetouch on 05/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import Foundation

enum EugenioException: Error {
    case noData
    case badResponse
    case errorCode(status: Int)
}

class RESTUtils {

    let EUGENIO_URL :String!
    let POST_URL    :String!
    let QUERY_URL   :String!
    let API_KEY     :String!

    let CREATION_SCHEMA         :String!
    let USER_SCHEMA         :String!
    let PRINTQUEUE_SCHEMA   :String!
    let TENANT      :String!

    let session     :URLSession!

    init() {
        self.EUGENIO_URL = "https://portal.stg.eugenio.io"
        self.POST_URL = EUGENIO_URL + "/api/v1/data"
        self.QUERY_URL = EUGENIO_URL + "/api/v1/data/query?sql="
        self.API_KEY = "Q8T182a3cFa8NzsE08LysniXZt9FdGm3"

        self.CREATION_SCHEMA = "creations"
        self.USER_SCHEMA = "user"
        self.PRINTQUEUE_SCHEMA = "print_queue"

        self.TENANT = "tenant1601160959653"
        self.session = URLSession.shared
    }

    func sendCreation(body: CreationData, completion: @escaping ((Swift.Result<Data?, EugenioException>) -> Void)) {

         if let url = POST_URL, let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let encodedUrl = URL(string: encoded) {

            print("sending post to: " + encoded)
            var request = URLRequest(url: encodedUrl)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(self.API_KEY, forHTTPHeaderField: "apikey")
            request.addValue(self.CREATION_SCHEMA, forHTTPHeaderField: "X-Schema")
            request.addValue(self.TENANT, forHTTPHeaderField: "X-Tenant")

            do {
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                let encodedData = try encoder.encode(body)
                request.httpBody = encodedData

                self.sendRequest(urlRequest: request, completion: completion)
            }
            catch {
                print("json encoder error")
            }
        }
    }

    func sendRequest(urlRequest: URLRequest, completion: @escaping ((Swift.Result<Data?, EugenioException>) -> Void)) {
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error -> Void in

            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    if (response.statusCode / 100 == 2) {
                        completion(.success(data))
                    } else {
                        completion(.failure(.errorCode(status: response.statusCode)))
                    }
                }

                if let error = error {
                    completion(.failure(.badResponse))
                }
            }

        })

        task.resume()
    }

}
