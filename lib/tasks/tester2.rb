require '../../config/environment'
frange = ("F1016".."F1252") ### franci - 217
irange = ("I1081".."I1552") ## ila - 380
brange = ("B0001".."B0317") ##bb - 157
  
    
    ### Card range for indicators i9, i10, i11
card_range1 = ("I1262".."I1552") ##204
card_range2 = ("B0168".."B0317") ##68


indicator = "i5"
date_limit = DateTime.new(2019, 1, 1)
@location = "medio campidano"


if @location == "sardegna"
    @uids = User.all.pluck(:uid)
elsif @location == "sardegna eccetto medio campidano"
    @uids = User.where.not(place: 'medio campidano').pluck(:uid)
elsif @location == "altro"
    @uids = User.where.not(place: @locations).pluck(:uid) ###### da sistemare --RVD!!!!!!
else
    @uids = User.where(place: @location).pluck('uid')
end

   

# i = Indicator.where("card between ? and ? or card between ? and ? or card between ? and ?", 
# frange.first, frange.last, irange.first, irange.last, brange.first, brange.last).select(indicator).group("#{indicator}").count

i1 = Indicator.where(:uid => @uids).where("card between ? and ? or card between ? and ? or card between ? and ? or created_at >= ?", 
frange.first, frange.last, irange.first, irange.last, brange.first, brange.last, date_limit).select(indicator).group("#{indicator}").count

uid1 = Indicator.where(:uid => @uids).where("card between ? and ? or card between ? and ? or card between ? and ? or created_at >= ?", 
frange.first, frange.last, irange.first, irange.last, brange.first, brange.last, date_limit).where("#{indicator} = 1 or #{indicator} = 2").pluck(:uid)

uid2 = Indicator.where(:uid => @uids).where("#{indicator} = 1 or #{indicator} = 2").pluck(:uid) 


#i1 = Indicator.where.any_of({:card => frange}, {:card => irange}, {:card => brange}).select(indicator).group("#{indicator}").count


# puts(i)
puts(i1)
puts(uid1.length)
puts(uid2.length)
puts("ids: #{uid2 - uid1}")


# counter = Array.new(12, 0)
# note = "i8, i7 djfajdlfk i9"
# indicators = note.scan(/i[1-9]\d?./)

# indicators.each do |indicator|
#                         case indicator
#                             when /i1\D/ 
#                                 counter[0] += 1
#                             when /i2/
#                                 counter[1] += 1
#                             when /i3/
#                                 counter[2] += 1
#                             when /i4/ 
#                                 counter[3] += 1
#                             when /i5/
#                                 counter[4] += 1
#                             when /i6/
#                                 counter[5] += 1
#                             when /i7/
#                                 counter[6] += 1
#                             when /i8/
#                                 counter[7] += 1
#                             when /i9/
#                                 counter[8] += 1
#                             when /i10/
#                                 counter[9] += 1
#                             when /i11/
#                                 counter[10] += 1
#                         end
#                  end
                 

# print(counter)                 