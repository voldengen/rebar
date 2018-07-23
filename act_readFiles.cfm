<cfdirectory action="LIST" directory="#wireframedatadirectory#" name="wireframedata">
<cfset bigfile="">
<cfquery name="wireframedata" dbtype="query">
	select * from wireframedata 
	where type='File' AND
	name like '%.wir'
	order by Name 
</cfquery>
<cfloop query="wireframedata">
	<cffile action="READ" file="#wireframedatadirectory##lcase(name)#" variable="tempFile">
	<cfset bigfile=toString(bigfile)&toString(tempFile)>
</cfloop>