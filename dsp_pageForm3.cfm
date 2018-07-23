<cfhtmlhead text="
<script language=""JavaScript"">
function usePage(page) {
	var string;
	string = page + "" = "" + page;
	if (document.theForm.nesttoggle[0].status) {
	document.theForm.linkPages.value = document.theForm.linkPages.value + ""\n"" + string;
	document.theForm.linkPages.focus();
	}
	else {
	document.theForm.nestedPages.value = document.theForm.nestedPages.value + ""\n"" + page;
	document.theForm.nestedPages.focus();
	}
}
</script>
">

<cfset linkIndex = 100>
<cfset nestedPages="">

<cfparam name="attributes.pageName" default="title">
<cfparam name="fileforupdate" default="[#lcase(attributes.pageName)#]#chr(10)#;blurb#chr(10)#link = target">

<cfif StructKeyExists(wireframe, attributes.pageName)>
	<cfset aPage = lcase(attributes.pageName)>
</cfif> 




<div align="center">
<TABLE BORDER="0" cellpadding="0" cellspacing="0" class="border" WIDTH="80%">
<cfform action="index.cfm?fuseaction=#xfa.submit#" method="post" name="theForm">
<cfoutput>
<TR VALIGN="TOP">
<input type="hidden" name="oldtitle" value="#lcase(attributes.pageName)#">

<TD ALIGN="CENTER">

<TABLE BORDER="0" cellpadding="5" cellspacing="0" WIDTH="100%">
<TR VALIGN="TOP"><TD ALIGN="RIGHT" CLASS="pageHeader">Page Title:</TD>
<TD CLASS="pageHeader"  COLSPAN="2"><cfinput type="text" name="Title" required="Yes" message="Please enter a Page Title." value="#lcase(trim(attributes.pageName))#" size="60" tabindex="1"><cfif IsDefined("attributes.message")><br><br><span class="alert">#attributes.message#</span><br><br></cfif></TD></TR>

<TR VALIGN="TOP"><TD CLASS="pageHeader" ALIGN="RIGHT">
Page Content:
</TD><TD CLASS="pageHeader" COLSPAN="2">
	<cfif isDefined("aPage")>
		<cfset desc = "">
		<cfif ArrayLen(wireframe[aPage].description)>
			<cfloop from="1" to="#ArrayLen(wireframe[aPage].description)#" index="count">
				<cfset desc = desc & wireframe[aPage].description[count]>
			</cfloop>
		</cfif>
	<cfelse>
		<cfset desc = "Enter page description here.">
	</cfif>
	<TEXTAREA name="blurb" rows="10" cols="70"  tabindex="2">#trim(replace(desc,"#chr(13)#","","all"))#</TEXTAREA>
</TD></TR>


<!--- Links --->
<cfset linkstr = "">
<cfset nestedPages = "">
<cfif isDefined("aPage") AND ListLen(StructKeyList(wireframe[aPage].links))>
	<cfloop collection="#wireframe[aPage].links#" item="aLink">
		<cfif IsSimpleValue(wireframe[aPage].links[aLink])>
			<cfset pageExists = 1>
			<cfif not StructKeyExists(wireframe,trim(wireframe[aPage].links[aLink]))>
				<cfset pageExists = 0>
			</cfif>
			<cfif aLink neq "linking failed">
				<cfset linkstr = linkstr & "#lcase(aLink)# = #lcase(trim(wireframe[aPage].links[aLink]))##chr(13)#">
			</cfif>
		<cfelse>
			<cfset nestedPages=ListAppend(nestedPages,aLink)>
		</cfif>
	</cfloop>
</cfif>

<TR VALIGN="TOP"><TD CLASS="pageHeader" ALIGN="RIGHT">
Linked Pages:
</TD><TD CLASS="pageHeader">
<table border="0" cellspacing="5" cellpadding="5" width="100%">

<tr valign="top">
	<td>Current Linked Pages:</td>
	<td>&nbsp;&nbsp;<br></td>
</tr>

<tr valign="top">
	<td>	
	<textarea name="linkPages" rows="10" cols="50" class="formInput" tabindex="3" onfocus="document.theForm.nesttoggle[1].checked=0;document.theForm.nesttoggle[0].checked=1"><cfloop list="#linkstr#" index="aLink">#lcase(trim(aLink))##chr(13)#</cfloop></TEXTAREA>
	<BR>
	<input type="submit" value="save" tabindex="4" class="formButton">
	</td>
	<td>&nbsp;&nbsp;<br></td>
	
</tr>
</TABLE>
</TD>
<td CLASS="border" rowspan="2" valign="top">Add<br>
	<label for="linked"><input type="Radio" name="nesttoggle" value="1" id="linked" checked>Link</label>
	<label for="nested"><input type="Radio" name="nesttoggle" value="0" id="nested">Nest</label>:
	<BR>
	<cfloop collection="#wireframe#" item="aPage">
	<a href="javascript:void(0)" onclick="usePage('#lcase(aPage)#');" style="line-height : 15pt;" tabindex="#linkIndex#">#lcase(aPage)#</a><BR>
	<cfset linkIndex = linkIndex + 1>
	</cfloop>
</td>
</TR>

<TR VALIGN="TOP"><TD CLASS="pageHeader" ALIGN="RIGHT">
Nested Pages:
</TD><TD CLASS="pageHeader">
<table border="0" cellspacing="5" cellpadding="5" width="100%">
<tr valign="top">
	<td>Current Nested Pages:</td>
	<td>&nbsp;&nbsp;<br></td>
</tr>

<tr valign="top">
	<td>	
	<textarea name="nestedPages" rows="10" cols="50" class="formInput" tabindex="5" onfocus="document.theForm.nesttoggle[0].checked=0;document.theForm.nesttoggle[1].checked=1"><cfloop list="#nestedPages#" index="aLink">#lcase(trim(aLink))##chr(13)#</cfloop></TEXTAREA>
	<BR>
	<input type="submit" value="save" tabindex="6" class="formButton">
	</td>
	<td valign="bottom">&nbsp;&nbsp;<input type="Button" value="delete" onclick="window.location.href='index.cfm?fuseaction=rebar.deletePage&pageName=#lcase(attributes.pageName)#'" class="formButton"><br></td>
</tr>

</table>			
</td>
</cfoutput>

</TR></TABLE>


</TD></TR>
</TABLE></div>
</CFFORM>