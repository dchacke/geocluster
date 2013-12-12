# Geocluster

Geocluster takes an array of geographic coordinates and converts them into clusters of different size and weight.

Example usage with Google Maps:

![Example usage](http://s14.directupload.net/images/131212/xh5xojbs.png)

## Installation

Add this line to your application's Gemfile:

    gem 'geocluster'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geocluster

## Usage

You can cluster coordinates using

    Geocluster.cluster_coordinates(coordinates, options = {})
    
and passing it an array of the coordinates you would like to cluster. For example:

    Geocluster.cluster_coordinates(
      [[52.5200065, 13.404954], [52.5094156, 13.4533962], [52.3941887, 13.072691]]
    )
    # => [{ :coordinates => [52.3941887, 13.072691000000003], :count => 3}]
    # Returns the position of your new cluster associated
    # with the number of coordinates it consumed.

You can also pass the following options (default values are assigned below):

    options = {
      :precision => 3, # the higher, the finer the clusters will be
      :limit => nil,   # max number of returned clusters; set to nil to get all
      :nucleus => true # if true, centers clusters over where most of its coordinates are;
                       # if false, centers clusters geographically among all coordinates it absorbs
    }

Example usage:

    Geocluster.cluster_coordinates(
      [[52.5200065, 13.404954], [52.5094156, 13.4533962], [52.3941887, 13.072691]],
      precision: 5,
      limit: 2,
      nucleus: false
    )

Clustering may come in handy for displaying a myriad of coordinates on a map.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
