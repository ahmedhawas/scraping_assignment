require 'erb'
require 'nokogiri'
require "open-uri"

def erb_test
	template = File.read('livescores_new.erb.html')

	page= Nokogiri::HTML(open("http://www.livescore.com/"))
	@scores= page.css('tr.even')

	erb_result = ERB.new( template ).result
	File.open('index.html','w') {|file| file.write(erb_result)}

end

erb_test