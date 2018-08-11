require 'Date'
require 'Oj'
require 'yaml'

require_relative '..\Methods\loadPoptypes.rb'

mod_dir = 'C:\Program Files (x86)\Steam\steamapps\common\Victoria 2'
write_dir = 'C:\Program Files (x86)\Steam\steamapps\common\Victoria 2\mod\VictoriaII-Save-Parser\Mod Data\Vanilla'

poptypes = loadPoptypes(mod_dir)



write_location = write_dir + '\\Poptypes.yaml'	
File.write(write_location, poptypes.to_yaml)
