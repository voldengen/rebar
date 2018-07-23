<cffile action="READ" file="#wireframedatadirectory##lcase(fileName)#" variable="tempfile">
<cfset fileforupdate="">
<cfloop list="#tempfile#" delimiters="#chr(10)#" index="aLine">
	<cfif len(trim(aLine)) and trim(aLine) neq "---------------------------------------------------------">
		<cfset aLine=replace(aLine,chr(10),"","all")>
		<cfset fileforupdate=fileforupdate&aLine>
	</cfif>
</cfloop>