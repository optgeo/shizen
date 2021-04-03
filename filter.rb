return unless /^(\d*)\/(\d*)\/(\d*)\.geojson/.match ARGV[0]

require 'json'
require 'rake'

CONFIG = JSON.parse(`parse-hocon global.conf`)
(z, x, y) = [$1, $2, $3].map {|v| v.to_i}

fc = JSON.parse(`curl #{CONFIG['URL']}/#{z}/#{x}/#{y}.geojson`)

fc['features'].each {|f|
  f['tippecanoe'] = {
    minzoom: case f['properties']['type']
    when '島', '山', '河川', '湖沼', '湾・灘', 
      '海峡・水道', '高原・平原・湿原'
      CONFIG['MINZOOM']
    else
      CONFIG['MAXZOOM']
    end,
    maxzoom: CONFIG['MAXZOOM'],
    layer: f['properties']['class']
  }
  f['properties']['gaijiFlg'] = f['properties']['gaijiFlg'].to_i
  f['properties'].delete('class')
  f['properties'].delete('lfSpanFr')
  print JSON.dump(f), "\n"
}
