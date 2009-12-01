#= Entity creation helpers. These methods simplify the default constructors

module AcadHelper
# point3D creation helper
#
# if z is not provided, 0 will be used
#  returns an instance of Ag::Point3d
  def ac_pt3d(x,y,z=0)
  	begin
    	pt3d = Ag::Point3d.new(x, y, z)
    rescue Exception => e
      puts_ex e
    end	
    pt3d
  end
  
# point2D creation helper.
#  returns an instance of Ag::Point2d
  def ac_pt2d(x,y)
  	begin
    	pt2d = Ag::Point2d.new(x, y)
    rescue Exception => e
      puts_ex e
    end	
    pt2d
  end
  
# text creation helper.
#
# will take an argument hash in the form of {:Property1 => val, :Property2 => val.... :PropertyN => val }
#  where PropertyX is a member of Autodesk.AutoCAD.DatabaseServices.DBText
	def create_text(props = {})
		begin
			text = Ads::DBText.new
			props.each do |key, value|
				ptype = text.GetType
				prop = ptype.GetProperty key.to_s
				value = value.to_clr_string if key == :TextString
				prop.SetValue text, value, nil
			end
		rescue Exception => e
	      puts_ex e 
		end	
		text
	end

# text chart creation helper
# text_strings is a nested array of form [ [row1_col1, row1_col2...row1_colN],....[rowN_col1,rowN_col1...rowN_colN] ]
# column_sep is distance between columns
# row_sep is distance between rows
# for column and row sep, positive value will go to right or down, negative values will go left or up
	def create_text_chart(text_strings, start_x, start_y, column_sep, row_sep, props = {})
		begin
			col_count, row_count = 0,0
			text_strings.each do |row|
				col_count = 0
				row.each do |str|
					text = Ads::DBText.new
					#add the Position to the props
					ins_pt = ac_pt3d(start_x+col_count*column_sep, start_y-row_sep*row_count)
					props[:Position] = ins_pt
					props[:AlignmentPoint] = ins_pt
					props.each do |key, value|
						ptype = text.GetType
						prop = ptype.GetProperty key.to_s
						value = value.to_clr_string if key == :TextString
						prop.SetValue text, value, nil
					end
					text.TextString = str
					text.add_to_current_space
					col_count += 1
				end #row_each
				row_count += 1
			end
	        
		rescue Exception => e
	    	puts_ex e 
		end	
		
		
	end

#circle creation helper.
#if normal is not provided ZAxis will be used (0,0,1)
# returns an instance of Ads::Circle
  def create_circle(x,y,z,radius,normal=nil)
  	begin
  		normal ||= Ag::Vector3d.ZAxis
    	circ = Ads::Circle.new(Ag::Point3d.new(x, y, z), normal, radius)
    rescue Exception => e
      puts_ex e
    end	
    circ
  end
  
  
#PointEntity creation helper.
# returns an instance of Ads::DBPoint
  def create_point_ent(x,y,z=0)
  	begin
    	point = Ads::DBPoint.new(Ag::Point3d.new(x, y, z))
    rescue Exception => e
      puts_ex e
    end	
    point
  end  
  
#arc creation helper.  
#if normal is not provided ZAxis will be used (0,0,1)
#degrees_or_radians is passed as :D or :R to indicate units of the angle arguments
# returns an instance of Ads::Arc
  def create_arc(x,y,z,radius,start_angle, end_angle, degrees_or_radians, normal=nil)
  	begin
  		normal ||= Ag::Vector3d.ZAxis
  		start_angle, end_angle = start_angle.to_radians, end_angle.to_radians if degrees_or_radians == :D
    	arc = Ads::Arc.new(Ag::Point3d.new(x, y, z), normal, radius, start_angle, end_angle)
    rescue Exception => e
      puts_ex e
    end	
    arc
   end  
  
#line creation helper
#start_pt and end_pt are arrays of form [x,y,z=nil]
#if z is not provided, 0 will be used
# returns an instance of Ads::Line
  def create_line(start_pt, end_pt)
  	begin
  	  start_pt[2] ||= 0
	  end_pt[2] ||= 0
	  start = ac_pt3d(*start_pt)
      _end = ac_pt3d(*end_pt)
  	  line = Ads::Line.new(start,_end)
    rescue Exception => e
      puts_ex e
    end	
    line	
  end
  
#lwpolyline creation helper
#vertex_data_list is array of arrays of form
# [ [[x0,y0], bulge0], [[x1,y1], bulge1],...[[xN,yN], bulgeN] ]
#constructor assumes vertices are in desired order and assumes 0 width (start and end)
##returns an instance of Ads::PolyLine
  def create_pline(vertex_data_list)
  	begin
  	  pline = Ads::Polyline.new
  	  width_start = width_end = 0
  	  vertex_data_list.each_with_index do |vert,indx|
  	  	pt = ac_pt2d(*vert[0])
  	  	bulge = vert[1]
  	  	pline.AddVertexAt(indx, pt, bulge, width_start, width_end)
  	  end
    rescue Exception => e
      puts_ex e
    end	
    pline	
  end
  
  def create_pline_const_bugle(vertex_data_list, bulge=0)
  	begin
  	  pline = Ads::Polyline.new
  	  width_start = width_end = 0
  	  vertex_data_list.each_with_index do |vert,indx|
  	  	pt = ac_pt2d(*vert)
  	  	pline.AddVertexAt(indx, pt, bulge, width_start, width_end)
  	  end
    rescue Exception => e
      puts_ex e
    end	
    pline	
  end
  
end
