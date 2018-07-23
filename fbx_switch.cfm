<!---
<fusedoc fuse="FBX_Switch.cfm">
	<responsibilities>
		I am the cfswitch statement that handles the fuseaction, delegating work to various fuses.
	</responsibilities>
	<io>
		<string name="fusebox.fuseaction" />
		<string name="fusebox.circuit" />
	</io>	
</fusedoc>
--->
	
<cfswitch expression = "#fusebox.fuseaction#">
    
	<cfcase value="map,fusebox.defaultfuseaction">
		<cfinclude template="act_readFiles.cfm">
		<cfinclude template="act_makeFileIntoStruct.cfm">
		<cfinclude template="dsp_map.cfm">
	</cfcase>

	<cfcase value="page">
		<cfparam name="attributes.page" default="">	
		<cf_stripwhitespace>
		<cfif listLen(attributes.page,".") gt 1>
			<cfmodule template="index.cfm" fuseaction="rebar.setWireframeDir"
				dir="#listdeleteAt(attributes.page,listlen(attributes.page,'.'),'.')#">
			<cflocation url="index.cfm?fuseaction=rebar.page&page=#Listlast(attributes.page,'.')#" addtoken="No">
		</cfif>
		<cfinclude template="act_readFiles.cfm">
		<cfinclude template="act_makeFileIntoStruct.cfm">
		<cfinclude template="dsp_page.cfm">
		</cf_stripwhitespace>
	</cfcase>
	
	<cfcase value="addPage">
		<cfinclude template="act_addPage.cfm">
	</cfcase>
	
	<cfcase value="addPage2">
		<cfinclude template="act_addPage2.cfm">
	</cfcase>
	
	<cfcase value="editPage,newPage">
		<cfinclude template="act_readFiles.cfm">
		<cfinclude template="act_makeFileIntoStruct.cfm">
		<cfif fusebox.fuseaction is "newPage">
			<cfset xfa.submit="rebar.addPage">
		<cfelse>	
			<cfset xfa.submit="rebar.updatePage&title=#lcase(attributes.pageName)#">	
			<cfset fileName="#attributes.pageName#.wir">
			<cfinclude template="act_readFileForUpdate.cfm">
		</cfif>
		<cfinclude template="dsp_pageForm.cfm">
	</cfcase>
	
	<cfcase value="editPage2,newPage2">
		<cfinclude template="act_readFiles.cfm">
		<cfinclude template="act_makeFileIntoStruct.cfm">
		<cfif fusebox.fuseaction is "newPage2">
			<cfset xfa.submit="rebar.addPage2">
		<cfelse>
			<cfset xfa.submit="rebar.updatePage2">	
			<cfset fileName="#lcase(attributes.pageName)#.wir">
			<cfinclude template="act_readFileForUpdate.cfm">
		</cfif>
		<cfinclude template="dsp_pageForm3.cfm">
	</cfcase>
	
	<cfcase value="updatePage">
		<cfinclude template="act_updatePage.cfm">
	</cfcase>
	
	<cfcase value="updatePage2">
		<cfinclude template="act_updatePage2.cfm">
	</cfcase>
	
	<cfcase value="admin">
		<cfinclude template="act_getWireframeDirs.cfm">
		<cfinclude template="dsp_admin.cfm">
	</cfcase>
	
	<cfcase value="setWireframeDir">
		<cfset xfa.continue="rebar.map">
		<cfset xfa.notRebar="rebar.convert">
		<cfinclude template="act_setWireframeDir.cfm">
	</cfcase>
	
	<cfcase value="convert">
		<cfinclude template="dsp_convertConfirm.cfm">
	</cfcase>
	
	<cfcase value="createWireframeDir">
		<cfset attributes.dir=trim(attributes.dir)>
		<cfset xfa.notrebar = "rebar.convert">
		<cfset xfa.continue = "rebar.map">
		
		<cfinclude template="act_createWireframeDir.cfm">
		<cfinclude template="act_createWireframeHome.cfm">
		<cfinclude template="act_setWireframeDir.cfm">
		<cflocation url="index.cfm?fuseaction=rebar.map" addtoken="No">
	</cfcase>
	
	<cfcase value="buildOne">
		<cfsavecontent variable="temp"><cfmodule template="index.cfm" 
			fuseaction="rebar.setWireframeDir" dir="#attributes.wireframename#"></cfsavecontent>
		<cfinclude template="act_readFiles.cfm">
		<cfinclude template="act_makeFileIntoStruct.cfm">
		<cfinclude template="act_getLayoutFiles.cfm">
		<cfset xfa.continue="rebar.buildTwo">
		<cfinclude template="dsp_buildOne.cfm">
	</cfcase>
	
	<cfcase value="buildTwo">
		<cfinclude template="act_buildHTML.cfm">
		<cflocation url="index.cfm?fuseaction=rebar.admin&generated=1&#message#" addtoken="No">
	</cfcase>
	
	<cfcase value="deletePage">
		<cfinclude template="act_deletePage.cfm">
		<cflocation url="index.cfm?fuseaction=rebar.map" addtoken="No">
	</cfcase>
	
	<cfcase value="help">
		<cfinclude template="dsp_help.cfm">
	</cfcase>
	
	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput>This is the cfdefaultcase tag. I received a fuseaction called "#attributes.fuseaction#" and I don't know what to do with it.</cfoutput>
	</cfdefaultcase>

</cfswitch>
