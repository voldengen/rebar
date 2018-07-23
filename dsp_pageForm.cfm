
<cfparam name="attributes.pageName" default="title">
<cfparam name="fileforupdate" default="[#lcase(attributes.pageName)#]#chr(10)#;blurb#chr(10)#link = target">
<cfoutput>
<script language="JavaScript">
function usePage(page) {
	var string;
	string = page + " = " + page;
	document.theForm.pageData.value = document.theForm.pageData.value + "\n" + string;
	document.theForm.pageData.focus();
}
</script>
<table align="center">
<tr>
	<td valign="top">
<form action="index.cfm?fuseaction=#xfa.submit#" method="post" name="theForm">
<input type="hidden" name="oldtitle" value="#lcase(attributes.pageName)#">
<textarea name="pageData" cols="70" rows="20">#fileforupdate#</textarea><br>
<input type="Submit" value="Save">
<input type="button" value="Cancel" onclick="javascript:history.back();">
</form>
	</td><td>&nbsp;&nbsp;</td>
	<td valign="top">
	<table border="0" cellspacing="0" cellpadding="5" style="border: 1pt solid Black;">
	<tr><td class="alt2">
	Available Pages:<BR>
	</td></tr>
	<tr><td>
<cfloop collection="#wireframe#" item="aPage">
<a href="javascript:void(0)" onclick="usePage('#lcase(aPage)#');" style="line-height : 18pt;">#lcase(aPage)#</a><br>
</cfloop>
	</td></tr>
	</table>
	</td>
</tr>
</table>
</cfoutput>
