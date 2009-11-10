#= Additional Examples

require 'AcadHelper'

include AcadHelper

# loop through all modelspace entities using the new TransHelper class
def trans_modelspace_example
	begin
		helper = TransHelper.new
		helper.trans([:ModelSpace]) do |tr, db, tables|
			tables.ModelSpace.each do |object_id|
				puts object_id.ObjectClass.DxfName
			end
		end
	rescue Exception => e
	    puts_ex e
	ensure
		puts "Disposing Trans"
		helper.dispose   		
	end
end

# loop through all modelspace entities and change their color
def change_all_test
	begin
		new_color = 8
		helper = TransHelper.new
		helper.trans([:ModelSpace]) do |tr, db, tables|
			tables.ModelSpace.each do |object_id|
				ent = helper.get_obj(object_id, :Write)
   		        ent.color_index = new_color  if ent
			end
		end
	rescue Exception => e
	    puts_ex e
		
	ensure
		puts "Disposing Trans"
		helper.dispose   		
	end
end

# Using the extended selection set that allows for easier iteration over the objects
def sel_set_test
	begin
        select_on_screen.each_for_write{ |ent| ent.color_index = 3 }
        select_on_screen.each_for_read{ |ent| puts ent.layer }
    rescue Exception => e
	    puts_ex e
    end	
	
end

# another TransHelper example
#
# It will list all the layer names in the file and
# list the members of TextStyleTable, LineTypeTable and UcsTable
def trans_example2
	begin
		helper = TransHelper.new
		provide_these_tables = [:ModelSpace, :Block, :Layer, :TextStyle, :Linetype, :Ucs]
		helper.trans(provide_these_tables) do |tr, db, tables|
			#loop through the LayerTable and echo all the layer names
			tables.Layer.each do |layer_id|
				layer = tr.GetObject(layer_id, Ads::OpenMode.ForRead)
				puts layer.name
			end
            #loop through all the requested Tables and echo the names of their members			
			all_tables = tables.marshal_dump
			all_tables.each_pair do |key,value|
				puts "*** #{key.to_s} ***"
				value.each { |id| item = tr.GetObject(id, Ads::OpenMode.ForRead); puts item.name } unless key == (:ModelSpace || :PaperSpace)
				puts "______________________"
			end
		end
    rescue Exception => e
	      puts_ex e
	ensure
		 puts "Disposing Trans"
		 helper.dispose      
	end
end

# just a test of open the Text class to create a Point entity based on 
# values passed in the code block (not auotcad block) to the text entity
def puts_pt2
	begin
		ss = select_on_screen [[0,"Text"]]
		ss.each_for_read do |ent|
			ent.add_point{ |text| text.TextString.gsub("+ ","").to_f }
			#alternate ways to handle the text
			#ent.add_point{ |text| text.TextString.to_f + 1000 }
			#ent.add_point { |text|  text.Database.Elevation}
			#ent.add_point{ |text| text.TextString.gsub("+ ","").to_f }
			#ent.add_point{ |text| text.TextString.match(/[\d\.]+\Z/)[0].to_f }
		end
    rescue Exception => e
	    puts_ex e
    end	
end


