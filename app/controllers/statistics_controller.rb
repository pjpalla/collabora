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
        filtered_w = w - to_remove
        
        ### previous solution ##
        # w.each do |id|
        #     if (to_remove.include? id) 
        #         next
        #     end    
        #      filtered_w << id   
        # end
        #################################
        
        
        
        logger.debug("filter 1: #{filtered_w.length}")
        # logger.debug("filtered ids: #{filtered_w}")
        
        
        # filtered_w2 = w - to_remove
        # logger.debug("filter 2_: #{filtered_w2.length}")
        # logger.debug("filtered 2 ids: #{filtered_w2}")
        
        
        #binding.pry
        males =  User.where(sex: "M", uid: filtered_w).pluck(:uid)
        females = User.where(sex: "F", uid: filtered_w).pluck(:uid)
        ### calcoliamo quindi le percentuali di questi che hanno avuto inequivalenza, reazioni indesiderati ed inefficacia 
        #lillo = Answer.select('answer').where.not(answer: nil).where({qid: 1, subid: 1, uid: w[0..100]}).group(:answer).count('answer')
        #@mycounts = Answer.select('answer').where.not(answer: nil).where(qid: 1, subid: 1, uid: filtered_w[0..277]).group(:answer).count('answer')
        @mycounts = Answer.select('answer').where.not(answer: nil).where(qid: 1, subid: 1, uid: filtered_w).group(:answer).count('answer') ### indicatore i0
        ### Percentuali degli effetti indesiderati divisi per genere
        @count_males = Answer.select('answer').where(qid: 1, subid: 1, uid: males).group(:answer).count('answer')
        @count_females = Answer.select('answer').where(qid: 1, subid: 1, uid: females).group(:answer).count('answer')
        @stacked_data = get_stacked_data
        #logger.debug "mycounts: #{@mycounts}"
        #binding.pry
        #### Indicatori statistici

        @icounts = Array.new(@num_of_indicators,0)
        @counts_by_genre = Array.new(@num_of_indicators, 0)
        
        1.upto(@num_of_indicators) do |n| 
            @icounts[n - 1] = get_i(n)
        end    
        1.upto(@num_of_indicators){|n| @counts_by_genre[n - 1] = get_i_by_genre(n)}
        #binding.pry
        ### i8 subindicators ###
        #### numero intervistati ricavati dall'indicatore i8
        interviewed = @icounts[7].values.sum
        @subindicators = get_sub_indicators(8, interviewed) ### here we compute i8 subindicators
        @subindicator_descriptions = IndicatorDescription.where("name like 'i8_%'").order('id asc').pluck(:description)
        #binding.pry
        ### Descrizione indicatori
        @descriptions = IndicatorDescription.order('id asc').pluck(:description)
        #@descriptions = @descriptions.map do |d|
        #binding.pry
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
        @black_list = ["castrol", "farmaco generico", "magramir"]
        @drug_names = Drug.distinct.select(:drug_name).where("drug_name <> ''").where.not(drug_name: @black_list).paginate(:page => params[:page]).order('drug_name ASC')
        
    end
    
    def aggregated_drugs
        @black_list = ["castrol", "farmaco generico", "magramir"]
        @drug_names = Drug.distinct.select(:drug_name).where("drug_name <> ''").where.not(drug_name: @black_list).order('drug_name ASC')
        unless @drug_names.empty?
            if params["selected"].nil?
                @drug_selected = @drug_names.first.drug_name
            else
                puts params.inspect
                @drug_selected = params["selected"]
            end
        end    

    end    
        
    
    
    
end
