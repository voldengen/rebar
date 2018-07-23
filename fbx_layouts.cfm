<!--- Preserved for compliance --->
<cfset fusebox.layoutDir="">

<cfparam name="attributes.includeNav" default="1">
<cfif attributes.includeNav>
	<!--- DO NOT MODIFY THE NAME OF THIS FILE --->
	<cfset fusebox.layoutFile = "lay_defaultLayout.cfm">
<cfelse>
	<!--- This is the layout file used for prototype generation. There is no need to modify this file. To use a different layout file than the one specified here, simply create a new layout file, place it in the /rebar/_layouts/ directory and it will appear on the prototype generator. --->
	<cfparam name="attributes.layoutFile" default="lay_noNav.cfm">
	<cfset fusebox.layoutFile="#fusebox.rootpath#_layouts/#attributes.layoutFile#">
	<!--- Change this layout file to change the default prototype generation file. --->
</cfif>