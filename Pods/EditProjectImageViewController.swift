import UIKit
import MBProgressHUD
import APIClient

class EditProjectImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SubProjectListDelegate, TextDataDelegate {
    
    let owner = "EditProjectImageViewController"
    
    @IBOutlet weak var imageTableView: UITableView!
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var caption: UITextView!
    
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    
    var textViewToolBar: UIToolbar?
    
    var project: Project?
    var projectImage = ProjectImage()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var backgroundTask = UIBackgroundTaskIdentifier.invalid
    
    var loadingIndicator: MBProgressHUD?
    
    var imageCaption = ""
    var keywords = ""
    var credit = ""
    var comments = ""
    
    var isProjectEditable = false
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerBackgroundTask()
        
        title = "Image Details"
        
        let backButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        backButton.setImage(UIImage(named: "BackIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(onBack), for: UIControl.Event.touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 21, height: 15)
        let leftBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: LOCALSTR("Save"), style: .plain, target: self, action: #selector(onSave))
        
        if (projectImage.image != nil) {
            projectImageView.image = projectImage.image
            if let imageData = projectImage.image!.jpegData(compressionQuality: 0.2) {
                if (projectImage.keywords == "") {
                    loadingIndicator = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                    loadingIndicator!.mode = MBProgressHUDMode.indeterminate
                    loadingIndicator!.label.text = "Getting image tags..."
                    
                    GoogleAPIHelper.getImageVisionData(content: imageData.base64EncodedString(options: .lineLength64Characters), success: { (data) in
                        self.loadingIndicator!.hide(animated: true)
                        var tags = [String]()
                        let responses = data["responses"] as? [[String : Any]] ?? []
                        for response in responses {
                            if response.keys.contains("labelAnnotations") {
                                let labelAnnotations = response["labelAnnotations"] as? [[String : Any]] ?? []
                                for labelAnnotation in labelAnnotations {
                                    if let description = labelAnnotation["description"] as? String {
                                        tags.append(description)
                                    }
                                }
                                break
                            }
                        }
                        
                        self.keywords = tags.joined(separator: ", ")
                        self.imageTableView.reloadData()
                    }) { (error) in
                        self.loadingIndicator!.hide(animated: true)
                        Util.showAlertMessage(title: APP_TITLE, message: "API call is failed. Try again later.", parent: self)
                        print(error)
                    }
                }
            }
        }
        else {
            if (project != nil && projectImage.id != 0) {
                APIClient.getProjectImage(Int(project!.id)!, imageId: projectImage.id, type: "", success: { (data) in
                    let imageData = data["Data"] as? String
                    _ = data["ContentType"] as? String
                    
                    if (imageData != nil) {
                        if let dataDecoded = Data(base64Encoded: imageData!, options: .ignoreUnknownCharacters) {
                            self.projectImage.image = UIImage(data: dataDecoded)
                            self.projectImageView.image = self.projectImage.image
                        }
                    }
                }) { (error) in
                    
                }
            }
        }
        
        imageTableView.reloadData()
        
        imageCaption = projectImage.caption
        keywords = projectImage.keywords
        credit = projectImage.credit
        comments = projectImage.comments
        
        name.text = projectImage.name
        
        if (imageCaption == "") {
            caption.text = "Write a caption"
            caption.textColor = UIColor.lightGray
        }
        else {
            caption.text = imageCaption
            caption.textColor = UIColor.black
        }
        
        textViewToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        textViewToolBar!.barStyle = .default
        textViewToolBar!.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: LOCALSTR("Done"), style: .done, target: self, action: #selector(closeKeyboard))]
        textViewToolBar!.sizeToFit()
        caption.inputAccessoryView = textViewToolBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskIdentifier.invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }
    
    @objc func reinstateBackgroundTask() {
        if backgroundTask == .invalid {
            registerBackgroundTask()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    ////////////////////////////////
    
    //  NavigationBar
    
    @objc func onBack() {
        navigationController!.popViewController(animated: true)
    }
    
    @objc func onSave() {
        if (project == nil) {
            if let image = projectImage.image {
                ProjectManager.instance.unassignedImages.append(image)
                navigationController!.popViewController(animated: true)
            }
            return
        }
        
        var parameters = [[String : Any]]()
        var parameter = [String : Any]()
        parameter["Caption"] = imageCaption
        parameter["Keywords"] = keywords
        parameter["Credit"] = credit
        parameter["Comments"] = comments
        parameters.append(parameter)
        
        loadingIndicator = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        loadingIndicator!.mode = MBProgressHUDMode.indeterminate
        if (projectImage.id == 0) {
            loadingIndicator!.label.text = "Adding project image..."
            APIClient.addProjectImages(Int(project!.id)!, parameters: parameters, success: { (data) in
                print(data)
                let array = data as? [AnyObject] ?? []
                for imageData in array {
                    let projectImage = ProjectImage()
                    
                    projectImage.id = imageData["ImageId"] as? Int ?? 0
                    projectImage.name = imageData["ImageName"] as? String ?? ""
                    projectImage.caption = imageData["Caption"] as? String ?? ""
                    projectImage.keywords = imageData["Keywords"] as? String ?? ""
                    projectImage.credit = imageData["Credit"] as? String ?? ""
                    projectImage.originalImageEndpoint = imageData["OriginalImageEndpoint"] as? String ?? ""
                    projectImage.websiteImageEndpoint = imageData["WebsiteImageEndpoint"] as? String ?? ""
                    projectImage.thumbnailImageEndpoint = imageData["ThumbnailImageEndpoint"] as? String ?? ""
                    projectImage.networkPath = imageData["NetworkPath"] as? String ?? ""
                    projectImage.imageNumber = imageData["ImageNumber"] as? String ?? ""
                    projectImage.orderNumber = imageData["OrderNumber"] as? String ?? ""
                    projectImage.accessLevel = imageData["AccessLevel"] as? String ?? ""
                    projectImage.uploadDate = imageData["UploadDate"] as? String ?? ""
                    projectImage.comments = imageData["Comments"] as? String ?? ""
                    
                    if let pngData = self.projectImageView.image?.pngData() {
                        var parameters = [String : Any]()
                        parameters["ContentType"] = "image/png"
                        parameters["Data"] = pngData.base64EncodedString(options: .lineLength64Characters)

                        APIClient.addProjectImageContent(Int(self.project!.id)!, imageId: projectImage.id, parameters: [parameters], success: { (data) in
                            projectImage.image = self.projectImageView.image
                            self.project!.images.insert(projectImage, at: 0)
                            self.loadingIndicator!.hide(animated: true)
                            self.navigationController!.popViewController(animated: true)
                            print(data)
                        }, failure: { (error) in
                            self.loadingIndicator!.hide(animated: true)
                            print(error)
                        })
                    }
                    else {
                        self.loadingIndicator!.hide(animated: true)
                    }
                    
                    break
                }
                
                if (array.count == 0) {
                    self.loadingIndicator!.hide(animated: true)
                }
            }) { (error) in
                self.loadingIndicator!.hide(animated: true)
                
                print(error)
            }
        }
        else {
            loadingIndicator!.label.text = "Updating project image..."
            APIClient.updateProjectImages(Int(project!.id)!, imageId: projectImage.id, parameters: parameters, success: { (data) in
                self.projectImage.caption = self.imageCaption
                self.projectImage.keywords = self.keywords
                self.projectImage.credit = self.credit
                self.projectImage.comments = self.comments
                self.loadingIndicator!.hide(animated: true)
                
                print(data)
                
                self.navigationController!.popViewController(animated: true)
            }) { (error) in
                self.loadingIndicator!.hide(animated: true)
                
                print(error)
            }
        }
    }
    
    ////////////////////////////////
    
    //  UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        else if (section == 1) {
            return 1
        }
        else if (section == 2) {
            return 2
        }
        else if (section == 3) {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if (section == 0 && project != nil) {
            return project!.cellHeight == 0 ? 110.0 : project!.cellHeight
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = tableView.frame.size.width
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 55))
        view.backgroundColor = UIColor(red: 241 / 255, green: 240 / 255, blue: 241 / 255, alpha: 1)
        
        let frame = view.frame
        let topDivider = UIView(frame: CGRect(x: 0, y: 10, width: width, height: 1))
        topDivider.backgroundColor = UIColor(red: 218 / 255, green: 219 / 255, blue: 220 / 255, alpha: 1)
        view.addSubview(topDivider)
        let bottomDivider = UIView(frame: CGRect(x: 0, y: frame.height, width: width, height: 1))
        bottomDivider.backgroundColor = UIColor(red: 218 / 255, green: 219 / 255, blue: 220 / 255, alpha: 1)
        view.addSubview(bottomDivider)
        
        let sectionTitle = UILabel(frame: CGRect(x: 0, y: 11, width: width, height: 44))
        sectionTitle.font = UIFont(name: "Lato", size: 15)
        sectionTitle.textColor = UIColor(red: 134 / 255, green: 134 / 255, blue: 134 / 255, alpha: 1)
        sectionTitle.backgroundColor = UIColor.white
        
        if (section == 0) {
            sectionTitle.text = "    " + "PROJECT"
        }
        else if (section == 1) {
            sectionTitle.text = "    " + "KEYWORDS"
        }
        else if (section == 2) {
            sectionTitle.text = "    " + "DETAILS"
        }
        else if (section == 3) {
            sectionTitle.text = "    " + LOCALSTR("COMMENTS")
        }
        
        view.addSubview(sectionTitle)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if (section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
            
            if (project == nil) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
                
                cell.content.isUserInteractionEnabled = false
                cell.content.textContainer.lineFragmentPadding = 0
                cell.content.textContainer.maximumNumberOfLines = 0
                cell.content.textContainer.lineBreakMode = .byWordWrapping
                cell.content.textColor = UIColor.gray
                cell.content.text = "Select a project"
                
                cell.selectionStyle = .none
                
                return cell
            }
            else {
                cell.name.text = project!.name
                
                var projectNumber = project!.number
                if projectNumber == "" {
                    projectNumber = "No Project Number"
                }
                cell.info.text = LOCALSTR("Project") + " #: \(projectNumber)"
                
                if (project!.client != nil) {
                    cell.client.text = LOCALSTR("Client") + ": \(project!.client!)"
                }
                else {
                    cell.client.text = ""
                    APIClient.getProjectCompanies(projectId: Int(project!.id)!, success: { (data) in
                        if let companyArray = data as? [AnyObject] {
                            if (companyArray.count > 0) {
                                if let companyObject = companyArray[0]["Company"] as? [String : Any] {
                                    self.project!.client = companyObject["Name"] as? String ?? ""
                                    do {
                                        try self.appDelegate.getManagedObjectContext()!.save()
                                    }
                                    catch {
                                        print(error)
                                    }
                                    tableView.reloadData()
                                }
                            }
                        }
                    }, failure: { (error) in
                        print(error)
                    })
                }
                
                if (project!.status != "") {
                    cell.status.text = LOCALSTR("Status") + ": \(project!.status)"
                }
                else {
                    cell.status.text = ""
                }
                
                cell.date.text = ""
                
                cell.deleteButton.isHidden = !isProjectEditable
                
                cell.layoutIfNeeded()
                cell.sizeToFit()
                cell.selectionStyle = .none
                
                project!.cellHeight = cell.mainView.frame.size.height
                
                return cell
            }
        }
        else if (section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            
            cell.content.isUserInteractionEnabled = false
            cell.content.textContainer.lineFragmentPadding = 0
            cell.content.textContainer.maximumNumberOfLines = 0
            cell.content.textContainer.lineBreakMode = .byWordWrapping
            
            if (keywords == "") {
                cell.content.textColor = UIColor.gray
                cell.content.text = "Add keywords"
            }
            else {
                cell.content.textColor = UIColor.black
                cell.content.text = keywords
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        else if (section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectContentCell", for: indexPath) as! SubjectContentCell
            
            cell.content.isUserInteractionEnabled = false
            cell.content.textContainer.lineFragmentPadding = 0
            cell.content.textContainer.maximumNumberOfLines = 0
            cell.content.textContainer.lineBreakMode = .byWordWrapping
            cell.content.textColor = UIColor.black
            
            cell.clearButton.isHidden = true
            cell.clearButtonWidthConstraint.constant = 0
            
            switch row {
            case 0:
                cell.subject.text = "Credit"
                if (credit == "") {
                    cell.content.textColor = UIColor.gray
                    cell.content.text = "No credit"
                }
                else {
                    cell.content.textColor = UIColor.black
                    cell.content.text = credit
                }
                
                break
                
            case 1:
                cell.subject.text = "Image Access"
                if (projectImage.accessLevel == "") {
                    cell.content.textColor = UIColor.gray
                    cell.content.text = "No access"
                }
                else {
                    cell.content.textColor = UIColor.black
                    cell.content.text = projectImage.accessLevel
                }
                break
                
            default:
                break
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        else if (section == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
            
            cell.content.isUserInteractionEnabled = false
            cell.content.textContainer.lineFragmentPadding = 0
            cell.content.textContainer.maximumNumberOfLines = 0
            cell.content.textContainer.lineBreakMode = .byWordWrapping
            
            if (comments == "") {
                cell.content.textColor = UIColor.gray
                cell.content.text = "Add comments"
            }
            else {
                cell.content.textColor = UIColor.black
                cell.content.text = comments
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if (section == 0) {
            if (isProjectEditable) {
                if (!ProjectManager.instance.isDownloaded) {
                    Util.showAlertMessage(title: APP_TITLE, message: "You should download projects first.", parent: self)
                    return
                }
                
                let subProjectListViewController = StoryboardManager.instance.projectStoryboard.instantiateViewController(withIdentifier: "SubProjectListViewController") as! SubProjectListViewController
                subProjectListViewController.delegate = self
                subProjectListViewController.type = 1
                subProjectListViewController.projects = ProjectManager.instance.projects
                navigationController!.pushViewController(subProjectListViewController, animated: true)
            }
        }
        else if (section == 1) {
            openTextDataView("Keywords", textData: keywords)
        }
        else if (section == 2) {
            if (row == 0) {
                openTextDataView("Credit", textData: credit)
            }
        }
        else if (section == 3) {
            openTextDataView("Comments", textData: comments)
        }
    }
    
    func openTextDataView(_ dataType: String, textData: String) {
        let textDataViewController = StoryboardManager.instance.projectStoryboard.instantiateViewController(withIdentifier: "TextDataViewController") as! TextDataViewController
        textDataViewController.delegate = self
        textDataViewController.dataType = dataType
        textDataViewController.textData = textData
        navigationController!.pushViewController(textDataViewController, animated: true)
    }
    
    ////////////////////////////////
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a caption"
            textView.textColor = UIColor.lightGray
        }
    }
    
    ////////////////////////////////
    
    func onSelectProject(_ selectedProject: Project) {
        project = selectedProject
        imageTableView.reloadData()
    }
    
    @IBAction func onDeleteProject(_ sender: UIButton) {
        project = nil
        imageTableView.reloadData()
    }
    
    ////////////////////////////////
    
    //  TextDataDelegate
    
    func onUpdateTextData(_ dataType: String, textData: String) {
        if (dataType == "Keywords") {
            keywords = textData
        }
        else if (dataType == "Credit") {
            credit = textData
        }
        else if (dataType == "Comments") {
            comments = textData
        }
        
        imageTableView.reloadData()
    }
    
    ////////////////////////////////
    
    //  UIKeyboardDidShowNotification
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        let keyboardInfo = (notification as NSNotification).userInfo!
        let keyboardFrameBegin: CGRect = (keyboardInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight = keyboardFrameBegin.size.height
        mainViewBottomConstraint.constant = -keyboardHeight
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        imageTableView.setContentOffset(CGPoint(x: 0, y: 420), animated: true)
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        mainViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    ////////////////////////////////
}
