# Changelog

## 1.0.0

- ABI changes, more close to native UIAlertController
- Add ActionSheet style

## 0.1.4

- Another iOS 13 fix about transition

## 0.1.3

- Fix iOS 13 transitions bug
- Implemented Dark theme by default
- Remove dismiss interaction gesture (not present by default in UIAlertController from Apple) + causing toruble for iOS 13 with new presentation style

## 0.1.2

- Migrate to Swift 5
- Add syntaxic sugar
- Fix customView method

## 0.1.1

- Migrate to Swift 4.2
- Convert animation and code to iOS > 10.0 UIPropertyAnimator and Interruptible Animator
- Better handling of pull to dismiss transition
- Removing navigation transition setup
- Remove delay of keyboard dismiss when modal is dismissing
- Extandable style settings (typed settings key)
