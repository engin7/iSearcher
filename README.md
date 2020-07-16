## iSearcher
iTunes Search App

#About
	iSearcher is an iOS app which connects to iTunes Search API and show users list of items. Visited links and deleted items persist across the launches of the app. 
	UserDefaults is used for data persistence as Data needed to store is just arrays with small number of strings.  Loading too much Data on UserDefaults could cause slowing down your app. UserDefaults  is a good choice for  flags to detect first launches, preferences, etc. For very large Data persistence CoreData framework or other 3rd party libraries could be used.
	
	MVC and Delegation design patterns are used during development of the application. MVC is an essential design pattern widely used in iOS development.  This pattern makes app more maintainable and scalable for future expansions. You can easily modify your code. Code becomes easier to visualize and easier to test.  Delegation is a design pattern that enables a class or structure to  delegate some of its responsibilities to an instance of another type. I needed to use this pattern to make animations right after deletion of an item. Because Detail screen and item list are different View Controllers. I also used it for deleteItem function in the Search class as I needed to delete an item from Data source so Tableview can display the updated Data source with animation.

You can get more info about MVC in Apple’s documentation:  https://developer.apple.com/library/archive/documentation/General/Conceptual/CocoaEncyclopedia/Model-View-Controller/Model-View-Controller.html

	This app most likely get rejected by AppStore as it’s a iTunes Search replica and might be found a simple app for the standards.  The app looks great most of the iPhone models, but for iPhone 11 pro 2 rows in landscape mode has too much space. It could have been 3 rows for better UI. 

#Requirements
 Minimum IOS deployment target 13.2 and support both Iphone and Ipad. No 3rd party libraries were used for this app.
 XCode 11.0+ Swift 5.0+

#License
This app is open source. If you find a bug please open an issue. Feel free to contribute.


*Please check iSearcherReport.pdf file for detailed Walkthrough of the app devolopment process. 
