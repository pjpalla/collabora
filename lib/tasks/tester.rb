require '../../config/environment'
require_relative 'processor'


@uids = User.where(:place => "medio campidano")
indicator = "i8_1"
i = Indicator.where(:uid => @uids).where("#{indicator} <> 0 and #{indicator} is not NULL").count
puts i
# lower_limit = 1
# upper_limit = 6
# sub_range = (lower_limit..upper_limit)

# sub_indicators = Array.new(upper_limit, 0)

# n = 8
# if n == 8

#     sub_range.each do |i|
#         indicator = "i" + n.to_s
#         indicator += "_#{i}"
#         puts indicator
        
#         end     
# end


# include SurveysHelper

# NUM_OF_INDICATORS = 11
# NUM_OF_SUBINDICATORS = 6
# note = "note 1 i1:aaaa i2: bfdf fg i8_1: adflkdlfkjld i8_2: akdjflwo i8_5:slkdfjaslkdf i10: ckcdkddk, i11: akakakakk, i10: xxxxx"

# counter = Array.new(NUM_OF_INDICATORS, 0)
# i8_sub_counter = Array.new(NUM_OF_SUBINDICATORS, 0)


# indicators = note.scan(/i[1-9]\d?_?[1-6]?/)
#      indicators.each do |indicator|
#             case indicator
#                 when /i1\z/
#                     counter[0] += 1
#                 when /i2/
#                     counter[1] += 1
#                 when /i3/
#                     counter[2] += 1
#                 when /i4/ 
#                     counter[3] += 1
#                 when /i5/
#                     counter[4] += 1
#                 when /i6/
#                     counter[5] += 1
#                 when /i7/
#                     counter[6] += 1
#                 when /i8_?[1-6]?/
#                     counter[7] += 1
#                     if indicator =~ /i8_1/
#                         i8_sub_counter[0] += 1
#                     elsif indicator =~ /i8_2/
#                         i8_sub_counter[1] += 1
#                     elsif indicator =~ /i8_3/
#                         i8_sub_counter[2] += 1
#                     elsif indicator =~ /i8_4/
#                         i8_sub_counter[3] += 1
#                     elsif indicator =~ /i8_5/
#                         i8_sub_counter[4] += 1
#                     elsif indicator =~ /i8_6/
#                         i8_sub_counter[5] += 1
#                     end
#                 when /i9/
#                     counter[8] += 1
#                 when /i10/
#                     counter[9] += 1
#                 when /i11/
#                     counter[10] += 1
#             end
#             binding.pry
#       end

# ind = Indicator.new do |i|
#  i.uid = 12324
#  i.card = "B0000"
#  i.i1 = counter[0]
#  i.i2 = counter[1]
#  i.i3 = counter[2]
#  i.i4 = counter[3]
#  i.i5 = counter[4]
#  i.i6 = counter[5]
#  i.i7 = counter[6]
#  i.i8 = counter[7]
#  i.i9 = counter[8]
#  i.i10 = counter[9]
#  i.i11 = counter[10]
#  #### subindicators
#  i.i8_1 = i8_sub_counter[0]
#  i.i8_2 = i8_sub_counter[1]
#  i.i8_3 = i8_sub_counter[2]
#  i.i8_4 = i8_sub_counter[3]
#  i.i8_5 = i8_sub_counter[4]
#  i.i8_6 = i8_sub_counter[5]
# end


# ind_attributes = ind.attributes
# ind_attributes.each do |i|
#     puts(i)
# end
# card_number = build_default_card_number
# puts(card_number)


# @location = "medio campidano"


# if @location == "sardegna"
#     @uids = User.all.pluck(:uid)
# elsif @location == "sardegna eccetto medio campidano"
#     @uids = User.where.not(place: 'medio campidano').pluck(:uid)
# elsif @location == "altro"
#     @uids = User.where.not(place: @locations).pluck(:uid) ###### da sistemare --RVD!!!!!!
# else
#     @uids = User.where(place: @location).pluck('uid')
# end




### Qui ricaviamo gli intervistati che facendo uso di farmaci generici hanno avuto degli effetti indesiderati
# w = Answer.distinct.where(qid: "5", subid: "0", uid: @uids).where.not(answer: nil).pluck(:uid)
# #w = Answer.select('uid').distinct.where("qid = 5 and subid = 0 and answer is not null").map{|a| a.uid}
# #to_remove = Answer.select('uid').distinct.where("qid = 1 and subid = 0 and (answer like 'n%' or answer like 'N%')").map{|a| a.uid}
# to_remove = Answer.distinct.where(qid: "1", subid: "0", uid: @uids).where("answer like 'n%' or answer like 'N%'").pluck(:uid)
# filtered_w = w - to_remove

# all_positive_answers = Answer.distinct.where(qid: "1", subid: "0", uid: @uids).where("answer like 's%' or answer like 'S%'").pluck(:uid)
# all_not_nil_5_answers = Answer.distinct.where(qid: "5", subid: "0", uid: @uids).where.not(answer: nil).pluck(:uid)


# note = "i10: prima di prendere un farmaco, consulto sempre il bugiardino"


# indicators = note.scan(/i[1-9]\d?./)
# puts indicators
# counter = Array.new(11, 0)
#         indicators.each do |indicator|
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
                 
#                   end      


# print counter
# puts ""
# ### The directory containing our data files
# SOURCE_DIR = Rails.root.join('files4')

# #questionnaire = Questionnaire.create(quid: 1, description: "Questionario progetto collabora")
# # ### Here we load the questions into the database

# # #questionnaire = Questionnaire.first
# qst_file = File.join(SOURCE_DIR, 'I0757.docx')
# qprocessor = Processor.new(qst_file)
# # #binding.pry

# # ### Get question, subquestions and notes
# q, n, subs = qprocessor.get_question(1)


# # ## Question
# puts "question: #{q}"
# puts "subs: #{subs}"

# ## Note
# puts "note: #{qprocessor.get_note(8)}"


# # Question 8


# ### Subquestions

# subs.each do |s|
#     puts "subquestion: #{s}"
# end unless subs.nil?


# ## Answers

# answer = qprocessor.get_answer(1, 1)
# puts "answer: #{answer}"

# #user = qprocessor.get_user


# #puts "User: #{user}"
# # counter = Processor.get_indicators(2)
# # puts counter

# #Get indicators


# choices = qprocessor.get_question_choices(8)
# puts "choices: #{choices}"
# #puts "Choices"
# #puts choices[0]

# # n, c, d = qprocessor.get_drug(choice)
# # print n,c,d

# # puts "*** Get answer ****"


# #a =  qprocessor.get_answer(1,1)
# #puts "answer id: #{a.id}"
# #puts "answer text: #{a.answer}"
# #puts "answer: #{a}"

# #user = qprocessor.get_user
# #puts "user sex: #{user.sex}"

# # puts "Answer length: #{a.length}"
# # puts "is a Array?: #{a.is_a? Array}"

# # note = qprocessor.get_note(6)
# # puts "Note to question 6: #{note}"

