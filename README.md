Put a Pic on It!

Called like:

    http://putapicon.it/:width/:height/:image_search_string.jpg

e.g. http://putapicon.it/400/200/puppies.jpg

or 

    http://putapicon.it/:square/mage_search_string.jpg

e.g. http://putapicon.it/350/kittens+and+puppies.jpg

or

    http://putapicon.it/:width_by_height/image_search_string.jpg

e.g. http://putapicon.it/350x450/cute+animals.jpg

or 

    http://putapicon.it/:common_ad_size/image_search_string.jpg

e.g. http://putapicon.it/skyscraper?bicycles.jpg


The first time a query string is used, we run a Google image search, download the original images, and resize them to your specification. After that, the images are cached and ready to go in that size for subsequent requests. If you request another size with the same query string we skip the download and just resize the cached originals.