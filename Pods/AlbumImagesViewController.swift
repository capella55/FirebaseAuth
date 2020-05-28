import UIKit
import Photos

class AlbumImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AlbumSelectionDelegate {

    let owner = "AlbumImagesViewController"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var multiPhotoButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var arrowImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageWidthConstraint: NSLayoutConstraint!
    
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var delegate: PhotoCaptureDelegate?
    
    let manager = PHImageManager.default()
    let requestOptions = PHImageRequestOptions()
    
    let titleFont = UIFont.boldSystemFont(ofSize: 17)
    let screenWidth = UIScreen.main.bounds.width
    var itemWidth: CGFloat = 0
    
    var albumId: String?
    var albumTitle = "Photos"
    var galleryImages = [GalleryImage]()
    var previewImage: UIImage?
    var isSelecting = false
    var isShowingAll = false
    var count = 0
    
    var selectedUnassignedIndexes = [Int]()
    var selectedIndexes = [Int]()
    
    var activeImage = UIImage(named: "ActiveDoubleIcon")
    var inactiveImage = UIImage(named: "InactiveDoubleIcon")
    let selectedStatusImage = UIImage(named: "SelectedCircle")
    let unselectedStatusImage = UIImage(named: "UnselectedCircle")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        itemWidth = screenWidth / 4 - 1
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.headerReferenceSize = CGSize(width: screenWidth, height: 40)
        
        imageCollectionView.collectionViewLayout = flowLayout
        imageCollectionView.reloadData()
        
        requestOptions.resizeMode = .exact
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = true
        
        PHPhotoLibrary.requestAuthorization { (status) in
            PhotoHelper.getCameraRollAlbum { (phAssetCollection) in
                if let collection = phAssetCollection {
                    self.loadAlbum(collection)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageCollectionView.reloadData()
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
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onNext(_ sender: UIButton) {
        let totalCount = selectedUnassignedIndexes.count + selectedIndexes.count
        if (totalCount == 0) {
            return
        }
        else {
            var selectedImages = [GalleryImage]()
            for unassignedIndex in selectedUnassignedIndexes {
                let galleryImage = GalleryImage()
                galleryImage.image = ProjectManager.instance.unassignedImages[unassignedIndex]
                selectedImages.append(galleryImage)
            }
            
            for index in selectedIndexes {
                selectedImages.append(galleryImages[index])
            }
            
            delegate?.onSelectPhotos(selectedImages)
            dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func onTitle(_ sender: UIButton) {
        let albumListViewController = storyboard!.instantiateViewController(withIdentifier: "AlbumListViewController") as! AlbumListViewController
        albumListViewController.delegate = self
        albumListViewController.currentAlbumTitle = albumTitle
        present(albumListViewController, animated: true, completion: nil)
    }
    
    func updateTitle() {
        titleLabel.text = albumTitle
    }
    
    func onSelectAlbum(_ album: PHAssetCollection) {
        galleryImages.removeAll()
        selectedUnassignedIndexes.removeAll()
        selectedIndexes.removeAll()
        imageCollectionView.reloadData()
        previewImage = nil
        loadAlbum(album)
    }
    
    func loadAlbum(_ album: PHAssetCollection) {
        PhotoHelper.getAssetsFromAlbum(album, completion: { (assets) in
            self.albumTitle = album.localizedTitle ?? "Photos"
            self.count = assets.count
            for asset in assets {
                let galleryImage = GalleryImage()
                galleryImage.asset = asset
                self.galleryImages.append(galleryImage)
            }
            
            DispatchQueue.main.async {
                self.updateTitle()
                self.imageCollectionView.reloadData()
            }
            
            if let galleryImage = self.galleryImages.first {
                if let asset = galleryImage.asset {
                    self.manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: self.requestOptions) { (image, info) in
                        if (image != nil) {
                            galleryImage.asset = asset
                            galleryImage.image = image
                            galleryImage.info = info
                            
                            DispatchQueue.main.async {
                                self.previewImageView.image = image
                            }
                        }
                    }
                }
            }
        })
    }

    ////////////////////////////////
    
    //  UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let totalCount = selectedUnassignedIndexes.count + selectedIndexes.count
        let isShowingTitle = !isSelecting || totalCount == 0
        
        titleLabel.text = isShowingTitle ? albumTitle : "\(totalCount) Photo\(totalCount > 1 ? "s" : "") Selected"
        arrowImageView.isHidden = !isShowingTitle
        arrowImageLeadingConstraint.constant = isShowingTitle ? 5 : 0
        arrowImageWidthConstraint.constant = isShowingTitle ? 11 : 0
        
        return Util.sign(count: ProjectManager.instance.unassignedImages.count) + Util.sign(count: galleryImages.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LibraryImageSectionView", for: indexPath) as? LibraryImageSectionView {
            let section = indexPath.section
            if (section == 0 && Util.sign(count: ProjectManager.instance.unassignedImages.count) > 0) {
                let count = ProjectManager.instance.unassignedImages.count
                sectionHeader.primaryInfoLabel.text = "UNASSIGNED"
                let buttonTitle = isSelecting ? (!isShowingAll ? "See All (\(count))" : "See Fewer") : "Manage (\(count))"
                sectionHeader.secondaryInfoButton.setTitle(buttonTitle, for: .normal)
                sectionHeader.secondaryInfoButton.isHidden = false
            }
            else if (section == Util.sign(count: ProjectManager.instance.unassignedImages.count) && Util.sign(count: galleryImages.count) > 0) {
                sectionHeader.primaryInfoLabel.text = albumTitle.uppercased()
                sectionHeader.secondaryInfoButton.isHidden = true
            }
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0 && Util.sign(count: ProjectManager.instance.unassignedImages.count) > 0) {
            var count = ProjectManager.instance.unassignedImages.count
            if (!isSelecting || !isShowingAll) {
               count = min(4, count)
            }
            return count
        }
        else if (section == Util.sign(count: ProjectManager.instance.unassignedImages.count) && Util.sign(count: galleryImages.count) > 0) {
            return galleryImages.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageItemCell", for: indexPath as IndexPath) as! ImageItemCell
        
        let section = indexPath.section
        let row = indexPath.row
        
        cell.statusImage.isHidden = !isSelecting
        cell.statusImage.tag = row
        
        if (section == 0 && Util.sign(count: ProjectManager.instance.unassignedImages.count) > 0) {
            cell.itemImage.image = ProjectManager.instance.unassignedImages[row]
            let bSelected = selectedUnassignedIndexes.contains(row)
            if (isSelecting) {
                cell.statusImage.image = bSelected ? selectedStatusImage : unselectedStatusImage
                cell.alpha = 1.0
            }
            else {
                cell.alpha = bSelected ? 0.8 : 1.0
            }
        }
        else if (section == Util.sign(count: ProjectManager.instance.unassignedImages.count) && Util.sign(count: galleryImages.count) > 0) {
            let galleryImage = galleryImages[row]
            if let thumbnailImage = galleryImage.thumbnailImage {
                cell.itemImage.image = thumbnailImage
            }
            else {
                if let asset = galleryImage.asset {
                    manager.requestImage(for: asset, targetSize: CGSize(width: self.itemWidth, height: self.itemWidth), contentMode: .aspectFill, options: self.requestOptions) { (image, info) in
                        if (image != nil) {
                            galleryImage.asset = asset
                            galleryImage.thumbnailImage = image
                            galleryImage.info = info
                            DispatchQueue.main.async {
                                cell.itemImage.image = image
                                self.imageCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
            
            let bSelected = selectedIndexes.contains(row)
            if (isSelecting) {
                cell.statusImage.image = bSelected ? selectedStatusImage : unselectedStatusImage
                cell.alpha = 1.0
            }
            else {
                cell.alpha = bSelected ? 0.8 : 1.0
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if (section == 0 && Util.sign(count: ProjectManager.instance.unassignedImages.count) > 0) {
            previewImage = ProjectManager.instance.unassignedImages[row]
            if (isSelecting) {
                if let index = selectedUnassignedIndexes.firstIndex(of: row) {
                    selectedUnassignedIndexes.remove(at: index)
                }
                else {
                    selectedUnassignedIndexes.append(row)
                }
            }
            else {
                selectedUnassignedIndexes.removeAll()
                selectedUnassignedIndexes.append(row)
            }
        }
        else if (section == Util.sign(count: ProjectManager.instance.unassignedImages.count) && Util.sign(count: galleryImages.count) > 0) {
            let galleryImage = galleryImages[row]
            if let image = galleryImage.image {
                previewImage = image
            }
            else {
                if let asset = galleryImage.asset {
                    manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: self.requestOptions) { (image, info) in
                        if (image != nil) {
                            galleryImage.image = image
                            self.previewImage = image
                            DispatchQueue.main.async {
                                self.previewImageView.image = image
                            }
                        }
                    }
                }
            }
            
            if (isSelecting) {
                if let index = selectedIndexes.firstIndex(of: row) {
                    selectedIndexes.remove(at: index)
                }
                else {
                    selectedIndexes.append(row)
                }
            }
            else {
                selectedIndexes.removeAll()
                selectedIndexes.append(row)
            }
        }
        
        imageCollectionView.reloadData()
        previewImageView.image = previewImage
    }
    
    ////////////////////////////////
    
    @IBAction func onMultiSelection(_ sender: UIButton) {
        isSelecting = !isSelecting
        
        selectedIndexes.removeAll()
        selectedUnassignedIndexes.removeAll()
        multiPhotoButton.setImage(isSelecting ? activeImage : inactiveImage, for: .normal)
        imageCollectionView.reloadData()
    }
    
    @IBAction func onSecondaryAction(_ sender: UIButton) {
        if (isSelecting) {
            isShowingAll = !isShowingAll
            imageCollectionView.reloadData()
        }
        else {
            let projectImagesViewController = StoryboardManager.instance.projectStoryboard.instantiateViewController(withIdentifier: "ProjectImagesViewController") as! ProjectImagesViewController
            projectImagesViewController.imageType = 1
            
            let navigationViewController = UINavigationController(rootViewController: projectImagesViewController)
            present(navigationViewController, animated: false, completion: nil)
        }
    }
    
    ////////////////////////////////
}
