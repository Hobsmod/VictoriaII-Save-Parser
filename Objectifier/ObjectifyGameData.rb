require 'Date'
require 'Oj'
require 'yaml'

require_relative '..\Methods\loadPoptypes.rb'
require_relative '..\Methods\loadProdtypes.rb'
require_relative '..\Methods\loadTech.rb'

mod_dir = 'C:\Program Files (x86)\Steam\steamapps\common\Victoria 2'
write_dir = 'C:\Program Files (x86)\Steam\steamapps\common\Victoria 2\mod\VictoriaII-Save-Parser\Mod Data\Vanilla'

poptypes = loadPoptypes(mod_dir)
prod_types = loadProdtypes(mod_dir)
tech = loadTech(mod_dir)


File.write(write_dir + '\\Poptypes.yaml', poptypes.to_yaml)
File.write(write_dir + '\\production_types.yaml', prod_types.to_yaml)
File.write(write_dir + '\\technologies.yaml', tech.to_yaml)
