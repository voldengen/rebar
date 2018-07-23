<cfdirectory action="LIST" directory="#GetDirectoryFromPath(GetCurrentTemplatePath())#" name="wireframedirs">
<cfquery name="wireframedirs" dbtype="query">
	select * from wireframedirs
	where type='Dir' and name <> '.' and name <> '..' AND Name != '_layouts'
</cfquery>

<cfset badFolders="reserved">

<cfloop query="wireframedirs">
	<cfset thisFolderName=wireframedirs.name>
	<cfdirectory action="LIST"
		directory="#GetDirectoryFromPath(GetCurrentTemplatePath())##lcase(trim(thisFolderName))#" 
		name="datafiles">
	<cfquery name="datafiles" dbtype="query">
		select * from datafiles
		where type='File'
	</cfquery>
	<cfquery name="temp" dbtype="query">
		select * from datafiles
		where type='File' and name like '%.wir'
	</cfquery>
	<cfif temp.recordcount neq datafiles.recordcount>
		<cfset badFolders=ListAppend(badFolders,lcase(trim(thisFolderName)))>
	</cfif>
</cfloop>

<cfset badFolderCount=listLen(badFolders)>
<cfset currentFolder=1>

<cfquery name="wireframedirs" dbtype="query">
	select * from wireframedirs 
	where type='Dir' and name not in (<cfloop list="#badFolders#" index="aFolder">'#aFolder#'<cfif currentFolder lt badFolderCount>,</cfif><cfset IncrementValue(currentFolder)></cfloop>)
</cfquery>

