# Wonderland
[教程原址](https://www.raywenderlich.com/125718/coding-auto-layout)

突然看到了`UILayoutAnchor`这么个东西，诶，啥时候有这个玩意儿了，点进去一看，发现是iOS9刚支持的约束，不过看了下比以前的UILayoutConstraint真的是方便多了，不过最后生成的约束还是UILayoutConstraint，只是通过UILayoutAnchor这么一个类简单的去生成constraint，如果使用过mansory，这个类很容易上手。　	
个人感觉还是mansory简洁。masonry可以同时设置多个约束，但是UILayoutAnchor只能一个一个设置。

文档中的例子

```
 +[NSLayoutConstraint constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:] 
 
 directly, you can instead do something like this:
 
 [myView.topAnchor constraintEqualToAnchor:otherView.topAnchor constant:10];
```
提供了更高效的方法，只要是将之前的attribute和item结合在了一起，减少了方法的参数个数

##func
```
@available(iOS 9.0, *)
public class NSLayoutAnchor : NSObject {
    
    /* These methods return an inactive constraint of the form thisAnchor = otherAnchor.
     */
    public func constraintEqualToAnchor(anchor: NSLayoutAnchor!) -> NSLayoutConstraint!
    public func constraintGreaterThanOrEqualToAnchor(anchor: NSLayoutAnchor!) -> NSLayoutConstraint!
    public func constraintLessThanOrEqualToAnchor(anchor: NSLayoutAnchor!) -> NSLayoutConstraint!
    
    /* These methods return an inactive constraint of the form thisAnchor = otherAnchor + constant.
     */
    public func constraintEqualToAnchor(anchor: NSLayoutAnchor!, constant c: CGFloat) -> NSLayoutConstraint!
    public func constraintGreaterThanOrEqualToAnchor(anchor: NSLayoutAnchor!, constant c: CGFloat) -> NSLayoutConstraint!
    public func constraintLessThanOrEqualToAnchor(anchor: NSLayoutAnchor!, constant c: CGFloat) -> NSLayoutConstraint!
}

/* Axis-specific subclasses for location anchors: top/bottom, leading/trailing, baseline, etc.
 */

@available(iOS 9.0, *)
public class NSLayoutXAxisAnchor : NSLayoutAnchor {
}

@available(iOS 9.0, *)
public class NSLayoutYAxisAnchor : NSLayoutAnchor {
}

/* This layout anchor subclass is used for sizes (width & height).
 */

@available(iOS 9.0, *)
public class NSLayoutDimension : NSLayoutAnchor {
    
    /* These methods return an inactive constraint of the form 
        thisVariable = constant.
    */
    public func constraintEqualToConstant(c: CGFloat) -> NSLayoutConstraint!
    public func constraintGreaterThanOrEqualToConstant(c: CGFloat) -> NSLayoutConstraint!
    public func constraintLessThanOrEqualToConstant(c: CGFloat) -> NSLayoutConstraint!
    
    /* These methods return an inactive constraint of the form 
        thisAnchor = otherAnchor * multiplier.
    */
    public func constraintEqualToAnchor(anchor: NSLayoutDimension!, multiplier m: CGFloat) -> NSLayoutConstraint!
    public func constraintGreaterThanOrEqualToAnchor(anchor: NSLayoutDimension!, multiplier m: CGFloat) -> NSLayoutConstraint!
    public func constraintLessThanOrEqualToAnchor(anchor: NSLayoutDimension!, multiplier m: CGFloat) -> NSLayoutConstraint!
    
    /* These methods return an inactive constraint of the form 
        thisAnchor = otherAnchor * multiplier + constant.
    */
    public func constraintEqualToAnchor(anchor: NSLayoutDimension!, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint!
    public func constraintGreaterThanOrEqualToAnchor(anchor: NSLayoutDimension!, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint!
    public func constraintLessThanOrEqualToAnchor(anchor: NSLayoutDimension!, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint!
}
```
Apple提供的方法可以直接生成NSLayoutConstraint，不过在使用时默认是不生效的，需要设置avtive=true

看一下就好，比较容易看懂。还有就是主意`translatesAutoresizingMaskIntoConstraints`这个参数，这个参数是UIView所拥有的，这个变量默认是true，我们设置过frame之后，它会将frame自动转换成约束。Masonry在使用时会将translatesAutoresizingMaskIntoConstraints设置成false

#THE END
Apple 也是越来越为开发者考虑了啊 棒棒哒 😊😊😊
