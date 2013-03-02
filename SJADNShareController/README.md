SJADNShareController
=====

###About

SJADNShareController can be used to share text only (at the moment) to [App.net](http://app.net), either as part of the sharing menu, on Mountain Lion, or alone.

It uses App.net's web post intent and opens the post box already filled in, in the user's browser.

###Usage

####With NSSharingServicePickr (Mountain Lion only)

If you already have an `NSButton` and suitable `NSSharingServicePicker` code written, simply set your `NSSharingServicePicker`'s delegate to be `SJADNShareController`.

`SJADNShareController *ADNShareController = [[SJADNShareController alloc] init];`

`sharingServicePicker.delegate = ADNShareController;`

Otherwise, [take a look on Stack Overflow to see how to setup a share button, on Mountain Lion](http://stackoverflow.com/a/11815632/447697), then, see the paragraphs above.

####Standalone

Use `shareItems:`. Example:

`SJADNShareController *ADNShareController = [[SJADNShareController alloc] init];`

`[ADNShareController shareItems:[NSArray arrayWithObject:@"Here's some text to share on App.net!"]];`

###License

The license for this code is the same as for the rest of the code in this repository.

<a rel="license" href="http://creativecommons.org/licenses/by/3.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by/3.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 Unported License</a>.