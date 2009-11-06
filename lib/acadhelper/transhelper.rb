#helper class for using managed transactions
#it won't handle every need every time,  but does handle
#common usages quite well.
require 'ostruct'
	 class TransHelper
		def initialize(use_this_db=nil)
			@open_modes = {:Read => Ads::OpenMode.ForRead, :Write => Ads::OpenMode.ForWrite, }
			@space_hash = {:ModelSpace => Ads::BlockTableRecord.ModelSpace, :PaperSpace => Ads::BlockTableRecord.PaperSpace}
			app = Aas::Application
		    doc = app.DocumentManager.MdiActiveDocument
		    
		    @db = use_this_db
		    #if the caller didn't supply a database, use the active doc database
		    @db ||= doc.Database
		    @tr = @db.TransactionManager.StartTransaction
		end
		
#transaction helper that executes a code block within the context of a managed transaction
#arguements to yield  provide access to the the current Transaction and the current database
#along with any requested tables (see below).  To access these objects in the block, corresponding arguments
#must be passed with the block.  See Example below
#trans takes an array argument of table names, eg [:Block, :Layer, :Linetype].  trans will
#create an OpenStruct call @tables that will contain a reference to the #{table}Table so 
#that, for example, the LayerTable can be accessed via tables.Layer[layer_name] 

		def trans(table_names=[], commit_after_block=true)
			begin
				tables_hash = {}
				#add ModelSpace and PaperSpace to the tables_hash
				@space_hash.each_pair do |key,value|
					if table_names.include?(key)
						tables_hash[key] = get_space_record key
						table_names.delete key
					end	
				end
			
				if table_names.size > 0
				    table_names.each do |key|
				    	table_id =  get_db_property "#{key.to_s}TableId"
				    	tables_hash[key] = get_obj table_id
			   	    end	
			    end
			    @tables = OpenStruct.new(tables_hash)
			    
		        yield @tr, @db, @tables
		
		        @tr.Commit if commit_after_block
		    rescue Exception => e
		        @tr.Dispose
		        raise e  # pass it up the line
		    end	
		end	
		
		def get_obj(object_id, mode=:Read)
			begin
				ent = @tr.get_object(object_id, @open_modes[:Read])
				return ent if mode == :Read
       			if mode == :Write  && ent.on_locked_layer? == false
	  	 	   		ent.UpgradeOpen
	  	 	   		return ent
	  	 		else
		  	 		return nil   
		   	 	end
	   	     rescue Exception => e
			    puts_ex e
	   		 end	
		end
		
		def dispose
			@tr.Dispose
		end
		
		private
		
		def get_space_record(space, mode=:Read)
			bt = @tr.GetObject(@db.BlockTableId, @open_modes[mode])
			@tr.GetObject(bt[@space_hash[space]], @open_modes[mode])
		end
		
		def get_db_property(property_name)
			ptype  = @db.GetType
			prop = ptype.GetProperty(property_name)
			prop.GetValue(@db, nil)
		end
	
	end