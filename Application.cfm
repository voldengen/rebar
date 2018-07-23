<cfset request.self="index.cfm">

<cfif listLast(cgi.script_name,"/") neq request.self>
	<cflocation url="#request.self#" addtoken="No">
</cfif> 