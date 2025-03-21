# AstroPic

## Description
This feature provides Astronomy Picture of the Day for the past 7 days with its details.

* Screen1 (list view)
  - This page displays the list of Picture with the date and title as header
  - Error message pop ups during failure such as network error etc. The the refresh button on the top right can be used to reload the page
* Screen2 (detail view)
  - When a picture on screen1 is tapped it shows picture with it's description (explanation).
  - Here the picture can be zoomed
  - Description can be scrolled
* Unit test
  - Sample unit test cases for View models and Service are written as much as possible

Assumption
* Thumbnail images have been used for Video media_type
* 7 days have been considered including current date. So it would display the images as per the image availabilty on the server.
* This app will run on iPhone and iPad for portrait orientation. If given additional time, landscape orientation can be supported.
* apod-api timezone is assumed to UTC for sending start_date since API doc does not specify time zone and UTC is the standard. end_date is not sent for safety against API timezone mismatch . By default it takes today date as per the doc.
* Dates in the Picture list screen are displayed in the server timezone as there is no time and zone info associated with it.

Decision
* MVVM architecture with Router is used as it provides a simple way to achieve modularity and testability.
* UIKit is used for UI development as I am more confortable with it compared to SwiftUI and since the assignment is timebound. I am in the learning phase of SwiftUI.
* Kingfisher library is used for image downoading, caching and showing activity indicator while downloading to save the time.
