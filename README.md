# SwiftAutoLayoutHelpers
convenient functions for iOS autolayout mechanism


examples of use:

inside a UICollectionViewCell I have these lines of code after the init()

    addSubview(containerView)
    containerView.addSubview(imageView)
    containerView.addSubview(annotation)
    
    //
    containerView.anchorTo(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, padding: PinterestCell.cellInset)
    //
    imageView.anchorTo(top: containerView.topAnchor, right: containerView.rightAnchor, left: containerView.leftAnchor)
    //
    annotationHeightConstraint = annotation.anchorTo(top: imageView.bottomAnchor, right: containerView.rightAnchor, bottom: containerView.bottomAnchor, left: containerView.leftAnchor, heightConstant: 0, rightPadding: PinterestCell.cellInset, leftPadding: PinterestCell.cellInset).last


which result in this beautiful layout:

![image one](cell1.png)

![image two](cell2.png)
