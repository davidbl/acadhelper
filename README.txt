= acadhelper

http://github.com/davidbl/acadhelper
== DESCRIPTION:

Wrappers and helpers to simplify the access to the AutoCAD Managed .Net API
using IronRuby and Ruby code

== FEATURES/PROBLEMS:

* FIX (list of features or problems)

== SYNOPSIS:


require 'rubygems'
require 'acadhelper'

include AcadHelper

 def circle_example
   begin
     my_circle = create_circle 5,5,1,6 #x,y,z,radius
     my_circle.add_to_current_space
   rescue Exception => e
     puts_ex e
   end  
 end

## see examples directory for more info and example
## also the rdoc's are a good source of information

== REQUIREMENTS:

AutoCAD, Version 2009 or greater
IronRuby 0.9.0  (hasn't been fully tested with 0.9.2 yet)
RubyAcad.dll compiled against your version of AutoCAD 
    Download the current source from github http://github.com/davidbl/acadhelper_loader)
(see the README there for information about loading Ruby files into AutoCAD  
   
== INSTALL:

cd {to your clone dir}
irake gem
cd pkg
igem install acadhelper-0.5.0.gem

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
