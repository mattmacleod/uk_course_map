Array.class_eval do
	def _average
		count==0 ? 0 : sum / count
	end
end