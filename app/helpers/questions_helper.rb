module QuestionsHelper
    
    

        
    
    QUESTION_IDX = [1,2,3,4,5,6,7]
   
    def sub_count(qid, subid, uids)
        total = []
        qone = get_reference_question(qid, uids)
        
        parent_one = 1
        Answer.where(qid: qid, subid: subid, uid: uids).each do |a|
        #Answer.where("qid = ? and  subid = ?", qid, subid).each do |a|
            if QUESTION_IDX.include? qid
                #parent_ans = Answer.where(qid: parent_one, subid: 0, uid: a.uid)[0].answer
                parent_ans = qone[a.uid]
                #logger.debug "parent answer: #{parent_ans}"
                if parent_ans =~ /no/ || parent_ans.nil?
                     #logger.debug "inside if"
                     next
                end

            end
            total << a.answer           
        end
        #logger.debug "total length: #{total.length}"
        counts = Hash.new 0
        count_drugs = Hash.new 0
        count_categories = Hash.new 0
        
        
        total.each do |resp|
            resp = resp.downcase unless resp.nil?
            resp.nil? ? resp = "nessuna risposta" : resp.strip!
            if resp =~ /^farmaco/
                resp_vect = resp.split(",").map{|w| w.downcase}
                drug = resp_vect[0].gsub("farmaco: ", "").strip
                category = resp_vect[1].gsub("categoria: ", "").strip
                #binding.pry
              unless drug.nil? || drug == "" || drug == "-"
                    drug = sanitize_drug_name(drug)
                    count_drugs[drug] += 1
              end   
              unless category.nil? || category == "" || category == "-"
                    category = sanitize_drug_category(category)
                    count_categories[category] += 1
              end
            end
            #binding.pry
            counts[resp] += 1
        end
        
        qoptions = QuestionOption.where(qid: qid, subid: subid).map{|opt| opt.odescription.strip}
        count_keys = counts.keys
        
        qoptions.each do |opt|
            next if count_keys.include? opt
            counts[opt] = 0
        end    
                
        
        counts.except!("nessuna risposta") if (qid == 11 && subid == 2) || (qid == 6 && subid == 1)
        if (qid == 1 && subid == 1) 
            counts.reject!{|k| k == "nessuna risposta"}
        end
        #binding.pry
        count_drugs = filter_counts(count_drugs, 0)
        
        ##here we sort by value in descending order
        count_drugs = (count_drugs.sort_by{|drug, count| -count}).to_h
        count_categories = filter_counts(count_categories, 0)
        count_categories = (count_categories.sort_by{|category, count| -count}).to_h
        count_categories.reject!{|k| k == "per la schiena" || k == "per l’orecchio" || k == "farmaco di marca" || k == "tirosil pastiglie"}
        #binding.pry
        count_drugs.reject!{|k| k == "zira" || k == "non ricorda" || k == "harmony" || k == "farmaco di marca" || k == "antibiotico di marca" || k == "quello di marca" || k == "farmaco generico" || k == "antiipertensivo generico" || k == "castrol" || k == "magramir"}
        return counts, count_drugs, count_categories
    end  
    
    
  def get_reference_question(qid, uids)
        question_id = case qid
        when 1..7 then 1
        when 9..10 then 9
        end    
        
        q = Answer.where(qid: question_id, subid: 0, uid: uids)
        h = Hash.new 0
        q.each do |a|
            h[a.uid] = a.answer
        end
        return h
  end 
  
  
  def filter_counts(counts, threshold = 1)
            if counts.keys.length > 30
                w = counts.select{|k, v| v > threshold}
            else
                w = counts
            end
            w
  end
  
  
  
  def get_prescriber(qid, subid, uids)
    if qid != 8
        return
    end
    total = []
    total = Answer.where(qid: 8, subid: 1, uid: uids).map {|a| a.answer}
    
    count_prescriber = Hash.new 0
    count_changer = Hash.new 0
    count = Hash.new 0
    
    total.each do |resp|
        next if resp.nil? || resp == ""
        resp_vect = resp.split(",")
        logger.warn "resp_vect: #{resp_vect}"
        
        prescriber = resp_vect[0].strip.downcase unless resp_vect[0].nil?
        changer = resp_vect[1].strip.downcase unless resp_vect[1].nil?
        
        count_prescriber[prescriber] += 1
        count_changer[changer] += 1
        count[resp.downcase] += 1
   
    end
    
    count_prescriber = filter_counts(count_prescriber)
    count_changer = filter_counts(count_changer)
    #binding.pry
    return count_prescriber, count_changer, count

  end 
  
  def get_suggestions(qid, uids)
      answers = Answer.where(qid: 18, uid: uids).map{|a| a.answer}
      answers = answers.reject{|a| a =~ /^(\s)*$/}
      #answers = answers.reject{|a| a == ""}
  end
  
  def sanitize_drug_name(drug)
     wrong_to_corr = {"chetoprofene" => "ketoprofene", "paracetamolo generico" => "paracetamolo", "ketoprofene generico" => "ketoprofene", "diclofenac generico" => "diclofenac", 
     "enn" => "en", "efferalgan al gusto pompelmo" => "efferalgan", "loperamide hexal" => "loperamide", 
     "ibuprofene generico" => "ibuprofene","atovarstatina" => "atorvastatina", "moment act" => "momentact", "desloratadina sandoz" => "desloratadina",
     "oki stask" => "okitask", "alcion" => "halcion", "aldol" => "haldol", "carbolitium" => "carbolithium", "dobergin" => "dopergin", "duplamox" => "neoduplamox", "enantium" => "enantyum", "enteregermia" => "enterogermina",
     "ferrograd" => "ferro-grad", "metotrexate sottocutanea" => "methotrexate", "naprosin" => "naprosyn", "neoborocillina" => "neo borocillina",
     "novarapid" => "novorapid", "oncocarbide" => "onco carbide", "penicillina iniezione" => "penicillina",
     "simvastatin" => "simvastatina", "statina generico" => "statine", "tamsulosina cloridrato" => "tamsulosina", "tirosin fiale" => "tirosint",
     "votaren" => "voltaren", "yasminelle generico" => "yasminelle", "ziprexa" => "zyprexa", "zolofov" => "zoloft", "zyrolic" => "zyloric",
     "coeferalgan" => "co-efferalgan", "neolotan" => "neo-lotan", "sincron" => "sintrom", "parcetamolo" => "paracetamolo", "neolatan" => "neo-lotan",
     "pantol" => "patrol", "carioaspirin" => "cardioaspirin", "di base" => "Dibase", "ferro grad" => "ferro-grad", "converlam" => "coverlam",
     "minulett" => "minulet", "panifur" => "pafinur", "bibase" => "Dibase", "prozac generico" => "fluoxetina", "atorvastatina generico" => "atorvastatina",
     "atorvastatina calcica generico" => "atorvastatina", "simvastatina generico" => "simvastatina", "xanax generico" => "alpraxolam", "coefferalgan" => "co-efferalgan", "nimesulide generico" => "nimesulide",
     "lobivon generico" => "nebivololo", "lasix generico" => "furosemide", "sulidamor generico" => "nimesulide", "atorvastatin" => "atorvastatina", "nimesulide dorom" => "nimesulide", 
     "acido acetisalicilico" => "acido acetilsalicilico", ":kyrolic" => "zyloric", "alfusozima ratiopharm" => "alfuzosina", "nebivololo generico" => "nebivololo",
     "flecainide generico" => "flecainide", "sobrerolo generico" => "sobrerolo", "eutirox 75" => "eutirox", "geenrico dell’aulin" => "nimesulide", 
     "lirica" => "lyrica", "amoxicillina rathiopharm" => "amoxicillina", "acido acetil salicilico" => "acido acetilsalicilico", "sintron" => "sintrom",
     "flumucil" => "fluimucil", "naprosene" => "naprossene", "atorvastatina calcica" => "atorvastatina", "ibuprofene carlo erba" => "ibuprofene",
     "bentelan intramuscolo" => "bentelan", "debridat generico" => "trimebutina", "oki generico" => "ketoprofene", "fluoxetina generico" => "fluoxetina",
     "oki + antistaminico" => "oki", "nimesulide + antistaminico" => "nimesulide", "betametasone + gentamicina" => "betametasone", "bamfix" => "bamifix", "pillola anticoncezionale generico" => "pillola anticoncezionale",
     "antimicotico generico" => "antimicotici", ": kyrolic" => "zyloric"
     
     }
     
     if wrong_to_corr.keys.include? drug
         drug = wrong_to_corr[drug]
     end     
     drug    
  end
  
  
   def sanitize_drug_category(category)
     wrong_to_corr = { "antipiretico" => "analgesico-antipiretico", "antidolorifici e antipiretici" => "analgesico-antipiretico",
     "analgesico e antipiretico" =>  "analgesico-antipiretico", "antidolorifico" => "fans", "antiinfiammatorio" => "fans",
     "antinfiammatorio" => "fans", "antiinfiammatori" => "fans", "antidolorifici"  => "fans", "antinfluenzali" => "fans", "antinfluenzale" => "fans",
     "antiinfluenzali" => "fans", "antinfiammatorio non steroideo" => "fans", "fans" => "FANS", "analgesico" => "analgesici oppioidi",
     "oppioide" => "analgesici oppioidi", "antiipertensivo" => "antipertensivi", "trattamento dell’ipertensione" => "antipertensivi",
     "generico per la pressione" => "antipertensivi", "per la pressione generico" => "antipertensivi", "antipercolesterolemico" => "ipocolesterolemizzanti",
     "ipolipemizzante" => "ipocolesterolemizzanti", "per il colesterolo" => "ipocolesterolemizzanti", "statine" => "ipocolesterolemizzanti", 
     "ipoglicemizzante orale" => "ipoglicemizzanti", "ipoglicemizzante" => "ipoglicemizzanti", "gastroprotettore" => "IPP", "ipp" => "IPP",
     "antiepilettico" => "antiepilettici", "collirio" => "corticosteroidi ed antibatterici", "corticosteroide" => "corticosteroidi ed antibatterici",
     "cortisone" => "corticosteroidi", "ansiolitico" => "ansiolitici", "antidepressivo" => "antidepressivi", "antipsicotico" => "antipsicotici",
     "antipscotico" => "antipsicotici", "pressione" => "antipertensivi", "ipocolesterolemizzante" => "ipocolesterolemizzanti", "antistaminico" => "antistaminici",
     "pillola anticoncezionale" => "ormoni", "calcio" => "integratore di minerali", "antagonisti dell'angiotensina ii" => "antipertensivi",
     "anticoagulante" => "antitrombotici", "antitrombotico" => "antitrombotici", "mucolitico" => "mucolitici", "anestetico" => "anestetici", 
     "ormone tiroideo" => "ormoni tiroidei", "integratore alimentare" => "integratori alimentari", "antiaritmico" => "antiaritmici", "antiemetico" => "antiemetici",
     "pillola contraccettiva" => "ormoni", "anticoncezionale" => "ormoni", "antiistaminico" => "antistaminici", "farmaco per osteoporosi" => "bifosfonati",
     "tachipirina" => "analgesico-antipiretico", "contraccettivo orale" => "ormoni", "antiinfiammatorio non steroideo" => "fans",
     "antitrombotici antiaggreganti piastrinici" =>  "antitrombotici", "analgesici e antipiretici" => "analgesico-antipiretico", "corticosteroidi-antibatterici" => "corticosteroidi ed antibatterici",
     "prevenzione di nausea e vomito" => "antiemetici", "protettore per lo stomaco" => "IPP", "integratori" =>	"integratori alimentari", "antifiammatorio/antireumatico non steroideo" => "fans",
     "ansiolitici derivati benzodiazepinici" => "ansiolitici", "antibatterico generale per uso sistemico" => "antibiotico", "antisatminico" => "antistaminici",
     "antidiarroico" => "antidiarroici", "fluidificante" => "mucolitici", "melatonina" => "psicolettici", "contrasto iodato" => "mezzo di contrasto radiologico",
     "liquido di contrasto" => "mezzo di contrasto radiologico", "diuretico" => "diuretici", "inibitori di hmg-CoA reduttasi" => "ipocolesterolemizzanti",
     "inibitori di hmg-coa reduttasi" => "ipocolesterolemizzanti", "associazioni di antibatterici orali" => "antibiotico", "associazioni di antidiabetici orali" => "ipoglicemizzanti", "inibitore pompa protonica" => "IPP",
     "integratore a base di gambo d’ananas" => "integratori alimentari", "antiemicrania" => "antiemicranici", "trattamento dell’ipercolesterolemia" => "ipocolesterolemizzante",
     "oppiaceo" => "analgesici oppioidi", "mezzo di contrasto" => "mezzo di contrasto radiologico", "ormone" => "ormoni", "acido biliare" => "preparati a base di acidi biliari",
     "pastiglie per colesterolo" => "ipocolesterolemizzanti", "antibiotici" => "antibiotico", "anticoagulante orale" => "antitrombotici", "pomata per punture di insetto" => "dermatologici, corticosteroidi",
     "analgesico oppioide" => "analgesici oppioidi", "decongestionante nasale" => "decongestionanti nasali", "analgesico antipiretico" => "analgesico-antipiretico",
     "per il reflusso" => "IPP", "analgesico oppiaceo" => "analgesici oppioidi", "anticoncezionale orale" => "ormoni", "per osteoporosi" => "bifosfonati",
     "antibiotico generico" => "antibiotico", "procinetico" => "procinetici", "antibiotico generico per placche in gola" => "antibiotico", "farmaco per artrosi" =>	"fans",
     "per la febbre" => "analgesico-antipiretico", "per il colon irritabile" => "antispastici", "generico per l’ansia" => "ansiolitici", "estrogeno" => "ormoni",
     "stabilizzatore umore" => "antiepilettici", "anipsicotico" => "antipsicotici", "ansiolitcio" => "ansiolitici", "controllo iperfosfatemia" => "trattamento dell'iperfosfatemia",
     "neurolettico" => "antipsicotici", "lassativo" => "lassativi", "per ernia iatale" => "IPP", "antiemicranico" => "antiemicranici", "antipertensivo" => "antipertensivi", 
     "decongestionale nasale" => "decongestionanti nasali", "generico per ansia" => "ansiolitici", "antinfiammatorio non sterideo" => "fans", "anticoaugulante" => "antitrombotici",
     "analgestico" => "analgesici oppioidi", "antiinfluenzale" => "fans", "miorilassante" => "miorilassanti", "preparato antivertigine" => "preparati antivertigine", "interferone" => "interferoni", "antitumorali" => "antitumorale",
     "immunosoppressore" => "immunosoppressori", "per le vertigini" => "preparati antivertigine", "eparina" => "antitrombotici", "antidolorifico oppioide" => "analgesici oppioidi",
     "insulina" => "insuline", "vitamina" => "integratori alimentari", "antimicotico" => "antimicotici", "antipertensivo generico" => "antipertensivi" ,
     "antimicotico generico" => "antimicotici", "pillola anticoncezionale generico" => "pillola anticoncezionale", "antiacido" => "antiacidi",
     "antidolorico" => "analgesici", "antiipertensivi" => "antipertensivi", "antigottoso" => "diuretici", "cardioaspirina" => "antitrombotici", "inibitore di pompa protonica" => "IPP",
     "corticosteroidi sistemici-glicocorticoidi" => "corticosteroidi", "farmaci per il nervoso" => "ansiolitici", "beta bloccante" => "beta-bloccante",
     "analgesici ed antipiretici" => "analgesico-antipiretico", "per la pressione" => "antipertensivi", "antagonisti dell’amgiotensina ii" => "antipertensivi",
     "gastroprotettori" => "IPP", "pillole contraccettive" => "ormoni", "gasrtoprotettore" => "IPP"
         
         
     }
     
     if wrong_to_corr.keys.include? category
         category = wrong_to_corr[category]
         if category == "fans"
             category = category.upcase
         end     
     end     
     category   
  end 
  
  
  
  
  def clean_counts(counts)
      l = []
      h = Hash.new
      counts.each do |k,v|
            tmp_key = k.gsub(/\s*\/\s*/, '/')
            tmp_key = tmp_key.gsub(/\s*</, "< ")
            tmp_key = tmp_key.gsub(/\s*>/, "> ")            
            tmp_key = tmp_key.gsub("  ", " ")
            if h.keys.include?(tmp_key)
                h[tmp_key] += v
            else
               h[tmp_key] = v    
            end
      end        
      h
  end      
    
    
end
