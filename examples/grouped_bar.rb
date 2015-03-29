require 'plotrb'

data = pdata.name('table') do
  url('data/groups.json')
end

cat_s = ordinal_scale.name('cat').padding(0.2).from('table.category').to_height
val_s = linear_scale.name('val').from('table.value').to_width.round.nicely
col_s = ordinal_scale.name('color').to_more_colors

xaxis = x_axis.scale(val_s)
yaxis = y_axis.scale(cat_s).tick_size(0).tick_padding(8)


pos_s = ordinal_scale.name('pos').from('table.position').to_height

rect_m = rect_mark.enter do
  y { scale(pos_s).from('position') }
  height { scale(pos_s).use_band }
  x { scale(val_s).from('value') }
  x2 { scale(val_s).value(0) }
  fill { scale(col_s).from('position')}
end

text_m = text_mark.enter do
  y { scale(pos_s).from('position') }
  dy { scale(pos_s).use_band.mult(0.5) }
  x { scale(val_s).from('value').offset(-4) }
  fill { value("white") }
  align { value("right") }
  baseline { value("middle") }
  text { from('value') }
end

facet_t = facet_transform.keys('category')

group_m = group_mark.from(data, facet_t) do
  scales pos_s
  marks rect_m, text_m
  enter do
    y { scale(cat_s).field('key') }
    height { scale(cat_s).use_band }
  end
end

vis = visualization.name('grouped_bar').width(300).height(240) do
  data data
  axes xaxis, yaxis
  scales cat_s,val_s,col_s
  marks group_m
end

puts vis.generate_spec(:pretty)
