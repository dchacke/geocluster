require "spec_helper"

describe Geocluster do
  describe '#cluster_coordinates' do
    specify 'Two coordinates that are nearby are clustered' do
      clusters = Geocluster.cluster_coordinates([[52.5200065, 13.404954], [52.5094156, 13.4533962], [52.3941887, 13.072691]]) # Berlin, Berlin-Kreuzberg, Potsdam
      clusters.should eq [{:coordinates => [52.3941887, 13.072691000000003], :count => 3}] # One cluster above those three coordinates, centered where most coordinates are
    end

    specify 'No nocleus clusters geographically centered' do
      clusters = Geocluster.cluster_coordinates([[52.5200065, 13.404954], [52.5094156, 13.4533962], [52.3941887, 13.072691]], :nucleus => false) # Berlin, Berlin-Kreuzberg, Potsdam
      clusters.should eq [{:coordinates=>[52.474657748317775, 13.310132265262823], :count=>3}] # One cluster above those three coordinates, geographically centered
    end

    specify 'Make clusters smaller' do
      clusters = Geocluster.cluster_coordinates([[52.5200065, 13.404954], [52.5094156, 13.4533962], [52.3941887, 13.072691]], :precision => 4) # Berlin, Berlin-Kreuzberg, Potsdam
      clusters.should eq [{:coordinates => [52.50941559999999, 13.453396199999998], :count => 2}, {:coordinates => [52.3941887, 13.072691000000003], :count => 1}] # Two clusters, only two coordinates are close enough to be merged
    end

    specify 'Limit returned clusters' do
      clusters = Geocluster.cluster_coordinates([[52.5200065, 13.404954], [52.5094156, 13.4533962], [52.3941887, 13.072691]], :precision => 4, :limit => 1) # Berlin, Berlin-Kreuzberg, Potsdam
      clusters.should eq [{:coordinates => [52.50941559999999, 13.453396199999998], :count => 2}] # Only one cluster because of limitation
    end
  end
end