

def clean_counts(counts)
      l = []
      h = Hash.new
      counts.each do |k,v|
            tmp_key = k.gsub(/\s*\/\s*/, '/')
            tmp_key = tmp_key.gsub("  ", " ")
            if h.keys.include?(tmp_key)
                h[tmp_key] += v
            else
               h[tmp_key] = v    
            end
            binding.pry
      end        
      h
  end      