#Wrappers for some of the editor functions

#Wrapper for Editor.GetEntity function
# :AddAllowedClass value can be single string, single element array or multi-element array
 def get_entity_id prompt=nil, options = {}
 		 begin
 			prompt ||= "\nPlease Select an Entity: "
 			
 			#check for requirements
 			opts = Autodesk::AutoCAD::EditorInput::PromptEntityOptions.new prompt
 			ptype = opts.GetType #for use later on
 			if (options.has_key?(:AddAllowedClass)) && (!options.has_key?(:SetRejectMessage))
 				puts "\n*** get_entity requires 'SetRejectMessage' before setting 'AddAllowedClass'***"
 			    return
 			end

			#do SetRejectMessage first, if present - do this because we never know what order hashes will be in
			if (options.has_key?(:SetRejectMessage))
				opts.send :SetRejectMessage, options[:SetRejectMessage]
				options.delete :SetRejectMessage
			end

			#valid property names are :AllowNone and :AllowObjectOnLockedLayer
			#valid method names are :AddAllowedClass, :RemoveAllowedClass, :SetRejectMessage 
			#but we handled :SetRejectMessage above
			prop_names = [:AllowNone, :AllowObjectOnLockedLayer]
			
			options.each_pair do |key, value|
				if prop_names.include?(key)
					##puts [key,value].inspect
					prop = ptype.GetProperty key.to_s
					prop.SetValue opts, value, nil
				elsif key == :AddAllowedClass
					puts [key,value].inspect
					values = []
					(values << value).flatten!
					values.each do |item|
					   value_array = System::Array.of( System::Object).new(2)
					   value_array[0]= Ads.const_get(item).to_clr_type
					   value_array[1]= true
					   opts.send key, value_array
					end   
				elsif key == :RemoveAllowedClass
					value_array = System::Array.of( System::Object).new(1)
					opts.send key, value_array
				else
					raise "Invalid Option in get_entity: #{key}"
				end
				
            end
			# 	
			result = ed.GetEntity  opts
				
			if result.Status == Aei::PromptStatus.OK
				#puts result.inspect
			   return result.ObjectId
			else
			  return nil
			  
			end
 		rescue Exception => e
		 	      puts_ex e
		 	      return
		end
  end		
 	


	
#Wrapper for user input functions such as 	GetDistance, GetDouble, GetInteger, GetString, etc
#Also wraps the Prompt{TYPE}Options commands PromptDistanceOptions, PromptDoubleOptions, etc
#example usage is --
#distance = get_input :Double, "\nEnter a double", :AllowNegative => true, :AllowZero => true
	def get_input type, prompt=nil, options = {}
		begin
			prompt ||= "\nPlease enter a #{type}"
			opts = Autodesk::AutoCAD::EditorInput.const_get("Prompt#{type}Options").new prompt
			
			options.each do |key, value|
				ptype = opts.GetType
				prop_name = nil
			    method_name = nil 
			    prop_name ||= ptype.GetProperty(key.to_s)
				if prop_name
	    		   prop = ptype.GetProperty key.to_s
				   prop.SetValue opts, value, nil
				else
					puts "\nUnable to set option #{key} for Get#{type} "   
				end
				
			end
	
			result = ed.send("Get#{type}", opts)
	
			if result.Status == Aei::PromptStatus.OK
			   #puts result.to_s
			   return result.Value if [ :Distance, :Double, :Integer, :Point].include? type
			   return result.StringResult if type == :String
			   return result.ObjectId if type == :Entity
			elsif result.Status == Aei::PromptStatus.Keyword
				return result.StringResult
			else
			  puts "not OK"
			  #should we just return nil or raise an exception?
			  return  nil
			end
		rescue Exception => e
	      puts_ex e
		end
	end	
	
#Selection set creation helpers
#filter is array of arrays of form [ [dxfCode, Value], [dxfCode, Value] ]
#example usage [ [0,"Circle"], [8, "Layer1"], [62, 5] ] would select only circles of color 5 on Layer1
#Dxfcodes can be found in the AutoCAD Developer Help. 
#Common ones are 0-Entity Type(as string), 2-Block Name(as string), 8-LayerName(as String)
#62-Color(0-256 as integer), 67-SpaceIndicator(0 or omitted=Modelspace, 1=Paperspace).
#Also support -4 codes and associated operators.
#Returns an object of type <em>Autodesk.AutoCAD.EditorInput.SelectionSet</em>
	def select_on_screen( filter_data=[])
		begin
	    filter = build_selection_filter filter_data
		#ssPrompt = ed.GetSelection( Aei::SelectionFilter.new(filter))
		ssPrompt = ed.GetSelection( filter)
		if ssPrompt.Status == Aei::PromptStatus.OK
		   return ssPrompt.Value 
		else   
		 	 #should we return nil or raise an exception here?
	  	 	nil
	  	end 	
		rescue Exception => e
	      puts_ex e
		end
		
	end

#helper method used by select* methods
#see entry for select_on_screen for more information
	def build_selection_filter( filter_data = [])
		begin
		  #build the appropriate filter array
		  typed_value = Ads::TypedValue[]
		  filter = System::Array.of( typed_value).new(filter_data.size)
	
		  if filter_data.size > 0
	        filter_data.each_with_index{ |elem,i| filter.set_value Ads::TypedValue.new( elem[0], elem[1]), i }
		  end	
	      Aei::SelectionFilter.new(filter)
		rescue Exception => e
	      puts_ex e
		end
		
	end
	
	def select type, prompt=nil, options = {}
		
	end
	