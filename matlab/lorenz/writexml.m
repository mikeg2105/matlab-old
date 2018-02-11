%write xml
%functions for writing xml

function [xmlfile]=xmlfile(filename, schemaname, schemahyperlink)
 xmlfile=mfopen(filename, 'w')
%endfunction

function openxml(fd, )
	fprintf(fd, '<%s/>', elementname);
%endfunction



%attribute list is a list of lists one attrib is number of attributes
%Each list element is a triple of attribute name and attribute value

%Note See programming quote
%to get a double quote output in a string

function openxmlelement(fd, elementname, attributelist, numattributes)

   fprintf(fd, '<%s ', elementname);
   for i=1:numattributes
     attrbname=attributelist(i,1);
     attrbvalue=attributelist(i,2);
     fprintf(fd, '%s="%s"', attrbname, attrbvalue)
   
   end
	fprintf(fd, '>\n');


%endfunction


function closexmlelement(fd, elementname)

   fprintf(fd, '</%s>', elementname);

%endfunction

%ivaluetype indicates the type
% 0 string
% 1 int
% 2 float
% 3 double
function writeattribute(fd, name, value, ivaluetype)


%%endfunction

function closexmlelement(fd, elementname)




%%endfunction

