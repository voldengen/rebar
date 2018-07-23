<cfdirectory action="LIST" directory="#GetDirectoryFromPath(GetCurrentTemplatePath())#_layouts#platformSlash#" name="allFiles">

<cfquery name="layoutFiles" dbtype="query">
	select * from allFiles
	where Type='File' AND
	Name like 'lay_%' AND 
	Name like '%.cfm'
	order by Name 
</cfquery>