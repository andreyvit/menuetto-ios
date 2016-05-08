import UIKit

private let sidePadding: CGFloat = 30

public class ViewController: UIViewController {

    private let repository = Repository.instance

    private var layout: UICollectionViewFlowLayout!
    private var collectionView: UICollectionView!

    private var objects: [MenuObject] = []

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(0xfcf5d8)

        layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(60, 0, 0, 0)
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(LogoCell.self, forCellWithReuseIdentifier: "logo")
        collectionView.registerClass(SectionCell.self, forCellWithReuseIdentifier: "section")
        collectionView.registerClass(ItemCell.self, forCellWithReuseIdentifier: "item")
        collectionView.backgroundColor = nil
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activateConstraints([
            collectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            collectionView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            collectionView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            collectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
        ])

        for section in repository.sections {
            objects.append(section)
            for item in section.items {
                objects.append(item)
            }
        }
    }

    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.reloadData()
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let obj = objects[indexPath.row]

        if let section = obj as? Section {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("section", forIndexPath: indexPath) as! SectionCell
//            cell.backgroundColor = UIColor.blueColor()
            cell.label.text = section.title.uppercaseString
            return cell

        } else if let item = obj as? Item {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath) as! ItemCell
//            cell.backgroundColor = UIColor.redColor()
            cell.label.text = item.name
            return cell

        } else {
            fatalError()
        }
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let obj = objects[indexPath.row]

        if obj is Section {
            return CGSize(width: collectionView.bounds.width, height: 50)

        } else if obj is Item {
            return CGSize(width: collectionView.bounds.width, height: 50)

        } else {
            fatalError()
        }
    }

}

public class LogoCell: UICollectionViewCell {

}

public class SectionCell: UICollectionViewCell {

    private var label = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(0xae1916)
        label.textAlignment = .Center
        label.font = UIFont(name: "AmericanTypewriter", size: 17)!
        self.addSubview(label)

        NSLayoutConstraint.activateConstraints([
            label.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 15),
            label.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -15),
            label.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor),
        ])
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public class ItemCell: UICollectionViewCell {

    private var label = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.blackColor()
        label.font = UIFont(name: "AmericanTypewriter", size: 15)!
        self.addSubview(label)

        NSLayoutConstraint.activateConstraints([
            label.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: sidePadding),
            label.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -sidePadding),
            label.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor),
        ])
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
