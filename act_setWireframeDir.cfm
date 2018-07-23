<cffile action="WRITE" 
	output="#attributes.dir#"
	file="#GetDirectoryFromPath(GetCurrentTemplatePath())#app_currentWireframe.cfm"
	nameconflict="OVERWRITE">

<cfdirectory action="LIST" directory="#GetDirectoryFromPath(GetCurrentTemplatePath())##platformSlash##lcase(attributes.dir)#" name="wireframeFiles">

<cfif wireframeFiles.recordCount>
	<cfset rebarFormat=1>
	
	<cfloop query="wireframeFiles">
		<cfif left(name,9) neq "wireframe" AND type is "file">
			<cfset rebarFormat=1>
			<cfbreak>
		</cfif>
	</cfloop>
<cfelse>
	<cfset rebarFormat=1>
</cfif>

<cfset currentWireframeDir=lcase(trim(attributes.dir))>
<cfset wireframedatadirectory="#GetDirectoryFromPath(GetCurrentTemplatePath())##lcase(trim(attributes.dir))##platformSlash#">	
<cfset wireframename="#lcase(trim(attributes.dir))#">

<cfif not rebarFormat>
	<cflocation url="index.cfm?fuseaction=#xfa.notRebar#" addtoken="No">
<cfelse>
	<cfif not fusebox.IsCustomTag>
		<cflocation url="index.cfm?fuseaction=#xfa.continue#" addtoken="No">
	<cfelse>
		<cfset caller.currentWireframeDir=lcase(currentWireframeDir)>
		<cfset caller.wireframedatadirectory=wireframedatadirectory>	
		<cfset caller.wireframename=lcase(wireframename)>
	</cfif>			
</cfif>