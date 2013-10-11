#--
# simple.rb:  Shortcuts for making some simple plots.
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

module Plotrb
  module Simple

    SCATTER_DATA_NAME = 'scatter'
    SCATTER_X_SCALE_NAME = 'scatter_x'
    SCATTER_Y_SCALE_NAME = 'scatter_y'

    #
    # Data name used by scatter plot
    #
    def self.scatter_data_name
      SCATTER_DATA_NAME
    end

    #
    # Scale name used by scatter plot for x axis
    #
    def self.scatter_x_scale_name
      SCATTER_X_SCALE_NAME
    end

    #
    # Scale name used by scatter plot for y axis
    #
    def self.scatter_y_scale_name
      SCATTER_Y_SCALE_NAME
    end

    #
    # Generate a simple 2d scatter plot.
    #
    # @param [NMatrix, Array] x the x datapoints; if a single row, will be used
    #   for all y dataseries, if multiple rows, each row of x will be used for
    #   the corresponding row of y
    # @param [NMatrix, Array] y the y datapoints.  Can be a single dimensional array,
    #   or 2D with multiple series in rows; column dimension should match the
    #   number of elements in x.
    # @param [String, Array<String>] symbol the type of symbol to be used to
    #   plot the points.  Can be any symbol Vega understands: circle, square,
    #   cross, diamond, triangle-up, triangle-down.  If a single String is
    #   provided, this will be used for all the points.  If an Array of Strings
    #   is provided, each symbol in the array will be used for the corresponding
    #   data series (row) in y.  Default: 'circle'
    # @param [String, Array<String>] color the color to be used to plot the
    #   points.  If a single String is provided, this will be used for all the
    #   points.  If an Array of Strings is provided, each color in the array will
    #   be used for the corresponding data series (row) in y.  Default: 'blue'
    # @param [Numeric] markersize the size of the marker in pixels. Default: 20
    # @param [Numeric] width the visualization width in pixels. Default: 640
    # @param [Numeric] height the visualization height in pixels. Default: 480
    # @param [Array, String] domain the domain for the plot (limits on the
    #   x-axis).  This can be a 2-element array of bounds or any other object
    #   that Plotrb::Scale::from understands.  Default: scale to x data
    # @param [Array, String] range the range for the plot (limits on the
    #   y-axis).  This can be a 2-element array of bounds or any other object
    #   that Plotrb::Scale::from understands.  Default: scale to first row of
    #   y.
    # 
    # @return [Plotrb::Visualization] A visualization object.  (This can be
    #   written to a json string for Vega with #generate_spec.)
    #
    # method signature for ruby 2.0 kwargs:
    # def scatter(x, y, symbol: 'circle', color: 'blue', markersize: 20,
    #            width: 640, height: 480, domain: nil, range: nil)
    def self.scatter(x, y, kwargs={})
      kwargs = {symbol: 'circle', color: 'blue', markersize: 20, width: 640,
                height: 480, domain: nil, range: nil}.merge(kwargs)
      symbol = kwargs[:symbol]
      color = kwargs[:color]
      markersize = kwargs[:markersize]
      width = kwargs[:width]
      height = kwargs[:height]
      domain = kwargs[:domain]
      range = kwargs[:range]
      
      datapoints = []
      n_sets = 1
      x_n_sets = 1
      x_size = x.size

      if x.respond_to?(:shape) and x.shape.length > 1 then  # x is 2D NMatrix
        x_n_sets = x.shape[0]
        x_size = x.shape[1]
      elsif x.instance_of? Array and x[0].instance_of? Array then # x is nested Array
        x_n_sets = x.size
        x_size = x[0].size
      end

      if y.respond_to?(:shape) and y.shape.length > 1 then # y is 2D NMatrix
        n_sets = y.shape[0]
      elsif y.instance_of? Array and y[0].instance_of? Array then # y is nested array
        n_sets = y.size
      end

      x_size.times do |i|
        dp = {}
        n_sets.times do |j|

          xj = j.modulo(x_n_sets)
          if x.respond_to?(:shape) and x.shape.length > 1 then
            dp["x#{xj}".to_sym] = x[xj, i]
          elsif x.instance_of? Array and x[0].instance_of? Array then
            dp["x#{xj}".to_sym] = x[xj][i]
          else
            dp["x#{xj}".to_sym] = x[i]
          end

          indices = [i]
          if y.respond_to?(:shape) and y.shape.length > 1 then
            indices = [j,i]
          end
          if y.instance_of? Array and y[0].instance_of? Array then
            dp["y#{j}".to_sym] = y[j][*indices]
          else
            dp["y#{j}".to_sym] = y[*indices]
          end
        end

        datapoints << dp
      end

      Plotrb::Kernel.data.delete_if { |d| d.name == scatter_data_name }
      dataset= Plotrb::Data.new.name(scatter_data_name)
      dataset.values(datapoints)

      domain_in = "#{scatter_data_name}.x0"
      if domain then
        domain_in = domain
      end
      range_in = "#{scatter_data_name}.y0"
      if range then
        range_in = range
      end

      Plotrb::Kernel.scales.delete_if { |d| d.name == scatter_x_scale_name or d.name == scatter_y_scale_name }

      xs = linear_scale.name(scatter_x_scale_name).from(domain_in).to_width
      ys = linear_scale.name(scatter_y_scale_name).from(range_in).to_height

      marks = []
      n_sets.times do |j|
        marks << symbol_mark.from(dataset) do
          c_j = color.instance_of?(Array) ? color[j] : color
          s_j = symbol.instance_of?(Array) ? symbol[j] : symbol
          x_j = j.modulo(x_n_sets)
          enter do
            x_start { scale(xs).from("x#{x_j}") }
            y_start { scale(ys).from("y#{j}") }
            size markersize
            shape s_j
            fill c_j
          end
        end
      end

      visualization.width(width).height(height) do
        data dataset
        scales xs, ys
        marks marks
        axes x_axis.scale(xs), y_axis.scale(ys)
      end
    end
  end
end

