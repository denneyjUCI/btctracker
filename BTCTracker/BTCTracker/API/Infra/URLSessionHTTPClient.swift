import Foundation

public final class URLSessionHTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    public func get(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }).resume()
    }
}
