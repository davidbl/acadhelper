# Extend Ads::DBText with some helper methods
  class Autodesk::AutoCAD::DatabaseServices::DBText
# add a DBPoint entity at the insertion point of the text
# Z value by the return value of the block
#  example of block is  { |text| text.TextString.to_f } - set z to the value of the textString
#  example:   { |text| 1000 + text.TextString.to_f }  - set z to the value of the textString + 1_000
#  example:   { |text| text.TextString.match(/[\d\.]+\Z/)[0].to_f } - use regex to get the number at the end of the string
#  example:   { |text|  text.Database.Elevation} - set z to current Elevation
  	def add_point(&block)
  		x,y = self.Position.X, self.Position.Y
  		z = block.call(self)
  		new_point = create_point_ent(x,y,z)
  		new_point.add_to_current_space
   	end
   	
   	
  end #class Ads::DBText