#Extend Ads::Entity with some helper methods
  class Autodesk::AutoCAD::DatabaseServices::Entity
  	
#Test for 'write-ability', is object open for write
#and is its layer unlocked
    def on_locked_layer?
       	begin
       		layer_locked = true
	  	 	helper = TransHelper.new
	  	 	helper.trans([:Layer]) do |tr,db,tables|
	  	 	   		layer = helper.get_obj(self.LayerId)
	  	 	   		layer_locked = layer.IsLocked
	   	 	end
	   	 	return layer_locked
   	     rescue Exception => e
		    puts_ex e
	   	 end	
    	 
    end  	
#Add entity to model space 
#example uage -- my_circle_ent.add_to_current_space
	def add_to_model_space
		begin
		  add_to_space :ModelSpace
		rescue Exception => e
		  puts_ex e
		end 
	end  

#Add entity to paper space 
#example uage -- my_circle_ent.add_to_current_space
    def add_to_paper_space
	   begin
	    	add_to_space :PaperSpace
	   rescue Exception => e
	      puts_ex e
	   end 	
    end
  
#Add entity to the current space using Entity#add_to_current_space
#example uage -- my_circle_ent.add_to_current_space
    def add_to_current_space
  	   begin
    	 add_to_space :CurrentSpace
       rescue Exception => e
         puts_ex e
      end
    end    
  

#Add to Model or Paper Space Helper - to DRY the code a bit
  def add_to_space (space)
  	ret_val = ""
  	begin
      app = Aas::Application
      doc = app.DocumentManager.MdiActiveDocument
      db = doc.Database
      tr = doc.TransactionManager.StartTransaction
      bt = tr.GetObject(db.BlockTableId, Ads::OpenMode.ForRead)
  
      unless space == :CurrentSpace
        space_id = bt[Ads::BlockTableRecord.send(space.to_s)]
      else
      	 space_id = db.CurrentSpaceId
      end  
      btr =  tr.GetObject(space_id, Ads::OpenMode.ForWrite) 
      
      btr.AppendEntity(self)
      ret_val = self.Id.ObjectClass.Name
      tr.add_newly_created_db_object self, true
      tr.Commit
      tr.Dispose
    rescue Exception => e
      puts_ex e
    ensure
      tr.Dispose 
    end 
    return ret_val
  end
  
  end  #Ads::Entity