SJADNShareController
=====

If you already have an `NSButton` and suitable `NSSharingServicePicker` code written, simply set your `NSSharingServicePicker`'s delegate to be `SJADNShareController`.

`SJADNShareController *ADNShareController = [[SJADNShareController alloc] init];
sharingServicePicker.delegate = ADNShareController;`

*Otherwise*, [take a look on Stack Overflow to see how to setup a share button, on Mountain Lion](http://stackoverflow.com/a/11815632/447697), then, see the first paragraph above.