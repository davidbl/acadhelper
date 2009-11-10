#=wrappers for interfacing with the AutoLISP memory space and AutoLISP Functions

# extensions to the ResultBuffer class for easier access	
class Autodesk::AutoCAD::DatabaseServices::ResultBuffer
	def to_a
		ret_val = []
		self.AsArray.each do |typed_val|
			ret_val << typed_val.Value
		end
		ret_val
	end
	
	def to_full_array
		ret_val = []
		self.AsArray.each do |typed_val|
			ret_val << [typed_val.type_code, typed_val.value]
		end
		ret_val
	end
	
#just return the value	
	def val
		self.AsArray[0].value
	end
	
#just return the code	
	def code
		self.AsArray[0].type_code
	end
	
	def size
		self.AsArray.size
	end

#return the element whose code matches our argument	
	def assoc(code)
		arr = self.to_full_array
		arr.assoc(code)
	end
	
#return just the value of the element whose code matches our argument	
	def cdr_assoc(code)
		arr = self.to_full_array
		arr.assoc(code)[1]
	end
	
end	


#some wrapper methods for the C# EvaluateLisp function

#evaluate a string of LISP code
#examples of valid LISP strings include (setq x 55.5), (setq my_name "David Blackmon"), (entget(entlist)), (load "my_lisp_file")
#but, because the argument must be passed as a string,  we have to escape the quotes when the need them
#actual argument strings would be "(setq x 55.5)", "(setq my_name \"David Blackmon\")"
	def lisp_eval(lisp_string)
		ret_val = RubyAcad::Lisp.evalLisp(lisp_string)		
		return nil if ret_val.code == 5019
		ret_val
	end
	
#load a LISP file.  Raising ArgumentError is file is not in the AutoCAD search path	
	def lisp_load(file_name)
		find_file_res = lisp_eval "(findfile  \"#{file_name}\")"

		if find_file_res
			lisp_eval "(load \"#{file_name}\")" 
		else 
			raise ArgumentError, "file #{file_name} not found"	
		end	
	end

#a wrapper for LISP setq - now only works for simple assigns such as (setq x 5), (setq y "abc")	
#and lists (setq my_list (list 1 2 3 "test" "foo" "bar" 3.1419))
#the sym argument can be a Ruby symbol or a string
#valid calls are setq("x", 55.5), setq(:x, 55.5), setq("y", "this is a string variable")
#setq(:my_list, (list 22, 33, 44))
	def setq(sym, expr)
		if expr.is_a?(String)
			if expr.match(/\(list/)	
				str = "(setq #{sym.to_s} #{expr.to_s})" 
			else	
				str = "(setq #{sym.to_s} \"#{expr.to_s}\")" 
			end	
			puts str
		else
			str = "(setq #{sym.to_s} #{expr.to_s})" 
			puts str

		end	
		lisp_eval str
	end

#get the value of a LISP symbol, passed a Ruby symbol,eg getq(:x), getq(:my_list)	
	def getq(sym)
		ret_val = lisp_eval "(vl-symbol-value \'#{sym.to_s} )"
	end

