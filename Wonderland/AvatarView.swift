/**
 Copyright (c) 2016 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

class AvatarView: UIView {
  
    var image: UIImage? {
        didSet {
            imageView.image = image
            setNeedsUpdateConstraints()
        }
    }
  
    var title: String? {
        didSet {
          titleLabel.text = title
        }
    }

    // Views
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private lazy var socialMediaView: UIStackView = {
        return AvatarView.createSocialMediaView()
    }()
        
    private var regularConstraints = [NSLayoutConstraint]()
    private var compactConstraints = [NSLayoutConstraint]()

    private var aspectRatioConstraint: NSLayoutConstraint?

    func setup() {
        
        imageView.contentMode = .ScaleAspectFit
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 28.0)
        titleLabel.textColor = UIColor.blackColor()
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(socialMediaView)
    }
        
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints       = false
        titleLabel.translatesAutoresizingMaskIntoConstraints      = false
        socialMediaView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        
        socialMediaView.axis = .Vertical
        
        // necessary
        titleLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active          = true
        imageView.bottomAnchor.constraintEqualToAnchor(titleLabel.topAnchor).active   = true
        imageView.topAnchor.constraintEqualToAnchor(topAnchor).active                 = true
        socialMediaView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        
        compactConstraints.append(titleLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor))
        compactConstraints.append(imageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor))
        compactConstraints.append(socialMediaView.topAnchor.constraintEqualToAnchor(topAnchor))
        
        regularConstraints.append(imageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor))
        regularConstraints.append(titleLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor))
        regularConstraints.append(socialMediaView.bottomAnchor.constraintEqualToAnchor(bottomAnchor))
    }
}

// MARK: - Override func
extension AvatarView {
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        setup()
        setupConstraints()
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.horizontalSizeClass == .Regular {
            NSLayoutConstraint.deactivateConstraints(compactConstraints)
            NSLayoutConstraint.activateConstraints(regularConstraints)
            
            socialMediaView.axis = .Horizontal
        }
        else {
            NSLayoutConstraint.deactivateConstraints(regularConstraints)
            NSLayoutConstraint.activateConstraints(compactConstraints)
            
            socialMediaView.axis = .Vertical
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 100)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        var aspectRatio: CGFloat = 1
        if let image = image {
            aspectRatio = image.size.width / image.size.height
        }
        
        aspectRatioConstraint?.active = false
        aspectRatioConstraint = imageView.widthAnchor.constraintEqualToAnchor(imageView.heightAnchor, multiplier: aspectRatio)
        aspectRatioConstraint?.active = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        socialMediaView.alpha = bounds.height < socialMediaView.bounds.height ? 0 : 1
        imageView.alpha = imageView.bounds.height < 30 ? 0 : 1
    }
}

