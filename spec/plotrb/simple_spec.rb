#--
# simple_spec.rb: specs for simple plot shortcuts 
# Copyright (c) 2013 Colin J. Fuller and the Ruby Science Foundation
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#   - Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
#   - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the
#   distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
# WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#++

require 'spec_helper'
require 'plotrb/simple'

describe Plotrb::Simple do 

  context "scatter plots" do
    before :each do
      @xdata = [0,1,2,3,4,5]
      @ydata = [[0,1,4,9,16,25],[0,1,8,27,64,125]]
    end

    it "should correctly make a scatter plot with supplied options" do
      Plotrb::Simple.scatter(@xdata, @ydata, markersize: 40, domain: [0,10], range: [0,125], color: ['red', 'blue'], width: 1000, height: 1000, symbol: ['triangle-up', 'triangle-down']).generate_spec.should eq '{"width":1000,"height":1000,"data":[{"name":"scatter","values":[{"x0":0,"y0":0,"y1":0},{"x0":1,"y0":1,"y1":1},{"x0":2,"y0":4,"y1":8},{"x0":3,"y0":9,"y1":27},{"x0":4,"y0":16,"y1":64},{"x0":5,"y0":25,"y1":125}]}],"scales":[{"name":"scatter_x","type":"linear","domain":[0,10],"range":"width"},{"name":"scatter_y","type":"linear","domain":[0,125],"range":"height"}],"marks":[{"type":"symbol","from":{"data":"scatter"},"properties":{"enter":{"size":{"value":40},"shape":{"value":"triangle-up"},"x":{"field":"data.x0","scale":"scatter_x"},"y":{"field":"data.y0","scale":"scatter_y"},"fill":{"value":"red"}}}},{"type":"symbol","from":{"data":"scatter"},"properties":{"enter":{"size":{"value":40},"shape":{"value":"triangle-down"},"x":{"field":"data.x0","scale":"scatter_x"},"y":{"field":"data.y1","scale":"scatter_y"},"fill":{"value":"blue"}}}}],"axes":[{"type":"x","scale":"scatter_x"},{"type":"y","scale":"scatter_y"}]}'
    end

    it "should correctly make a scatter plot with default options and multiple data series" do
      Plotrb::Simple.scatter(@xdata, @ydata).generate_spec.should eq '{"width":640,"height":480,"data":[{"name":"scatter","values":[{"x0":0,"y0":0,"y1":0},{"x0":1,"y0":1,"y1":1},{"x0":2,"y0":4,"y1":8},{"x0":3,"y0":9,"y1":27},{"x0":4,"y0":16,"y1":64},{"x0":5,"y0":25,"y1":125}]}],"scales":[{"name":"scatter_x","type":"linear","domain":{"data":"scatter","field":"data.x0"},"range":"width"},{"name":"scatter_y","type":"linear","domain":{"data":"scatter","field":"data.y0"},"range":"height"}],"marks":[{"type":"symbol","from":{"data":"scatter"},"properties":{"enter":{"size":{"value":20},"shape":{"value":"circle"},"x":{"field":"data.x0","scale":"scatter_x"},"y":{"field":"data.y0","scale":"scatter_y"},"fill":{"value":"blue"}}}},{"type":"symbol","from":{"data":"scatter"},"properties":{"enter":{"size":{"value":20},"shape":{"value":"circle"},"x":{"field":"data.x0","scale":"scatter_x"},"y":{"field":"data.y1","scale":"scatter_y"},"fill":{"value":"blue"}}}}],"axes":[{"type":"x","scale":"scatter_x"},{"type":"y","scale":"scatter_y"}]}'
    end

    it "should correctly make a scatter plot with default options and a single data series" do
      Plotrb::Simple.scatter(@xdata, [0,1,4,9,16,25]).generate_spec.should eq '{"width":640,"height":480,"data":[{"name":"scatter","values":[{"x0":0,"y0":0},{"x0":1,"y0":1},{"x0":2,"y0":4},{"x0":3,"y0":9},{"x0":4,"y0":16},{"x0":5,"y0":25}]}],"scales":[{"name":"scatter_x","type":"linear","domain":{"data":"scatter","field":"data.x0"},"range":"width"},{"name":"scatter_y","type":"linear","domain":{"data":"scatter","field":"data.y0"},"range":"height"}],"marks":[{"type":"symbol","from":{"data":"scatter"},"properties":{"enter":{"size":{"value":20},"shape":{"value":"circle"},"x":{"field":"data.x0","scale":"scatter_x"},"y":{"field":"data.y0","scale":"scatter_y"},"fill":{"value":"blue"}}}}],"axes":[{"type":"x","scale":"scatter_x"},{"type":"y","scale":"scatter_y"}]}'
    end

    it "should correctly make a scatter plot with default options and multiple x and y data series" do
      @xdata = [[0,1,2,3,4,16], [10,11,12,13,14,15]]
      Plotrb::Simple.scatter(@xdata, @ydata).generate_spec.should eq '{"width":640,"height":480,"data":[{"name":"scatter","values":[{"x0":0,"y0":0,"x1":10,"y1":0},{"x0":1,"y0":1,"x1":11,"y1":1},{"x0":2,"y0":4,"x1":12,"y1":8},{"x0":3,"y0":9,"x1":13,"y1":27},{"x0":4,"y0":16,"x1":14,"y1":64},{"x0":16,"y0":25,"x1":15,"y1":125}]}],"scales":[{"name":"scatter_x","type":"linear","domain":{"data":"scatter","field":"data.x0"},"range":"width"},{"name":"scatter_y","type":"linear","domain":{"data":"scatter","field":"data.y0"},"range":"height"}],"marks":[{"type":"symbol","from":{"data":"scatter"},"properties":{"enter":{"size":{"value":20},"shape":{"value":"circle"},"x":{"field":"data.x0","scale":"scatter_x"},"y":{"field":"data.y0","scale":"scatter_y"},"fill":{"value":"blue"}}}},{"type":"symbol","from":{"data":"scatter"},"properties":{"enter":{"size":{"value":20},"shape":{"value":"circle"},"x":{"field":"data.x1","scale":"scatter_x"},"y":{"field":"data.y1","scale":"scatter_y"},"fill":{"value":"blue"}}}}],"axes":[{"type":"x","scale":"scatter_x"},{"type":"y","scale":"scatter_y"}]}'
    end
  end
end


