<cfdirectory action="LIST" directory="#wireframedatadirectory#" name="wireframedata">

<cfset file="">
<cfloop query="wireframedata">
	<cfif type is "file">
		<cffile action="READ" file="#wireframedatadirectory##lcase(name)#" variable="tempFile">
		<cfset file=file &tempFile>
	</cfif>
</cfloop>
