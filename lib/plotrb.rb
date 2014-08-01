require 'yajl'
require 'json'
require 'uri'

require_relative 'plotrb/base'

require_relative 'plotrb/data'
require_relative 'plotrb/transforms'
require_relative 'plotrb/scales'
require_relative 'plotrb/marks'
require_relative 'plotrb/axes'
require_relative 'plotrb/kernel'
require_relative 'plotrb/visualization'
require_relative 'plotrb/legends'
require_relative 'plotrb/simple'

module Plotrb

end

class Object

  include ::Plotrb::Kernel

end

if defined? IRuby
  IRuby.display(IRuby.javascript(%{
    require.config({paths: {
       d3: 'http://d3js.org/d3.v3.min',
       d3_geo: 'http://trifacta.github.io/vega/lib/d3.geo.projection.min',
       topojson: 'http://trifacta.github.io/vega/lib/topojson',
       vg: 'http://trifacta.github.io/vega/vega.min'
    }});
    require(['d3', 'vg', 'd3_geo', 'topojson'], function(d3, vg, d3_geo, topojson) {
        window.d3 = d3;
        window.vg = vg;
        var event = document.createEvent('HTMLEvents');
        event.initEvent('load_plotrb',false,false);
        window.dispatchEvent(event);
    });
}))
end
