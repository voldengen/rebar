<!--- Include the settings file --->
<cfinclude template="settings.conf">

<cfif attributes.showDebugOutput>
	<cfsetting showdebugoutput="Yes">
<cfelse>
	<cfsetting showdebugoutput="No">
</cfif>

<!--- In case no fuseaction was given, I'll set up one to use by default. --->
<cfparam name="attributes.fuseaction" default="rebar.admin">

<!--- Read the settings file to determine where the wireframe directory is --->
<cfif not listFind("rebar.setWireframeDir,rebar.admin,rebar.createWireframeDir",attributes.fuseaction)>
	<cftry>
		<cffile action="READ" variable="currentWireframeDir" 
			file="#GetDirectoryFromPath(GetCurrentTemplatePath())#app_currentWireframe.cfm">
			<cfset currentWireframeDir=trim(currentWireframeDir)>
			<cfif not len(currentWireframeDir)>
				<cflocation url="index.cfm?fuseaction=rebar.admin" addtoken="No">
			</cfif>
		<cfcatch>
			<cflocation url="index.cfm?fuseaction=rebar.admin" addtoken="No">
		</cfcatch>
	</cftry>
</cfif>

<cfif server.os.name contains "Windows">
	<cfset platformSlash="\">
<cfelse>
	<cfset platformSlash="/">
</cfif>

<cftry>
	<!--- The path to the wireframedata folder --->
	<cfset wireframedatadirectory="#GetDirectoryFromPath(GetCurrentTemplatePath())##trim(currentWireframeDir)##platformSlash#">	
	<!--- The wireframe name --->
	<cfset wireframename="#trim(currentWireframeDir)#">
<cfcatch></cfcatch>
</cftry>

<cfscript>
function Capitalize(str) {
	var newstr = "";
	var word = "";
	var i = 1;
	var strlen = listlen(str," ");
	for(i=1; i lte ListLen(str," "); i=i+1) {
		word = ListGetAt(str, i, " ");
		newstr = newstr & UCase(Left(word,1));
		if(len(word) gt 1) newstr = newstr & lcase(Right(word,Len(word)-1));
		if(i lt strlen) newstr = newstr & " ";
	}
	return newstr;
}
</cfscript>
