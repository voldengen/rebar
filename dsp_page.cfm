<cfset fileName="#attributes.page#.wir">
<cfset pageFound=0>
<cfset nestedPages="">
<cfparam name="attributes.includeGoesTo" default="1">
<cfparam name="attributes.includeNav" default="1">

<cfoutput>
<cfloop collection="#wireframe#" item="aPage">
<cfif attributes.page is aPage><cfset pageFound=1>
<cfif attributes.includeNav>
&nbsp;&nbsp;<a href="index.cfm?fuseaction=rebar.editPage<cfif attributes.multiPartForm>2</cfif>&pageName=#lcase(aPage)#">Edit Page</a>
</cfif>
<div align="center">
<TABLE BORDER="0" cellpadding="0" cellspacing="0" style="border: 1pt solid Black;" WIDTH="80%">
<TR VALIGN="TOP"><TD ALIGN="CENTER">

<TABLE BORDER="0" cellpadding="5" cellspacing="0" WIDTH="100%">
<TR VALIGN="TOP"><TD ALIGN="CENTER" COLSPAN="3" CLASS="pageHeader">Page: #lcase(aPage)#</TD></TR>
<cfif ArrayLen(wireframe[aPage].description)>
<TR><TD CLASS="pageBody">
	<ul>
	<cfloop from="1" to="#ArrayLen(wireframe[aPage].description)#" index="count">
		<li>#wireframe[aPage].description[count]#
	</cfloop>
	</ul>
</TD></TR>
</cfif>


<TR><TD CLASS="pageSubHeader" ALIGN="CENTER">
&lt; Links &gt;
</TD></TR>
<TR VALIGN="TOP">
	<TD CLASS="pageLinks">
	<table align="center" cellspacing="5" cellpadding="5" border="0">
	<cfloop collection="#wireframe[aPage].links#" item="aLink">
		<cfif IsSimpleValue(wireframe[aPage].links[aLink])>
			<cfset pageExists = 1>
			<cfif not StructKeyExists(wireframe,trim(wireframe[aPage].links[aLink]))>
				<cfset pageExists = 0>
			</cfif>
			<cfif aLink neq "linking failed">
			<tr style="padding-top: 10px; padding-bottom: 10px;">
				<CFIF attributes.includeGoesTo>
				<td width="50%" valign="top" align="right"><a href="index.cfm?fuseaction=rebar.page&page=#lcase(trim(wireframe[aPage].links[aLink]))#">#lcase(aLink)#</a></td>
				<td nowrap valign="top">................<BR></td>
				<td width="50%" valign="top"><a href="index.cfm?fuseaction=rebar.page&page=#lcase(trim(wireframe[aPage].links[aLink]))#"<cfif not pageExists> class="altLink"</cfif>>#lcase(trim(wireframe[aPage].links[aLink]))#</a>&nbsp;<cfif not pageExists and not find('.',wireframe[aPage].links[aLink],1)>&Oslash;</cfif></td>
				<CFELSE>
					<td COLSPAN="3" valign="top" align="center"><a href="#replaceNoCase(lcase(trim(wireframe[aPage].links[aLink])),chr(32),'_','all')#.#attributes.fileExtension#">#lcase(aLink)#</a></td>
				</CFIF>
			</tr>
			</cfif>
		<cfelse>
			<cfset nestedPages=ListAppend(nestedPages,aLink)>
		</cfif>
	</cfloop>
	</table>
	</TD>
</TR>

<TR><TD CLASS="pageSubHeader2" ALIGN="CENTER">
&lt; Nested Pages &gt;
</TD></TR>
<TR><TD CLASS="pageNested">
<table align="center" cellspacing="5" cellpadding="5" width="100%">
<cfloop list="#nestedPages#" index="aLink">
	<tr>
		<td colspan="3">
			<table width="100%" border="0">
			<tr><td colspan="3" align="center">
			<CFIF attributes.includeGoesTo>
				<a href="index.cfm?fuseaction=rebar.page&page=#lcase(trim(aLink))#" class="nestedPage">#lcase(aLink)#</a>
			<cfelse>
				#lcase(aLink)#
			</CFIF>
			</td></tr>
			<cfif listlen(aLink,".") gt 1>
			<tr>
				<td colspan="3" align="center">Cannot display links from linked wireframe</td>
			</tr>
			<cfelse>
				<cfset subLinkList = "">
				<cfloop collection="#wireframe[aPage].links[aLink]#" item="subLink">
					<tr>
						<cfif IsSimpleValue(wireframe[aPage].links[aLink][subLink])>
							<cfif wireframe[aPage].links[aLink][subLink] neq "linking failed">
								<cfif left(subLink,22) neq "_wireframe_insert_page">
									<cfif attributes.includeGoesTo>
									<td width="50%" valign="top" align="right"><a href="index.cfm?fuseaction=rebar.page&page=#lcase(trim(wireframe[aPage].links[aLink][subLink]))#">#lcase(subLink)#</a></td>
									<td nowrap valign="top">..................<BR></td>
									<td width="50%" valign="top"><a href="index.cfm?fuseaction=rebar.page&page=#lcase(trim(wireframe[aPage].links[aLink][subLink]))#">#lcase(wireframe[aPage].links[aLink][subLink])#</a></td>
									<CFELSE>
									<td colspan="3" valign="top" align="center"><a href="#replaceNoCase(lcase(trim(wireframe[aPage].links[aLink][subLink])),chr(32),'_','all')#.#attributes.fileExtension#">#lcase(subLink)#</a></td>
									</CFIF>
								<cfelse>
									<cfset subLinkList = listAppend(subLinkList, trim(wireframe[aPage].links[aLink][subLink]))>
								</cfif>
							</cfif>
						</cfif>
					</tr>
				</cfloop>
				<cfif listLen(subLinkList)>
					<cfloop list="subLinkList" index="n_subLink">
 						<tr>
						<td width="50%" valign="top" align="right">subnested page:</td>
						<td nowrap valign="top">..................<BR></td>
						<td width="50%" valign="top">&Oslash;</td>
						</tr>
					</cfloop>
				</cfif>
			</cfif>
			</table>
		</td>
	</tr>
</cfloop>
</table>
<cfbreak>

</cfif>

</cfloop>
<cfif not pageFound>
<div align="center">
#lcase(attributes.page)#<br>
(empty)<br><br>
<a href="index.cfm?fuseaction=rebar.newPage<cfif attributes.multiPartForm>2</cfif>&pageName=#lcase(trim(attributes.page))#">Create this page</a>
</div>
</cfif>
</cfoutput>

</TD></TR></TABLE>


</TD></TR>
</TABLE></div>

<!--- <cfoutput>
#replacelist(file,"#chr(10)#,#chr(13)#,^","[BR],[CR],<HR>")#
</cfoutput> --->