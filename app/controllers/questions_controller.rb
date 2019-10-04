

class QuestionsController < ApplicationController
    include QuestionsHelper       
    
    
  def index

    @questions = Question.all
    qids = @questions.map{|q| q.qid}
    @num_of_questions = qids.uniq.length
    #binding.pry
  end
  
  def show
     
    @locations = ["medio campidano", "cagliari", "oristano", "nuoro", "sassari","sardegna", "sardegna eccetto medio campidano", "altro"]
    #@locations = User.distinct.pluck(:place) + @basic_locations
    #@locations.uniq!
    
    @location = "medio campidano"
    
    if params[:locations]
      @location = params[:locations].downcase!
      logger.debug "@location: #{@location}"
    end 
    
    #@uids = User.where(place: 'medio campidano').pluck(:uid)
    #### Answer by area ###
    @uids = User.where(place: @location).pluck(:uid)
    if @location == "sardegna"
        @uids = User.all.pluck(:uid)
    elsif @location == "sardegna eccetto medio campidano"
        @uids = User.where.not(place: 'medio campidano').pluck(:uid)
        logger.debug "eccetto: #{@uids.length}"
    elsif @location == "altro"
        @uids = User.where.not(place: @locations)
    end
      
      
      
     @subq_mapping = {1 => "A", 2 => "B", 3 => "C", 4 => "D"} 
     @first_question = 1
     @last_question = 18
     question_idx = [2, 3, 4, 5,  6, 7]
     @subquestion_idx = [4, 5, 7, 11]
     qone = get_reference_question(params[:id].to_i, @uids)
     #binding.pry
     #logger.warn "qone: #{qone}"
     

     #parent_one = 1
     
     @question = Question.where("qid = ? AND subid = ?", params[:id], 0)[0]
     @question_number = Question.where(subid: 0).length
     opt = QuestionOption.where("qid = ? AND subid = ?", params[:id], 0)
     @options = opt.map{|o| o.odescription}
     
    # counter = []
     total = []
     #########################
     
     Answer.where(qid: params[:id], subid: 0, uid: @uids).each do |a|
         if question_idx.include? a.qid
             #parent_ans = Answer.where(qid: parent_one, subid: 0, uid: a.uid)[0].answer
             parent_ans = qone[a.uid]
              #logger.debug "parent answer (controller): #{parent_ans}"
                if parent_ans =~ /no\s*/i || parent_ans.nil?
                     #logger.debug "inside if"
                     next
                end
                #binding.pry
         end
         total << a.answer

    end
      
       #logger.debug "Total: #{total}"
       @counts = Hash.new 0
       @count_drugs = Hash.new 0
       @count_categories = Hash.new 0
       #resp_vect = []

       logger.debug "total length: #{total.length}"
       total.each do |resp|
           resp = resp.downcase unless resp.nil?
           resp.nil? ? resp = "nessuna risposta" : resp.strip!
           #binding.pry
           #logger.debug("resp: #{resp}")
           if resp =~ /^farmaco/
              #logger.warn "resp: #{resp}"
                resp_vect = resp.split(",").map{|w| w.downcase}
                #logger.debug "Resp vect: #{resp_vect}"
                drug = resp_vect[0].gsub("farmaco: ", "").strip
                #logger.info "Drug: #{drug}"
                category = resp_vect[1].gsub("categoria: ", "").strip
                #logger.info "Category: #{category}"
              unless drug.nil? || drug == ""
                    drug = sanitize_drug_name(drug)
                    @count_drugs[drug] += 1
              end
             
              unless category.nil? || category == ""
                    category = sanitize_drug_category(category)
                    @count_categories[category] += 1
              end
           end
           
           @counts[resp] += 1
        end
 
    #logger.debug "Counts: #{@counts}"
     #binding.pry
     #binding.pry
     @counts.slice!("sì", "no") if [5, 6, 7].include? @question.qid
     ### Here we remove the key "nessuna risposta" from the hash
     @counts.reject!{|k| k == "nessuna risposta"}
     #### Here we clean duplicate values
     @counts = clean_counts(@counts)
     #logger.debug("Counts after cleaning: #{@counts}")
     #binding.pry
     
     @count_drugs = filter_counts(@count_drugs, 0)
     #binding.pry
     ###here we sort by value in descending order
     @count_drugs = (@count_drugs.sort_by{|drug, count| -count}).to_h
     
     
     @count_categories = filter_counts(@count_categories, 0)
     @count_categories = (@count_categories.sort_by{|category, count| -count}).to_h
     #binding.pry
     logger.debug "count_categories: #{@count_categories}"
     @subquestions = Question.where("qid = ? AND subid <> 0", params[:id])
     @suboptions = QuestionOption.where("qid = ? AND subid <> 0", params[:id])
     #binding.pry
     logger.debug "count_drugs: #{@count_drugs}"
     respond_to do |format|
       if request.xhr?
          logger.debug "XHR request"
          logger.debug "ajax param: #{@location}"
          logger.debug "uids controller: #{@uids.length}"
          format.js 
       else  
        format.html
       end  
     end
     
  end
  
    def edit
        id = params[:id]
        @question = Question.where(qid: id)[0]
    end    
  
    def notes
      @answers = Answer.all.order(:qid)

    end      

  
  
  
  private
  def get_reference_question(qid, uids)
        question_id = case qid
        when 1..7 then 1
        when 9..10 then 9
        end    
        #logger.warn "question_id: #{question_id}"
        ### Temporary solution for medio campidano
        #@uids = User.where(place: "medio campidano").pluck(:uid)
        q = Answer.where(qid: question_id, subid: 0, uid: uids)
        # q = Answer.where(qid: question_id, subid: 0)
        h = Hash.new 0
        q.each do |a|
            h[a.uid] = a.answer
        end
        return h
  end
  
#   def filter_counts(counts, threshold = 1)
#       w = counts.select{|k, v| v > threshold}
#   end
  
  
  
  
  
  
  
  
  
end
