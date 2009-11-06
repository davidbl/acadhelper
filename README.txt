= acadhelper

http://github.com/davidbl/IronRuby-Autocad-Helper
== DESCRIPTION:

Wrappers and helpers to simplify the access to the AutoCAD Managed .Net API
using IronRuby and Ruby code

== FEATURES/PROBLEMS:

* FIX (list of features or problems)

== SYNOPSIS:

require 'acadhelper'
require 'acad2009' # or your version of this file
include AcadHelper

 def circle_example
   begin
     my_circle = create_circle 5,5,1,6 #x,y,z,radius
     my_circle.add_to_current_space
   rescue Exception => e
     puts_ex e
   end  
 end

##see examples directory for more info and example

== REQUIREMENTS:

AutoCAD, Version 2009 or greater
IronRuby 0.9.0
RubyAcad.dll compiled against your version of AutoCAD 
   (a snapshot is included in acadhelper/lib/acadheler/rubyacad.cs
    Download the current source from github http://github.com/davidbl/IronRuby-Autocad-Helper)
   
== INSTALL:

igem install acadhelper

== LICENSE:

(The MIT License)

Copyright (c) 2009 David K. Blackmon

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
