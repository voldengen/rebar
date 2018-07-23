<cfset badchars="\,/,:,*,?,|,#chr(34)#,#chr(44)#,#chr(60)#,#chr(62)#,#chr(32)#">

<cfif refind("^[[::alnum:]]",attributes.dir) OR not len(trim(attributes.dir))>
	<cflocation url="index.cfm?fuseaction=rebar.admin&message=Wireframe names can only contain letters and numbers." addtoken="No">
<cfelse>
	<cfdirectory action="CREATE" directory="#GetDirectoryFromPath(GetCurrentTemplatePath())##lcase(trim(attributes.dir))#">
</cfif>

