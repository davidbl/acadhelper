# = AcadHelper examples
require 'AcadHelper'

include AcadHelper

#write text to the autocad command line
def hello_world
  puts "\nHello World!"
end



# Adds a circle to the current space
def circle_example
	begin
    my_circle = create_circle 5,5,1,6 #x,y,z,radius
    my_circle.add_to_current_space
  rescue Exception => e
    puts_ex e
  end  
end

# One doesn't have to use the helpers
# The full managed API is available
def circle_example_pure_api
	begin
	  #uses fully-qualifed identifiers
	  #could us Aas::Application instead	
	  app = Autodesk::AutoCAD::ApplicationServices::Application
	  doc = app.DocumentManager.MdiActiveDocument
	  db = doc.Database
	
	  tr = doc.TransactionManager.StartTransaction
	  bt = tr.GetObject(db.BlockTableId, Autodesk::AutoCAD::DatabaseServices::OpenMode.ForRead)
	  
	  #we can also use more Ruby-like method calls for the managed methods
	  btr = tr.get_object(db.CurrentSpaceId, Autodesk::AutoCAD::DatabaseServices::OpenMode.ForWrite)
	
	  cir =  Autodesk::AutoCAD::DatabaseServices::Circle.new(Autodesk::AutoCAD::Geometry::Point3d.new(10, 10, 0),
	         Autodesk::AutoCAD::Geometry::Vector3d.ZAxis, 2)
	  btr.AppendEntity(cir)
	  tr.AddNewlyCreatedDBObject(cir, true)
	  tr.Commit
	  tr.Dispose
    rescue Exception => e
      puts_ex e
    end
end

# Adds some arcs to the current space
def arc_example
	begin
      my_arc = create_arc 8,8,0,6, 0, 90, :D #x,y,z,radius,start_angle, end_angle, degrees_or_radians, normal=nil)
      my_arc.add_to_current_space
      puts "Your Degree arc was added"
      
      my_arc = create_arc 13,13,0,6, 0.5, 5.9, :R #x,y,z,radius,start_angle, end_angle, degrees_or_radians, normal=nil)
      my_arc.add_to_current_space
      puts "Your Radians arc was added"
    rescue Exception => e
      puts_ex e
    end  
end
# Adds a lwpolyline to model space   
def pline_example	
	begin
   	   verts = [[[0,0],0],[[2,2],0],[[5,2],0],[[8,8],0]]
   	   pl = create_pline verts
   	   pl.add_to_model_space
   	   puts "pl added"
    rescue Exception => e
      puts_ex e
    end  	
end


def line_example
	begin
	  line = create_line [1,1], [2,4,5]
	  line.add_to_model_space
	  puts "Line Added"
    rescue Exception => e
      puts_ex e
    end  	
end

def line_ps_example
	begin
	  line = create_line [1,1], [2,4,5]
	  line.add_to_paper_space
	  puts "Line Added"
    rescue Exception => e
      puts_ex e
    end  	
end

# new, better methods exist for doing this kind of thing
#
# see TransHelper class and SelectionSet extensions
def transaction_example
	begin
		new_color = get_input :Integer, "\nEnter the desired color index(1-255)", :LowerLimit => 1, :UpperLimit => 255
		ss = select_on_screen 
		trans  do |tr,db|
			ss.each do |id| 
   		       ent = tr.get_object id.ObjectId, Ads::OpenMode.ForWrite
   		       ent.color_index = new_color
     	    end
        end  	
    rescue Exception => e
       puts_ex e
	end 
end

# Selection Set example
def select_on_screen_example
	begin
	   #with filter
	   puts "\nSelect a circle that is color green and has radius > 2"
	   ss = select_on_screen [[0,"Circle"],[62, 3],[-4,">="],[40, 2]]
	   puts ss.inspect
	   #see transaction_example for ways to 'do stuff' with the selection set
	rescue Exception => e
		puts_ex e
	end
	
end

# Input helper examples - GetDistance, GetInteger, GetString,  etc
def input_example1
	begin
		distance = get_input :Distance, "\nEnter your chosen distance", :AllowNegative => false, :AllowZero => false, :UseDashedLine => true
		puts "\nYou entered #{distance}. Half of it is #{distance*0.5}"
    rescue Exception => e
        puts_ex e
	end
end


def input_example2
	begin
		distance = get_input :Double, "\nEnter a double", :AllowNegative => false, :AllowZero => false
		ed_write "\nYou entered #{distance.to_s}"
		name = get_input :String, "\nPlease enter your full name", :AllowSpaces => true, :DoNotDoThis => 5
		puts "Thank you for playing, #{name.reverse}"
		puts "Just kidding #{name.split[0]}"
    rescue Exception => e
        puts_ex e
	end
end

# uses new get_entity_id wrapper (wraps Editor.GetEntity).  return an objectId of the selected entity or nil if nothing
# is selected.  :AllowNone doesn't seem to be working as expected.
#  :AddAllowedClass value can be single string, single element array or multi-element array
# if :AddAllowedClass is used, :SetRejectMessage must be set first.  Wrapper will let the user know this
def get_ent
   begin
     ent = get_entity_id "\nPick a Circle or Arc: ", :SetRejectMessage => "\nNot an arc or circle, try again ",
       :AllowNone => true, :AddAllowedClass => ["Arc","Circle"]
     # :AddAllowedClass value can be single string, single element array or multi-element array
   	 if ent
   	 	puts ent.inspect	
   	 else
   	 	puts "\nwhy didn't you pick anything?"	
   	 end	
   rescue Exception => e
      puts_ex e
   end	
end



