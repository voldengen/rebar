<cfset assembledPage = "">
<cfparam name="attributes.blurb" default="">
<cfparam name="attributes.linkPages" default="">
<cfparam name="attributes.nestedPages" default="">

<cftry>
<cfif isDefined("attributes.title")>
	<cfset assembledPage = "[" & attributes.title & "]" & chr(13) & chr(10)>
<cfelse>
	<cfthrow type="malformedBlock" detail="Every page requires a title.">	
</cfif>

<cfloop list="#attributes.blurb#" delimiters="#chr(13)#" index="i">
	<cfset i = replace(i,chr(10),"")>
	<cfif len(i)>
		<cfset assembledPage = assembledPage & ";" & i & chr(13) & chr(10)>
	</cfif>
</cfloop>

<cfset NestedList = "">
<cfset LinkList = "">
<cfset templist = "">
<cfset tempnest = "">

<cfloop list="#attributes.linkPages##chr(10)##attributes.nestedPages#" delimiters="#chr(10)#" index="i">
	<cfif listLen(i,"=") GT 1>
		<!--- Link --->
		<cfif NOT listFindnoCase(tempList,i)>
			<cfset LinkList = LinkList & i & chr(13) & chr(10)>
			<cfset templist = listappend(templist,i)>
		</cfif>
	<cfelseif listLen(i,"=" EQ 1)>
		<!--- nested page --->
		<cfif NOT listFindnoCase(tempnest,i)>
			<cfset NestedList = NestedList & i & chr(13) & chr(10)>
			<cfset tempnest = listappend(tempnest,i)>
		</cfif>
	</cfif>
</cfloop>

<cfset assembledpage = assembledpage & LinkList & NestedList & "---------------------------------------------------------">


<cfif DirectoryExists(wireframedatadirectory)>
	<cffile action="WRITE" file="#wireframedatadirectory##lcase(attributes.title)#.wir" output="#assembledPage#">
<cfelse>
	<cfset attributes.dir=listLast(wireframedatadirectory,platformSlash)>
	<cfinclude template="act_createWireframeDir.cfm">
	<cffile action="WRITE" file="#wireframedatadirectory##lcase(attributes.title)#.wir" output="#assembledPage#">
</cfif>
<cfcatch><cflocation url="index.cfm?fuseaction=rebar.newPage2&message=#urlencodedFormat('Unable to create the wireframe page <strong>#attributes.title#</strong>.')#" addtoken="No"></cfcatch>
</cftry>

<cflocation url="index.cfm?fuseaction=rebar.page&page=#lcase(attributes.title)#" addtoken="No">
