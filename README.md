# Pure Modal
Haven't done much documentation comments yet.
## How to use
### Import Module
- Download
- Drag into Xcode
- Build Framework
- Add Framework into Embeded Binaries in Target Info
- add import PureModal at top of .swift file if needed

### Use PureAlert
- New an instance with title, message and style:
  - let controller = PureAlertController(withTitle:message:style)

  - alternatively:
    - let controller = PureAlertController()
    - controller.title = "Title"
    - controller.alertMessage = "message"
    - controller.alertStyle = .default(buttonTitle: "OK")
- You pass a PureAlertViewStyle enumeration case with an associated value into the style argument, such as
  - .autoDismiss(after: 1)
- Present PureAlertController instance by calling:
  - modal(animated:for:)
- Set delegate to custom function of alert controller
  - controller.delegate = self
