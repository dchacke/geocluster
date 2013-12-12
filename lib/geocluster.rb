require "geocluster/version"
require "pr_geohash"
require "geocoder"

module Geocluster
  extend self
  ##
  # Takes an array of coordinates in the form of [[lat,lon], [lat,lon], ...]
  # as well as an options hash consisting of precision,
  # limit and nucleus, returning an array of clusters and the
  # count of clustered coordinates for each, in the form of
  # [{ :coordinates => [lat,lon], :count => 3 }, { :coordinates => [lat,lon], :count => 2 }, ...]
  # 
  def cluster_coordinates(coordinates, options = {})
    # Set default options
    options = {
      :precision => 3, # the higher, the finer the clusters will be
      :limit => nil,   # max number of returned clusters; set to nil to get all
      :nucleus => true # if true, centers clusters over where most of its coordinates are; if false, centers clusters geographically among all coordinates it absorbs
    }.merge!(options)

    # Convert coordinates into geohashes to easily find neighboring coordinates
    geohashes = coordinates.map{ |c| GeoHash.encode(c.first, c.last, 24) }
    # ["u33dc0cpnnf4", "u281zd9xrtww", "u1hcy2ukdhpb", "u1hg6jsr0znd", "u33616p4rb8v", "u0vug9dwefde", "u0yjjd6jk0yv"] 

    # Get stripped to first {precision} chars and unique
    # coordinates; these are the keys for a temporary hash
    cut_hashes = geohashes.map{ |h| h[0..options[:precision] - 1]}
    keys = cut_hashes.uniq
    # ["u33", "u28", "u1h", "u0v", "u0y"]

    # Get occurences count for keys
    values = keys.map{ |h| cut_hashes.count(h)}
    # [2, 1, 2, 1, 1]

    # Convert keys and values to hash which
    # associates geo-clusters with coodinates count
    clusters_hash = Hash[keys.zip(values)]
    # {"u33"=>2, "u28"=>1, "u1h"=>2, "u0v"=>1, "u0y"=>1}

    # Sort by count desc (turns clusters into an
    # array); at this point, we have all clusters and
    # the number of coodinates per cluster
    clusters = clusters_hash.sort_by{ |key, value| value }.reverse
    # [["u33", 2], ["u1h", 2], ["u0v", 1], ["u28", 1], ["u0y", 1]]

    # Only take into account up until limit
    unless options[:limit].nil?
      clusters = clusters[0..options[:limit] - 1]
    end

    # Iterate over clusters and find center
    # (either geographical or nucleus)
    coordinates_with_counts = []
    if options[:nucleus] == true
      clusters.each do |cluster|
        # Select geohashes from cluster matching the first {precision} chars
        select_hashes = geohashes.select{ |g| g[0..options[:precision] - 1] == cluster.first }
        
        # Get array of associations between select hash and no. of occurences of that select hash in cluster
        select_hashes_with_counts = select_hashes.map{ |s| { "#{s}" => select_hashes.count(s) } }

        # Get select hash with the most occurences in cluster and add to all top coordinates in clusters
        # Calculating the geographic center is needed because Geohash.decode returns a geo-square
        top_hash = select_hashes_with_counts.sort_by{ |hash| hash.values.first }.reverse.first.keys.first
        coordinates_with_counts << { :coordinates => Geocoder::Calculations.geographic_center(GeoHash.decode(top_hash)), :count => cluster.last }
      end
    else
      clusters.each do |cluster|
        # Select geohashes from cluster matching the first {precision} chars
        select_hashes = geohashes.select{ |g| g[0..options[:precision] - 1] == cluster.first }

        # Transform geohashes into coordinates
        select_coordinates = select_hashes.map{ |s| Geocoder::Calculations.geographic_center(GeoHash.decode(s)) }

        # Calculate geographical center of all coordinates in this cluster and assign to array of all centers
        # Calculating the geographic center is needed because Geohash.decode returns a geo-square
        centered_coordinates_pair = Geocoder::Calculations.geographic_center(select_coordinates)
        coordinates_with_counts << { :coordinates => centered_coordinates_pair, :count => cluster.last }
      end
    end

    # At this point, coordinates_with_counts looks like
    # [{:coordinates => [33.83140579999999, -118.2820165], :count => 7}, { :coordinates => [52.52000659999998, 13.404954000000002], :count => 2}]
    # In this example, seven coordinates in cluster one, two coordinates in cluster two
    coordinates_with_counts
  end
end
