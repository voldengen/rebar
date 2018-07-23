<cfoutput>
<table width="80%" border="0" cellspacing="0" cellpadding="2" align="center" style="border: 1pt solid Black;">
<tr>
	<td class="pageHeader">Page Title</td>
	<td class="pageHeader">&nbsp;&nbsp;&nbsp;<br></td>
	<td class="pageHeader" width="30%">Description First Line</td>
	<td class="pageHeader">&nbsp;&nbsp;&nbsp;<br></td>
	<td class="pageHeader">Links</td>
</tr>

<cfset i = 1>
<cfloop collection="#wireframe#" item="aPage">
<cfset i = i + 1>
<cfset nestedPages="">
<tr class="alt<cfif i MOD 2>2<cfelse>1</cfif>"><td colspan="5">&nbsp;<br></td></tr>
<tr class="alt<cfif i MOD 2>2<cfelse>1</cfif>" valign="top">
	<td valign="top"><a href="index.cfm?fuseaction=rebar.page&page=#lcase(aPage)#"><strong>#lcase(aPage)#</strong></a><br><br><a href="index.cfm?fuseaction=rebar.editPage<cfif attributes.multiPartForm>2</cfif>&pageName=#lcase(aPage)#" class="altLink">Edit Page</a></td>
	<td>&nbsp;&nbsp;&nbsp;<br></td>
	<td valign="top"><cfif ArrayLen(wireframe[aPage].description)>#wireframe[aPage].description[1]#</cfif></td>
	<td>&nbsp;&nbsp;&nbsp;<br></td>
	<td>
		<table width="100%">
		<cfif ListLen(StructKeyList(wireframe[aPage].links))>
			<cfloop collection="#wireframe[aPage].links#" item="aLink">
			<tr>
				<cfif IsSimpleValue(wireframe[aPage].links[aLink])>
					<cfif aLink is "linking failed">
						<td colspan="3" align="center">LINKING FAILED</td>
					<cfelse>
						<td width="50%" valign="top" align="right"><a href="index.cfm?fuseaction=rebar.page&page=#lcase(trim(wireframe[aPage].links[aLink]))#">#lcase(aLink)#</a></td>
						<td nowrap valign="top">..............</td>
						<td width="50%" valign="top" align="left"><a href="index.cfm?fuseaction=rebar.page&page=#lcase(trim(wireframe[aPage].links[aLink]))#">#lcase(trim(wireframe[aPage].links[aLink]))#</a><cfif not StructKeyExists(wireframe,trim(wireframe[aPage].links[aLink]))> (undefined)</cfif></td>
					</cfif>
				<cfelse>
					<cfset nestedPages=ListAppend(nestedPages,aLink)>
				</cfif>
			</tr>
			</cfloop>
		<cfelse>
			<tr></tr><td>&nbsp;<br></td></tr>
		</cfif>
		<cfloop list="#nestedPages#" index="page">
		<tr>
			<td colspan="3">
			<table width="100%">
			<tr><td><i>Nested Page:</i> #lcase(page)#</td></tr>
			</table>
			</td>
		</tr>
		</cfloop>
		</table>
	</td>
</tr>
<tr class="alt<cfif i MOD 2>2<cfelse>1</cfif>"><td colspan="5">&nbsp;<br></td></tr>
</cfloop>
</table>
</cfoutput>

