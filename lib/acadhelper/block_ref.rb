#Wrappers for some of the editor functions

# Get the block reference object and yield an Ostruct with the attributes
#
# TODO - allow for constant attributes
#
# Example usage

# def test_block_ref
# 	begin
# 		ref_id = get_entity_id
# 		get_block_ref(ref_id, :Write) do |attribs|
# 			attribs.age = 50  #numbers can be used - get_block_ref will convert to string.  YEA!
# 			attribs.name = "Chuck"
# 			attribs.height = "72 inches"
# 			attribs.sex = "Male"
# 		end
# 		
# 	rescue Exception => e
# 		puts_ex e
# 	end
# end

def get_block_ref(obj_id, mode=:Read)
	begin
		helper = TransHelper.new
		helper.trans([:Block])  do |tr, db, tables|
			ref = helper.get_obj obj_id, mode
			attrib_hash = {}
			ref.AttributeCollection.each do |id|
				attrib = helper.get_obj id, :Read
				attrib_hash[attrib.Tag.downcase] = attrib.TextString
			end
			@attribs = OpenStruct.new(attrib_hash)
			yield @attribs
			#update the attribs
			if mode == :Write
				ref.AttributeCollection.each do |id|
					attrib = helper.get_obj id, :Write
					attrib.TextString = @attribs.send(attrib.Tag.downcase).to_s
				end
		    end
			
    	end    
	rescue Exception => e
		puts_ex e
	end
end

def insert_block(block_name, scale_x, scale_y, scale_z, x,y,z)
	begin
		helper = TransHelper.new
		return_id = nil
		helper.trans([:Block])  do |tr, db, tables|
			if tables.Block.Has block_name
				block_ref = Ads::BlockReference.new ac_pt3d(x,y,z), tables.Block[block_name]
				block_ref.ScaleFactors = Ag::Scale3d.new scale_x, scale_y, scale_z
				block_ref.add_to_current_space
				return_id= block_ref.ObjectId
			else
				raise ArgumentError, "Block Definition #{block_name} not found"
			end
		end
		return_id
	rescue ArgumentError => e
		raise e	
	rescue Exception => e
	 	puts_ex e
	 end
	
end