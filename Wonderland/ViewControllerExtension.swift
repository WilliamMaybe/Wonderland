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

extension ViewController {
  
    // MARK:- Add the subviews
      
    func addViews() {
        
        // Add bookTextView
        view.addSubview(bookTextView)
        bookTextView.font = UIFont.systemFontOfSize(12)
        bookTextView.selectable = false
        bookTextView.editable = false
    
        // Add chapterLabel
        chapterLabel.textAlignment = .Center
        view.addSubview(chapterLabel)
    
        // Add avatarView
        view.addSubview(avatarView)
    }

    // MARK:- Color the views
      
    func colorViews() {
        // color views for reference
        bookTextView.backgroundColor = UIColor.greenColor()
        chapterLabel.backgroundColor = UIColor.yellowColor()
        avatarView.backgroundColor = UIColor.cyanColor()
    }

    // MARK:- Set up frames before using Auto Layout
      
    func setupFrames() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        // setup frames
        let bookTextViewHeight = screenHeight * 0.65
        bookTextView.frame = CGRect(x: 0,
          y: screenHeight-bookTextViewHeight,
          width: screenWidth,
          height: bookTextViewHeight)
        chapterLabel.sizeToFit()
        chapterLabel.frame = CGRect(x: 0,
          y: bookTextView.frame.origin.y - chapterLabel.bounds.height,
          width: screenWidth,
          height: chapterLabel.bounds.height)
        avatarView.frame = CGRect(x: 0,
          y: 0,
          width: screenWidth,
          height: screenHeight - bookTextView.bounds.height
            - chapterLabel.bounds.height)
    }
    
    // MARK:- Set up frame by using Auto Layout
    func setupConstraints() {
        bookTextView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.translatesAutoresizingMaskIntoConstraints   = false
        chapterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bookTextView.leadingAnchor.constraintEqualToAnchor(view.readableContentGuide.leadingAnchor).active   = true
        bookTextView.trailingAnchor.constraintEqualToAnchor(view.readableContentGuide.trailingAnchor).active = true
        bookTextView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor, constant: -20).active = true
        bookTextView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.65).active        = true
        
        avatarView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active                 = true
        avatarView.leadingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.leadingAnchor).active   = true
        avatarView.trailingAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.trailingAnchor).active = true
        avatarView.bottomAnchor.constraintEqualToAnchor(chapterLabel.topAnchor, constant: -10).active    = true
        
        chapterLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        chapterLabel.bottomAnchor.constraintEqualToAnchor(bookTextView.topAnchor).active = true
        
        chapterLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        chapterLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
    }
    
    
    // MARK:- Swipe Gesture setup
      
    func addGestures() {
        
        // Next Chapter
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeChapter(_:)))
        swipeRightGesture.direction = .Right
        bookTextView.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeChapter(_:)))
        swipeLeftGesture.direction = .Left
        bookTextView.addGestureRecognizer(swipeLeftGesture)
    }
      
      
    func changeChapter(gesture:UISwipeGestureRecognizer) {
        var chapter = chapterNumber
        if gesture.direction == .Right {
          chapter -= 1
        }
        if gesture.direction == .Left {
          chapter += 1
        }
        if book.loadChapter(chapter) {
          chapterNumber = chapter
        }
        updateViews()
    }
      
    // MARK:- Book Loading
      
    func updateViews() {
        bookTextView.text = book.chapterText
        chapterLabel.text = "Chapter \(chapterNumber)"
        avatarView.title = book.title
        if let imageName = book.chapterImageName {
          avatarView.image = UIImage(named: imageName)
        }
        bookTextView.contentOffset = .zero
        bookTextView.scrollRectToVisible(
          CGRect(origin: .zero, size: bookTextView.bounds.size),
          animated: false)
    }
      
      
    // MARK:- Scroll text on rotation
      
    override func viewDidLayoutSubviews() {
        bookTextView.scrollRangeToVisible(visibleRangeOfTextView(bookTextView))
    }
    
    // courtesy of
    // http://stackoverflow.com/a/28896715/359578
      
    private func visibleRangeOfTextView(textView: UITextView) -> NSRange {
        let bounds = textView.bounds
        let origin = CGPointMake(100,100) //Overcome the default UITextView left/top margin
        let startCharacterRange = textView.characterRangeAtPoint(origin)
        if startCharacterRange == nil {
          return NSMakeRange(0,0)
        }
        let startPosition = textView.characterRangeAtPoint(origin)!.start
        
        let endCharacterRange = textView.characterRangeAtPoint(CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)))
        if endCharacterRange == nil {
          return NSMakeRange(0,0)
        }
        let endPosition = textView.characterRangeAtPoint(CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)))!.end
        
        let startIndex = textView.offsetFromPosition(textView.beginningOfDocument, toPosition: startPosition)
        let endIndex = textView.offsetFromPosition(startPosition, toPosition: endPosition)
        return NSMakeRange(startIndex, endIndex)
    }
      
    // MARK:- View Controller methods
      
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }

}