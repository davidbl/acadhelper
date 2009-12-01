# Autocad helper Module
# These methods are used to simplify extending AutoCAD using Ruby and IronRuby
# They depend on a .Net Managed DLL written by Kean Walmsley that can be found here
# http://through-the-interface.typepad.com/through_the_interface/2009/04/using-ironruby-inside-autocad.html
# AcadHelper#add_commands is based on Kean's code

#ostruct is used in Transhelper
#search paths should be set in acad2009.rb 
require 'ostruct'



module AcadHelper
# Constants for accessing the AutoCAD managed object model
  Ai =  Autodesk::AutoCAD::Internal
  Aiu = Autodesk::AutoCAD::Internal::Utils
  Aas = Autodesk::AutoCAD::ApplicationServices
  Ads = Autodesk::AutoCAD::DatabaseServices
  Aei = Autodesk::AutoCAD::EditorInput
  Ag =  Autodesk::AutoCAD::Geometry
  Ar =  Autodesk::AutoCAD::Runtime
  

require 'acadhelper/ads_entity'
require 'acadhelper/transhelper'
require 'acadhelper/create_ent'
require 'acadhelper/editor'
require 'acadhelper/ads_dbtext'
require 'acadhelper/ads_selset'
require 'acadhelper/block_ref'
require 'acadhelper/autolisp'


alias old_gets gets
  


  def gets
  	begin
       get_input :String, " ", :AllowSpaces => true
    rescue Exception => e
	      puts_ex e
    end   
  end
  
# Exception helper  
# outputs the backtrace by default
  def puts_ex(e)
	puts "\nException:  #{e}"
	puts e.backtrace	
  end 
  
# Pop an alert box()
	def alert( msg ) 
		begin
	    	Aas::Application.ShowAlertDialog msg
	    rescue Exception => e
	      puts_ex e
	    end
	end

# Get the ObjectId of the last entity in the database
  def last_ent
     ed.SelectLast.Value[0].ObjectId
  end
  
# Send a message to the AutoCAD commandline -- deprecated by 'puts'
  def ed_write(msg)
    Aas::Application.DocumentManager.MdiActiveDocument.Editor.WriteMessage "\n" + msg
  end
 
# Create an instance of the Editor
  def ed
  	Aas::Application.DocumentManager.MdiActiveDocument.Editor
  end


# NOTE: add_commands and add_all_commands have been deprecated by the new loader
# that automatically registers command at load time.  These commands are provided now
# for use by those users that have not updated to the new loader
#_______  
# Register commands with AutoCAD so they can be executed from the command line
# names argument should be an array of method names as strings ["func1", "foo", "bar"]
# example usage --  add_commands %w( my_new_command my_other_command the_old_version )
# currently, existing commands will be overwritten
# mode (:verbose, :digest, :silent) controls the display of the 'Registered Ruby command' message
	def add_commands(names, mode=:verbose)
		digest = "" if mode == :digest
		begin
		    names.each do |name|
		    	 Aiu.RemoveCommand('rbcmds', name)
		    	#don't add commands if they take arguements
		    	if method(name).arity == 0
	 			   cc = Ai::CommandCallback.new  method(name)
				   Aiu.AddCommand('rbcmds', name, name, Ar::CommandFlags.Modal, cc)
				   puts "\nRegistered Ruby command: #{name}" if mode == :verbose
				   digest << "#{name} " if mode == :digest
				end   
			end
			puts "\nRegistered Ruby command(s): #{digest}" if mode == :digest
		rescue Exception => e
	      puts_ex e
	    end
	end
	
# NOTE: add_commands and add_all_commands have been deprecated by the new loader
# that automatically registers command at load time.  These commands are provided now
# for use by those users that have not updated to the new loader
# _______  
# register ALL top-level methods with AutoCAD so they can be executed from the command line
# any top-level methods that should be excluded from registration can be added to an instance 
# variable arrary named @exclude
# mode (:verbose, :digest, :silent) controls the display of the 'Registered Ruby command' message
# NOTE:  add_commands method will automatically exclude commands that require arguments
    def add_all_commands(mode = :verbose )
    	begin
    	  @exclude ||= []	
    	  all = private_methods(false) - %w(initialize method_missing) - @exclude
     	  add_commands all, mode
    	rescue Exception => e
	      puts_ex e
	    end  
 	end

# Some numeric conversions
	def to_radians(num)
		num * Math::PI/180.0
	end
	
	def to_degrees(num)
		num * 180 / Math::PI
	end

# transaction helper that executes a code block within the context of a managed transaction
# NOTE:  trans has been deprecated by the TransHelper class
	def trans
		begin
	       app = Aas::Application
	       doc = app.DocumentManager.MdiActiveDocument
	       db = doc.Database
	       tr = doc.TransactionManager.StartTransaction
	       yield tr, db
	
	       tr.Commit
	       tr.Dispose
	    rescue Exception => e
	       puts_ex e
	    ensure
	      tr.Dispose        
	    end	
	end



end #Module AcadHelper

# add some helper methods  to Ruby::Numeric classes	
  class Numeric
	  def round_up(nearest=10)
	    self % nearest == 0 ? self : self + nearest - (self % nearest)
	  end
	  def round_down(nearest=10)
	    self % nearest == 0 ? self : self - (self % nearest)
	  end
	  def round_nearest(nearest=10)
	    up = round_up(nearest)
	    down = round_down(nearest)
	    if (up-self) < (self-down)
	      return up
	    else
	      return down
	    end
	  end
	  
	  def to_radians
			self * Math::PI/180.0
	  end
		
	  def to_degrees
			self * 180 / Math::PI
	  end
	  
   end
  

