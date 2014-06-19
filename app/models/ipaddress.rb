class Ipaddress
	def self.find(ip)
	   begin
		Net::HTTP.start('int.dpool.sina.com.cn') do |http|
			response=http.get('/iplookup/iplookup.php?format=json&ip='+ip)
			if response.code =='200'
				 address=JSON.parse(response.body)
				 if address['ret']==1
				 province=Location.roots.where('name like ?',address['province']+'%').first
				 city=province.children.where('name like ?',address['city']+'%').first
				end

			end

			end
		rescue
		nil
		end

	end


end