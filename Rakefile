require 'json'

CONFIG = JSON.parse(`parse-hocon global.conf`)

desc 'produce vector tiles'
task :produce do
  sh [
    #"curl #{CONFIG['URL']}/mokuroku.csv.gz |",
    "cat mokuroku.csv.gz |",
    "zcat |",
    #"head -n 10 |",
    "parallel ",
    "--line-buffer",
    "--retries=3",
    "-j 8",
    "ruby filter.rb |",
    #"tee stream.geojsons |",
    "tippecanoe",
    "--force",
    "-o tiles.mbtiles",
    "--minimum-zoom=#{CONFIG['MINZOOM']}",
    "--maximum-zoom=#{CONFIG['MAXZOOM']}",
    "; tile-join",
    "--force",
    "--no-tile-compression",
    "--output-to-directory=docs/zxy",
    "--no-tile-size-limit",
    "tiles.mbtiles"
  ].join(' ')
end

desc 'run vt-optimizer'
task :optimize do
  sh "node ../vt-optimizer/index.js -m tiles.mbtiles"
end

desc 'host the site'
task :host do
  sh "budo -d docs"
end

desc 'build style.json'
task :style do
  sh "parse-hocon hocon/style.conf > docs/style.json"
  sh "gl-style-validate docs/style.json"
end

