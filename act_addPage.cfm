<cfif not len(trim(attributes.pageData))>
	<cflocation url="index.cfm?fuseaction=rebar.map" addtoken="No">
</cfif>
<cfset attributes.pageData=attributes.pageData & chr(10) & "---------------------------------------------------------">
<cftry>
<cfif not attributes.pageData contains "---------------------------------------------------------">
	<cfthrow type="malformedBlock" detail="Each data file must contain the long line of dashes (57 exactly)">
</cfif>
<cfif not (attributes.pageData contains "[" and attributes.pageData contains "]")>
	<cfthrow type="malformedBlock" detail="Each data file must contain a title, wrapped in brackets [ and ]">
</cfif>

<cfloop list="#attributes.pageData#" delimiters="#chr(10)#" index="aLine">
	<cfset firstChar=Left(aLine,1)>
	<cfif not ListFind(";,[,-,^,#chr(32)#,#chr(10)#",firstChar)>
		<!--- This is a page link --->
		<cfif ListLen(aLine,"=") is 1 and len(trim(aLine))>
			<cfif FileExists("#wireframedatadirectory##lcase(aLine)#")>
				<cffile action="READ" file="#wireframedatadirectory##lcase(aLine)#" variable="tempFile">
				<cfloop list="#tempFile#" delimiters="#chr(10)#" index="subLine">
					<cfset subFirstChar=Left(subLine,1)>
					<cfif not ListFind(";,[,-,^,#chr(32)#,#chr(10)#",subFirstChar)>
						<cfthrow type="malformedBlock" detail="Nested page nesting not allowed.">
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>
</cfloop>

<cfcatch type="malformedBlock">breaker, breaker!</cfcatch>
</cftry>

<cfset pageTitleStart=FindNoCase("[",attributes.pageData,1)>
<cfset pageTitleEnd=FindNoCase("]",attributes.pageData,pageTitleStart)>
<cfset title=Mid(attributes.pageData,pageTitleStart+1,pageTitleEnd-pageTitleStart-1)>

<cfif DirectoryExists(wireframedatadirectory)>
	<cffile action="WRITE" file="#wireframedatadirectory##lcase(title)#.wir" output="#attributes.pageData#">
<cfelse>
	<cfset attributes.dir=listLast(wireframedatadirectory,platformSlash)>
	<cfinclude template="act_createWireframeDir.cfm">
	<cffile action="WRITE" file="#wireframedatadirectory##lcase(title)#.wir" output="#attributes.pageData#">
</cfif>
<cflocation url="index.cfm?fuseaction=rebar.page&page=#title#" addtoken="No">
