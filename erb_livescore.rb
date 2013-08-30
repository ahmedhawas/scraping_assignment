require 'erb'
require 'nokogiri'
require "open-uri"

def erb_test
	template = File.read('livescores_new.erb.html')

	page= Nokogiri::HTML(open("http://www.livescore.com/"))

	@home_teams= page.css('td.fh')
	@away_teams= page.css('td.fa')
	@scores= page.css('td.fs')

	@home_t=Array.new
	@away_t=Array.new
	@home_t_s=Array.new
	@away_t_s=Array.new

	for i in 0..@home_teams.length-1
		@home_t[i] = @home_teams.at(i).text.strip
		@away_t[i] = @away_teams[i].text.strip
		@home_t_s[i] = @scores[i].text.strip[0,1]
		@away_t_s[i] = @scores[i].text.strip[3,4]
	end

	erb_result = ERB.new( template ).result
	File.open('index.html','w') {|file| file.write(erb_result)}
end

erb_test