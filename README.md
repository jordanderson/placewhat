#  [Put a Pic On It!](http://putapicon.it)

In the spirit of <a href="http://placepuppy.it/">placepuppy</a>, <a href="http://lorempixel.com/">lorempixel</a>, and <a href="http://flickholdr.com/">flickholdr</a>, **putapicon.it** generates placeholder images. Specify any search string and putapicon.it finds matches via Google image search and serves them to you randomly in the specified size. 

The first time an image search string is used, we run a Google image search, download up to 8 original images, and resize them to your specification. After that, the images are cached and ready to go in that size for subsequent requests. If you request another size using the same search string we skip the download and resize the cached originals.

When you enter an image search string we've never seen before, we're downloading, resizing, and caching multiple images. However, we serve the first image that's ready and do the rest in the background. You should generally not need to wait more than a second or two for an image.  

## Usage

- `http://putapicon.it/:width/:height/:image_search_string.jpg`

  Examples: [http://putapicon.it/400/200/puppies.jpg](http://putapicon.it/400/200/puppies.jpg) or [http://putapicon.it/800/600/new_york_skyline.jpg](http://putapicon.it/800/600/new_york_skyline.jpg)

- `http://putapicon.it/:square/:image_search_string.jpg`

  Examples: [http://putapicon.it/350/kittens+and+puppies.jpg](http://putapicon.it/350/kittens+and+puppies.jpg) or [http://putapicon.it/128/profile_picture.jpg](http://putapicon.it/128/profile_picture.jpg)

- `http://putapicon.it/:width_by_height/:image_search_string.jpg`

  Examples: [http://putapicon.it/350x450/cute+animals.jpg](http://putapicon.it/350x450/cute+animals.jpg) or [http://putapicon.it/100x200/pizza_with_bacon.jpg](http://putapicon.it/350x450/pizza_with_bacon.jpg)

- `http://putapicon.it/:common_ad_size/:image_search_string.jpg`

  Allowed ad sizes include: *skyscraper, halfpage, leaderboard, mediumrectangle, squarepopup, verticalrectangle, largerectangle, rectangle, popunder, fullbanner, halfbanner, microbar, button1, button2, verticalbanner, squarebutton, and wideskyscraper*
  
  Examples: [http://putapicon.it/largerectangle/luxury+apartment.jpg](http://putapicon.it/largerectangle/luxury+apartment.jpg) or [http://putapicon.it/skyscraper/skyscraper.jpg](http://putapicon.it/skyscraper/skyscraper.jpg) ;)
  
  
## Tips
- At the moment, we only search for and serve jpegs.
- You can use spaces in your image search strings. We treat underscores like spaces so `http://putapicon.it/350/miniature_ponies.jpg` is the same as `http://putapicon.it/350/miniature ponies.jpg`.
- Obviously no one is curating or validating the images so you might get some duds.
- Safe search is turned on so you don't embarrass yourself on demo day.


