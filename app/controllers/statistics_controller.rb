class StatisticsController < ApplicationController
    include StaticsHelper
    
    
    
    def index
        @locations = ["medio campidano", "cagliari", "oristano", "nuoro", "sassari","sardegna", "sardegna eccetto medio campidano", "altro"]
        @location = "medio campidano"
        if params[:area]
            @location = params[:area].downcase!
            logger.debug "@location: #{@location}"
        end  

        @num_of_indicators = 11
        @uids = User.where(place: @location).pluck('uid')
        
        if @location == "sardegna"
            @uids = User.all.pluck(:uid)
        elsif @location == "sardegna eccetto medio campidano"
            @uids = User.where.not(place: 'medio campidano').pluck(:uid)
        elsif @location == "altro"
            @uids = User.where.not(place: @locations).pluck(:uid) ###### da sistemare --RVD!!!!!!
        end
        
        
        ### Qui ricaviamo gli intervistati che facendo uso di farmaci generici hanno avuto degli effetti indesiderati
        w = Answer.distinct.where(qid: "5", subid: "0", uid: @uids).where.not(answer: nil).pluck(:uid)
        #w = Answer.select('uid').distinct.where("qid = 5 and subid = 0 and answer is not null").map{|a| a.uid}
        #to_remove = Answer.select('uid').distinct.where("qid = 1 and subid = 0 and (answer like 'n%' or answer like 'N%')").map{|a| a.uid}
        to_remove = Answer.distinct.where(qid: "1", subid: "0", uid: @uids).where("answer like 'n%' or answer like 'N%'").pluck(:uid)
        filtered_w = []
        w.each do |id|
            if (to_remove.include? id) 
                next
            end    
             filtered_w << id   
        end    
        #binding.pry
        males =  User.where(sex: "M", uid: filtered_w).pluck(:uid)
        females = User.where(sex: "F", uid: filtered_w).pluck(:uid)
        ### calcoliamo quindi le percentuali di questi che hanno avuto inequivalenza, reazioni indesiderati ed inefficacia 
        lillo = Answer.select('answer').where.not(answer: nil).where({qid: 1, subid: 1, uid: w[0..100]}).group(:answer).count('answer')
        @mycounts = Answer.select('answer').where.not(answer: nil).where(qid: 1, subid: 1, uid: filtered_w[0..277]).group(:answer).count('answer')
        ### Percentuali degli effetti indesiderati divisi per genere
        @count_males = Answer.select('answer').where(qid: 1, subid: 1, uid: males).group(:answer).count('answer')
        @count_females = Answer.select('answer').where(qid: 1, subid: 1, uid: females).group(:answer).count('answer')
        @stacked_data = get_stacked_data
        #binding.pry
        #### Indicatori statistici

        @icounts = Array.new(@num_of_indicators,0)
        @counts_by_genre = Array.new(@num_of_indicators, 0)
        
        1.upto(@num_of_indicators) do |n| 
            @icounts[n - 1] = get_i(n)
        end    
        1.upto(@num_of_indicators){|n| @counts_by_genre[n - 1] = get_i_by_genre(n)}
        #binding.pry
        ### Descrizione indicatori
        @descriptions = IndicatorDescription.order('id asc').pluck(:description)
        @descriptions = @descriptions.map{|d| d.capitalize}
       
        respond_to do |format|
           if request.xhr?
              logger.debug "XHR request"
              logger.debug "ajax param: #{@location}"
              format.js 
           else  
              format.html
           end  
       end
    end

    
    def show
    end

    def new
    end
    
    def create 
    end
    
    def edit
    end
    
    
    ####internal method
    ### il metodo elenca le descrizioni associate all'indicatore i5 ed
    ### al tag reazioni indesiderate 
    def list_indicator
        ### to do params and pagination
        @descriptions = get_indicator_description(5)

        # binding.pry
    end
    
    def adverse_reactions
        @qids, @adverse_reactions = extract_info("reazioni indesiderate")        
    end
    
    def side_effects
        @qids, @side_effects = extract_info("bugiardino|effetti collaterali")
        
    end
    
    def drugs
        @drug_names = Drug.distinct.select(:drug_name).where("drug_name <> ''").paginate(:page => params[:page]).order('drug_name ASC')
        
    end
    
    def aggregated_drugs
        @drug_names = Drug.distinct.select(:drug_name).where("drug_name <> ''").order('drug_name ASC')
        if params["selected"].nil?
            @drug_selected = @drug_names.first.drug_name
        else
            puts params.inspect
            @drug_selected = params["selected"]
        end    

    end    
        
    
    
    
end
