
require 'hpricot'

=begin
task :test do
  
  #compc = ENV['compc']
  #a = Dir['src/com/**/*.as']
  #puts a
	#`/Volumes/Documents/SDK/flex_sdk_4.1.0.16076/bin/compc -include-sources=/Volumes/Documents/GIT/MINIMAL_COMPS/src/test.as -output=/Volumes/Documents/GIT/MINIMAL_COMPS/libs/test.swc -library-path+=/Volumes/Documents/GIT/MINIMAL_COMPS/assets/minimalcomps.swc`
end
=end

task :create_load_externs do
	
	report = ENV['report'] || 'build/temp/report.xml'
	load_externs = ENV['load_externs'] || 'build/temp/load-externs.xml'
  
  #puts "report file: #{report}"
  #puts "load-externs file: #{load-externs}"
	
	puts "File not found: #{load_externs}" if !File.exist? report
  
  
	# ouvrir le fichier de cette maniere force Hpricot
	# a fermer les noeuds <dep /> generes par mxmlc pour 
	# les rendre valide XHTML. Ce qui permet d'effectuer
	# la recherche via XPath
	doc = open(report) do |f|
	  Hpricot.XML(f)
	end
	
	elems = doc.search('//def')
	arr = [];
	
	if elems.size > 0
		elems.each do |e|
	  		id = e.attributes['id']
	  		arr << id if id.match /^(flashx\.)|(mx\.)/
		end
		
		arr.sort!
		
		file = File.open load_externs, 'w'
		file.puts '<data>'
		
		arr.each{ |e| file.puts "  <def id=\"#{e}\" />" }
		
		file.puts '</data>'
		file.close
	end
	
end




