<!--- <cftry> --->
	<cfif listLen(attributes.directory,platformSlash) lt 2>
		<cfthrow detail="Prototype build directory must be in at least one below the root.">
	</cfif>
	
	<!--- Set buildDir equal to the root directory like "c:\inetpub". --->
	<cfset buildDir=ListFirst(attributes.directory,platformSlash) & platformSlash & ListGetAt(attributes.directory,2,platformSlash) & platformSlash>
	<cfif not Find(":",buildDir,1)>
		<cfset buildDir="/" & buildDir>
	</cfif>
	
	<!--- If the root directory doesn't exist, halt. --->
	<cfif not DirectoryExists(buildDir)>
		<cfthrow detail="The prototype was unable to be generated. Rebar was unable to access <strong>#buildDir#</strong>.">
	</cfif>

	<!--- Starting at the next directory after the root directory, build up the directories if they don't already exist. --->
	<cfloop from="3" to="#ListLen(attributes.directory,platformSlash)#" index="count">
		<!--- The first time through, buildDir is like "c:\inetpub\wwwroot\". --->
		<cfset buildDir=buildDir & ListGetAt(attributes.directory,count,platformSlash) & platformSlash>
		<!--- If that directory doesn't exist, --->
		<cfif not DirectoryExists(buildDir)>
			<cftry>
				<!--- Try to create it. --->
				<cfdirectory action="CREATE" directory="#buildDir#">
				<cfcatch>
					<cfthrow detail="The prototype was unable to be generated. Rebar was unable to create <strong>#buildDir#</strong>.">
				</cfcatch>
			</cftry>
		</cfif>
	</cfloop>

<!--- 	<cfcatch>
		<!--- Halt processing. --->
		<cfset runMe=0>
		<cfset message=cfcatch.detail>
	</cfcatch>
</cftry> --->

<cfparam name="runMe" default="1">

<cfif runMe>
	
	<!--- Create the wireframe structure --->
	<cfinclude template="act_readFiles.cfm">
	<cfinclude template="act_makeFileIntoStruct.cfm">

	<!--- If the user entered ".html" (with the dot), for example, remove the dot. --->
	<cfif left(attributes.exportFileExtension,1) EQ ".">
		<cfset attributes.exportFileExtension = Right(attributes.exportfileExtension,decrementvalue(len(attributes.exportFileExtension)))>
	</cfif>

	<!--- Remove any file extensions - only keep what comes before any first dot. --->
	<cfset attributes.homepagefilename = listfirst(attributes.homepagefilename,".")>

	<!--- Loop through the entire wireframe structure. --->
	<cfloop collection="#wireframe#" item="aPage">
		
		<!--- Grab the output of each page, one at a time. --->		
		<cfsavecontent variable="pageOutput">
			<cfmodule template="index.cfm" 
				fuseaction="rebar.page" 
				page="#aPage#" 
				includeNav="0" 
				includeGoesTo="0"
				fileExtension="#attributes.exportFileExtension#"
				layoutFile="#attributes.layoutFile#">
		</cfsavecontent>
	
	<cfif findNoCase("<LINK href=""",pageOutput,1)>
		<cfset styleSheetStart=findNoCase("<LINK href=",pageOutput,1)+12>
		<cfif findNoCase(""" rel=stylesheet type=text/css>",pageOutput,styleSheetStart)>
			<cfset styleSheetEnd=findNoCase(""" rel=stylesheet type=text/css>",pageOutput,styleSheetStart)>
			<cfset styleSheetName=mid(pageOutput,styleSheetStart,styleSheetEnd-styleSheetStart)>
			<cffile action="COPY" source="#GetDirectoryFromPath(GetCurrentTemplatePath())##platformSlash##lcase(stylesheetname)#" destination="#buildDir##lcase(styleSheetName)#">
		</cfif>
	</cfif>

	<cfset pageOutput=replace(pageOutput,"<a href=""index.cfm?fuseaction=rebar.editPage&pageName=#lcase(aPage)#"">Edit Page</a>","","all")>

	<cfset pageOutput=replace(pageOutput,"<a href=""index.cfm?fuseaction=rebar.help"">Help</a>","","all")>
	
	<cfset blowOut=1> <!--- Hi, I'm Nat.  I'm superstitious --->
 	<cfloop condition="findNoCase('index.cfm?fuseaction=',pageOutput,1) AND blowOut lt 500">
		<cfset blowOut=blowOut+1>
		<cfset linkStart=findNoCase("<a href=""index.cfm?fuseaction=rebar.page&page=",pageOutput,1)+45>
		<cfset linkEnd=findNoCase(""">",pageOutput,linkStart)>
		<cfset pageLength = linkEnd - linkStart>
		<cfif pageLength LT 0><cfset pageLength = 0></cfif>
		<cfset linkPage=mid(pageOutput,linkStart,pageLength)>
	
		<!--- make sure linkpage is a valid filename --->
		<cfset linkPage2 = linkPage>
		<cfif refind("[[::alpha:]]",mid(linkPage,1,1))>
			<cfset linkPage2 = "_" & linkPage>
		</cfif>
		
		<cfset firstQuotePosition = find("""","#linkPage2#")>
		
		<cfif firstQuotePosition> <!--- There is another argument beyond the href --->
			<cfset secondQuotePosition = find("""","#linkPage2#",firstquoteposition)>
			<cfset linkPagePart1 = mid(linkPage2,1,decrementvalue(secondQuotePosition))>
			<cfset linkPage2 = rereplace(linkPagePart1, "[^A-Za-z0-9\""]", "_", "All")>
		<cfelse>
			<cfset linkPage2 = rereplace(linkPage2, "[^A-Za-z0-9\""]", "_", "All")>
		</cfif>
		
		<cfset pageOutput=replace(pageOutput,"index.cfm?fuseaction=rebar.page&page=#lcase(linkPage)#",linkPage2 & ".#attributes.exportFileExtension#","one")>
	</cfloop>
	
	<cfif blowOut lte 500>
		<!--- make sure apage is a valid filename --->
		<cfif refind("[[::alpha:]]",mid(aPage,1,1))>
			<cfset aPage = "_" & aPage>
		</cfif>
		<cfset aPage = rereplace(aPage, "[^A-Za-z0-9\""]", "_", "All")>
		<!--- Now write the file --->
	 	<cffile action="WRITE" file="#buildDir##lcase(aPage)#.#lcase(attributes.exportFileExtension)#" output="#pageOutput#" nameconflict="OVERWRITE">
	<cfelse>
		There was an error writing the file <cfoutput>#lcase(aPage)#.#lcase(attributes.exportFileExtension)#</cfoutput>. It was not created.<br>
	</cfif>
</cfloop>

<cfset indexOutput="
<html>
<head>
	<title>Relocating</title>
	<meta http-equiv=""Refresh"" content=""0;url='#rereplace(lcase(attributes.indexpage), "[^A-Za-z0-9]", "_", "All")#.#lcase(attributes.exportFileExtension)#'"">
	</head>
	<body>
	</body>
</html>">


<cffile action="WRITE" file="#buildDir##lcase(attributes.homePageFileName)#.#lcase(attributes.exportFileExtension)#" output="#indexOutput#" nameconflict="SKIP">

</cfif>

<cfset message="buildDir=#urlencodedFormat(buildDir)#">

<cfif ListFind("html,htm",attributes.exportfileextension)>
	<cfset message=message & "&link=1">
</cfif>