<cfset Wireframe=StructNew()>
<cfset WireFrame["_wireframe_pages_to_insert"]="">
<cfset bigfile=Replace(bigfile,"---------------------------------------------------------","^","all")>
<cfloop list="#bigfile#" delimiters="^" index="page">
	<cfset pageTitleStart=FindNoCase("[",page,1)>
	<cfif pageTitleStart>
		<cfset ThisPage=StructNew()>
		<cfset pageTitleEnd=FindNoCase("]",page,pageTitleStart)>
		<cfset ThisPage.Title=Mid(page,pageTitleStart+1,pageTitleEnd-pageTitleStart-1)>
		<cfset ThisPage.Links=StructNew()>
		<cfset count=0>
		<cfloop list="#page#" delimiters="#chr(10)#" index="aLine">
			<cfset count=count+1>
			<cfset firstChar=Left(aLine,1)>
			<cfif not ListFind(";,[,-,^,#chr(32)#,#chr(10)#",firstChar)>
				<cfif ListLen(aLine,"=") is 2>
					<cfif not structkeyexists(ThisPage.Links,ListFirst(aLine,"="))>
						<cfset StructInsert(ThisPage.Links,ListFirst(aLine,"="),ListLast(aLine,"="))>
						<cfset page=Replace(page,aLine,"","one")>
					</cfif>
				<cfelseif ListLen(aLine,"=") is 1 and len(trim(aLine))>
					<cfif not structkeyexists(ThisPage.Links,"_wireframe_insert_page#count#")>
						<cfset StructInsert(ThisPage.Links,"_wireframe_insert_page#count#",ListFirst(aLine,"="))>
						<cfset page=Replace(page,aLine,"","one")>
						<cfset Wireframe["_wireframe_pages_to_insert"]=ListAppend(WireFrame["_wireframe_pages_to_insert"],ThisPage.Title)>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfset ThisPage.Description=ArrayNew(1)>
		<cfloop list="#ListRest(page,';')#" delimiters=";" index="aDescription">
			<cfset ArrayAppend(ThisPage.Description,aDescription)>
		</cfloop>
	</cfif>
	<cfset StructInsert(Wireframe,ThisPage.Title,Duplicate(ThisPage),1)>
</cfloop>
<!--- <cfdump var="#wireframe#"><br><br> --->
<cfloop list="#wireframe['_wireframe_pages_to_insert']#" index="page">
	<cfloop collection="#wireframe[page].links#" item="aLink">
		<cfif left(aLink,22) is "_wireframe_insert_page">
			<cfset EmbeddedLinks=0>
			<cfif StructKeyExists(wireframe,aLink)>
				<cfloop collection="#wireframe[trim(wireframe[page].links[aLink])].links#" item="key">
					<cfif key is "_wireframe_insert_page">
						<cfset EmbeddedLinks=1>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfif not EmbeddedLinks>
				<cfset tempStruct=StructNew()>
				<cftry>
				<cfloop collection="#wireframe[trim(wireframe[page].links[aLink])].links#" item="insertedKey">
					<cfset StructInsert(tempStruct,insertedKey,wireframe[trim(wireframe[page].links[aLink])].links[insertedKey])>
				</cfloop>
				<cfcatch></cfcatch>
				</cftry>
				<cfset StructInsert(wireframe[page].links,wireframe[page].links[aLink],duplicate(tempStruct),1)>
			<cfelse>
				<cfset StructInsert(wireframe[page].links,"LINKING FAILED","INFINITE LINKING ENCOUNTERED!",1)>
			</cfif>
			<cfset StructDelete(wireframe[page].links,aLink,0)>
		</cfif>
	</cfloop>
	<!--- <cfdump var="#wireframe#"><cfabort> --->
</cfloop>

<cfset StructDelete(wireframe,"_wireframe_pages_to_insert")>


