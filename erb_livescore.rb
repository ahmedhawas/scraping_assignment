require 'erb'
require 'nokogiri'
require "open-uri"

def erb_test
	template = File.read('livescores_new.erb.html')

	page= Nokogiri::HTML(open("http://www.livescore.com/soccer/live/"))

	@home_teams= page.css('td.fh')
	@away_teams= page.css('td.fa')
	@scores= page.css('td.fs')
	@time= page.css('td.fd')

	@home_t=Array.new
	@away_t=Array.new
	@home_t_s=Array.new
	@away_t_s=Array.new
	@times = Array.new
	@updates = Array.new

	for i in 0..@home_teams.length-1
		@home_t[i] = @home_teams.at(i).text.strip
		@away_t[i] = @away_teams[i].text.strip
		@home_t_s[i] = @scores[i].text.strip[0,1].to_i
		@away_t_s[i] = @scores[i].text.strip[3,4].to_i
		@times[i] = @time[i].text.strip

		if (@home_t_s[i] > @away_t_s[i])
			@updates[i] = "#{@home_t[i]} side is leading against #{@away_t[i]} #{@home_t_s[i]} to #{@away_t_s[i]} "
		elsif (@home_t_s[i] < @away_t_s[i])
			@updates[i] = "Away side is leading against #{@home_t[i]} #{@away_t_s[i]} to #{@home_t_s[i]}"
		elsif (@home_t_s[i] == @away_t_s[i])
			@updates[i] = "#{@home_t[i]} and #{@away_t[i]} are tied #{@away_t_s[i]} each"
		else
			@updates[i] = "Match hasn't started yet!"	
		end
	end

	erb_result = ERB.new( template ).result
	File.open('index.html','w') {|file| file.write(erb_result)}
end

erb_test