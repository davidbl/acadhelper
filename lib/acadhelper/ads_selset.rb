# Extend Aei::SelectionSet
# These two methods add ease-of-use to selections sets
# instead of iterating over the sel_set, getting the object id, finding the object,
# opening it for read/write and then doing our thing with the object,
# we can now just
#  select_on_screen.each_for_write{ |ent| ent.color_index = 3}
#  or
#  select_on_screen.each_for_read do  |ent|  
#    (ent.magic occurs here)
#  end
  class Autodesk::AutoCAD::EditorInput::SelectionSet
# iterate over the selection set, yielding each entity opened for read  	
  	 def each_for_read
  	 	begin
	  	 	helper = TransHelper.new
	  	 	helper.trans do |tr,db,tables|
	  	 	   	self.each do |sel_object|
	  	 	   		yield helper.get_obj(sel_object.ObjectId, :Read)	
	  	 	   	end
	   	 	end
	   	 rescue Exception => e
		    puts_ex e
	   	 end		
   	 end
# Iterate over the selection set, yielding each entity opened for write
#  (will not yield any entities that are on locked layers)   	 
   	 def each_for_write
   	 	begin
	  	 	helper = TransHelper.new
	  	 	helper.trans([:Layer]) do |tr,db,tables|
	  	 	   	self.each do |sel_object|
	  	 	   		ent = helper.get_obj(sel_object.ObjectId, :Read)
	  	 	   		layer = helper.get_obj(ent.LayerId)
	  	 	   		if !layer.IsLocked
	  	 	   			ent.UpgradeOpen
	  	 	   	    	yield ent 
	  	 	   	    end	
	  	 	   	end
	   	 	end
   	     rescue Exception => e
		    puts_ex e
	   	 end	
   	 end
  end