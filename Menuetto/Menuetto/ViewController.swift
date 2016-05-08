import UIKit

private let sidePadding: CGFloat = 30

public class ViewController: UIViewController {

    private let repository = Repository.instance

    private var layout: UICollectionViewFlowLayout!
    private var collectionView: UICollectionView!

    private var objects: [MenuObject] = []

    private let itemSizingCell = ItemCell()
    private var itemSizingCellConstraint: NSLayoutConstraint!

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(0xfcf5d8)

        layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(60, 0, 0, 0)
        layout.itemSize = CGSize(width: 100, height: 44)
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

        itemSizingCellConstraint = itemSizingCell.widthAnchor.constraintGreaterThanOrEqualToConstant(320)
        itemSizingCellConstraint.active = true
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
            configureCell(cell, forItem: item)
            return cell

        } else {
            fatalError()
        }
    }

    private func configureCell(cell: ItemCell, forItem item: Item) {
        cell.titleLabel.text = item.title
        cell.priceLabel.text = item.price
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let obj = objects[indexPath.row]

        if obj is Section {
            return CGSize(width: collectionView.bounds.width, height: 50)

        } else if let item = obj as? Item {
            configureCell(itemSizingCell, forItem: item)

            itemSizingCellConstraint.constant = view.bounds.width
            let size = itemSizingCell.systemLayoutSizeFittingSize(CGSizeMake(view.bounds.width, 0))
            return CGSize(width: view.bounds.width, height: size.height)

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
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 17)!
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

    private var titleLabel = UILabel()
    private var priceLabel = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont(name: "AmericanTypewriter", size: 15)!
        titleLabel.numberOfLines = 0
        self.addSubview(titleLabel)

        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textColor = UIColor.blackColor()
        priceLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 15)!
        priceLabel.textAlignment = .Right
        self.addSubview(priceLabel)

        NSLayoutConstraint.activateConstraints([
//            self.heightAnchor.constraintGreaterThanOrEqualToConstant(44),

            titleLabel.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: sidePadding),
            titleLabel.rightAnchor.constraintEqualToAnchor(priceLabel.leftAnchor, constant: -15),
//            titleLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor),
            titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -10),

            priceLabel.widthAnchor.constraintEqualToConstant(150),
            priceLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -sidePadding),
            priceLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor),
        ])
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    private var cachedWidth: CGFloat?

//    public override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let attrs = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
//////        attrs.frame.size.width = super.bounds.width
////        attrs.size.width = 320 //super.bounds.width
//        return attrs
//    }

}
