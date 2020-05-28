import Alamofire

public protocol APIClientDelegate {
    func onSuccess(apiName: String, data: AnyObject, owner: String, userInfo: Any?)
    func onError(apiName: String, status: Int, errorInfo: AnyObject, owner: String, userInfo: Any?)
    func onNoInternet(apiName: String, errorInfo: AnyObject, owner: String, userInfo: Any?)
}

public class APIClient {
    
    static var delegate: APIClientDelegate?
    
    static var SERVER_URL = ""
    static var API_KEY = ""
    static var AuthHeader = ["Accept" : "application/json", "Content-Type" : "application/json"]
    static var user = ""
    static var firmCode = ""
    static var logText = ""
    static var debugMode = false
    
    ////////////////////////////////
    
    class func callAPI(type: HTTPMethod, name: String, endPoint: String, parameters: [String : Any], headers: HTTPHeaders, owner: String, userInfo: Any?) {
        
        Alamofire.request(endPoint, method: type, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            if (debugMode) {
                print(response)
            }
            
            switch response.result {
            case.success(let value):
                self.delegate!.onSuccess(apiName: name, data: value as AnyObject, owner: owner, userInfo: info)
                break
                
            case.failure(let error):
                let errorInfoString = "Name: \(user), FirmID: \(firmCode)\nError: \(error)\nCall Type: \(type)\nAPI Endpoint: \(endPoint)\nParameters: \(parameters)\n\n"
                logText = logText + errorInfoString
                
                if error is URLError {
                    self.delegate!.onNoInternet(apiName: name, errorInfo: errorInfoString as AnyObject, owner: owner, userInfo: info)
                }
                else {
                    let status = response.response?.statusCode ?? 0
                    self.delegate!.onError(apiName: name, status: status, errorInfo: errorInfoString as AnyObject, owner: owner, userInfo: info)
                }
                break
            }
        }
    }
    
    class func callAPIInBlock(type: HTTPMethod, endPoint: String, parameters: [String : Any], headers: HTTPHeaders, success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        
        Alamofire.request(endPoint, method: type, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            if (debugMode) {
                print(response)
            }
            
            if (type == .delete) {
                success("" as AnyObject)
                return
            }
            
            switch response.result {
            case.success(let value):
                success(value as AnyObject)
                break
                
            case.failure(let error):
                let errorInfoString = "Error: \(error)\nCall Type: \(type)\nAPI Endpoint: \(endPoint)\nParameters: \(parameters)\n\n"
                logText = logText + "Name: \(user), FirmID: \(firmCode)\n" + errorInfoString
                
                if error is URLError {
                    failure(error as AnyObject)
                }
                else {
                    failure(error as AnyObject)
                }
                break
            }
        }
    }
    
    class func callAPIWithBodyDataInBlock(type: String, name: String, endPoint: String, data: [[String : Any]], success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        var request = URLRequest(url: URL.init(string: endPoint)!)
        request.httpMethod = type
        request.allHTTPHeaderFields = AuthHeader
        request.httpBody = try! JSONSerialization.data(withJSONObject: data)

		Alamofire.request(request).responseJSON { response in
			if (debugMode) {
				print(response)
			}
			switch response.result {
			case .success(let value):
				success(value as AnyObject)
				break
				
			case .failure(let error):
				let errorInfoString = "Name: \(user)\nError: \(error)\nCall Type: \(type)\nAPI Endpoint: \(endPoint)\nParameters: \(data)\n\n"
				logText = logText + errorInfoString
				
				if error is URLError {
					failure(error as AnyObject)
				}
				else {
					failure(error as AnyObject)
				}
				break
			}
		}
    }
    
    ////////////////////////////////
    
    public class func setDelegate(_ delegate: APIClientDelegate) {
        self.delegate = delegate
    }
    
    public class func setConfiguration(_ url: String, key: String) {
        self.SERVER_URL = url
        self.API_KEY = key
    }
    
    public class func setUserInfo(parameters: [String : String]) {
        AuthHeader["x-api-key"] = API_KEY
        
        let user = parameters["user"]
        let password = parameters["password"]
        let loginString = user! + ":" + password!
        let credentialData = loginString.data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        AuthHeader["Authorization"] = "Basic \(base64Credentials)"
    }
    
    public class func setDebugMode(_ isEnable: Bool) {
        self.debugMode = isEnable
    }
    
    public class func getLog() -> String {
        return logText
    }
    
    public class func deleteLog() {
        logText = ""
    }
    
    ////////////////////////////////
    
    public class func signIn(parameters: [String : String], owner: String) {
        let endPoint = SERVER_URL + "user"
        
        setUserInfo(parameters: parameters)
        
        callAPI(type: .get, name: "signIn", endPoint: endPoint, parameters: [:], headers: AuthHeader, owner: owner, userInfo: "")
    }
    
    ////////////////////////////////
    
    public class func getSchema(_ element: String, parameters: [String : Any], owner: String) {
        let endPoint = "\(SERVER_URL)/\(element)/schema"
        callAPI(type: .get, name: "getSchema", endPoint: endPoint, parameters: [:], headers: AuthHeader, owner: owner, userInfo: element)
    }
    
    public class func getSchema(_ element: String, success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        let endPoint = "\(SERVER_URL)/\(element)/schema"
        
        callAPIInBlock(type: .get, endPoint: endPoint, parameters: [:], headers: AuthHeader, success: success, failure: failure)
    }
    
    ////////////////////////////////
    
    //  Contact
    
    public class func getContacts(parameters: [String : Any], owner: String, info: Any?) {
        let endPoint = SERVER_URL + "contacts"
        
        callAPI(type: .get, name: "getContacts", endPoint: endPoint, parameters: parameters, headers: AuthHeader, owner: owner, userInfo: info)
    }
    
    public class func searchContacts(parameters: [String : Any], owner: String, info: Any?) {
        let endPoint = SERVER_URL + "contacts/search"
        
        callAPI(type: .get, name: "searchContacts", endPoint: endPoint, parameters: parameters, headers: AuthHeader, owner: owner, userInfo: info)
    }
    
    ////////////////////////////////
    
    //  Project
    
    public class func getProjects(parameters: [String : Any], owner: String, info: Any?) {
        let endPoint = SERVER_URL + "projects"
        
        callAPI(type: .get, name: "getProjects", endPoint: endPoint, parameters: parameters, headers: AuthHeader, owner: owner, userInfo: info)
    }
    
    public class func searchProjects(parameters: [String : Any], owner: String, info: Any?) {
        let endPoint = SERVER_URL + "projects/search"
        
        callAPI(type: .get, name: "searchProjects", endPoint: endPoint, parameters: parameters, headers: AuthHeader, owner: owner, userInfo: info)
    }
    
    //  Image
    
    public class func getProjectImages(_ projectId: Int, owner: String, info: Any?) {
        let endPoint = SERVER_URL + "projects/\(projectId)/images"
        
        callAPI(type: .get, name: "getProjectImages", endPoint: endPoint, parameters: [:], headers: AuthHeader, owner: owner, userInfo: info)
    }
    
    public class func getProjectImage(_ projectId: Int, imageId: Int, type: String, owner: String, info: Any?) {
        let endPoint = SERVER_URL + "images/project/\(projectId)/\(imageId)/\(type)"
        
        callAPI(type: .get, name: "getProjectImage", endPoint: endPoint, parameters: [:], headers: AuthHeader, owner: owner, userInfo: info)
    }
    
    public class func getProjectImages(_ projectId: Int, success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        let endPoint = SERVER_URL + "projects/\(projectId)/images"
        
        callAPIInBlock(type: .get, endPoint: endPoint, parameters: [:], headers: AuthHeader, success: success, failure: failure)
    }
    
    public class func getProjectImage(_ projectId: Int, imageId: Int, type: String, success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        let endPoint = SERVER_URL + "images/project/\(projectId)/\(imageId)/\(type)"
        
        callAPIInBlock(type: .get, endPoint: endPoint, parameters: [:], headers: AuthHeader, success: success, failure: failure)
    }
    
    public class func addProjectImages(_ projectId: Int, parameters: [[String : Any]], success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        let endPoint = SERVER_URL + "projects/\(projectId)/images"
        
        callAPIWithBodyDataInBlock(type: "POST", name: "addProjectImages", endPoint: endPoint, data: parameters, success: success, failure: failure)
    }
    
    public class func updateProjectImages(_ projectId: Int, imageId: Int, parameters: [[String : Any]], success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        let endPoint = SERVER_URL + "projects/\(projectId)/images/\(imageId)"
        
        callAPIWithBodyDataInBlock(type: "PUT", name: "updateProjectImages", endPoint: endPoint, data: parameters, success: success, failure: failure)
    }
    
    public class func deleteProjectImage(_ projectId: Int, imageId: Int, success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        let endPoint = SERVER_URL + "projects/\(projectId)/images/\(imageId)"
        
        callAPIInBlock(type: .delete, endPoint: endPoint, parameters: [:], headers: AuthHeader, success: success, failure: failure)
    }
    
    public class func addProjectImageContent(_ projectId: Int, imageId: Int, parameters: [[String : Any]], success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) {
        let endPoint = SERVER_URL + "images/project/\(projectId)/\(imageId)"
        
        callAPIWithBodyDataInBlock(type: "PUT", name: "addProjectImageContent", endPoint: endPoint, data: parameters, success: success, failure: failure)
    }
    
    ////////////////////////////////
}
