<script language="JavaScript1.2">
function submitForm() {
	theForm.submitBtn.disabled=true;
	theForm.submit();
	alert('Large wireframes may take several seconds to generate. Please be patient.');
}
</script>

<div align="center">
<TABLE BORDER="0" cellpadding="0" cellspacing="0" style="border: 1pt solid Black;" WIDTH="80%">
<TR VALIGN="TOP">
	<TD ALIGN="CENTER">
	<TABLE BORDER="0" cellpadding="5" cellspacing="0" WIDTH="100%">
	
	<TR VALIGN="TOP">
		<TD ALIGN="CENTER" COLSPAN="3" CLASS="pageSubHeader"> &lt; Generate Prototype &gt; </TD>
	</TR>

<cfoutput>
<form action="index.cfm?fuseaction=#xfa.continue#" method="post" name="theForm">
	<TR>
		<TD CLASS="pageBody" align="left">
<br>


1. Choose which page should be the "home" page, accessible via the default page:<br>
	<select name="indexPage" class="formInput">
		<cfloop collection="#wireframe#" item="aPage">
			<option value="#lcase(aPage)#"<cfif lcase(aPage) is "home"> selected</cfif>>#lcase(aPage)#
		</cfloop>
	</select>
<br><br>

2. Enter the default filename (usually "index"):<BR>
<input type="Text" maxlength="25" size="25" name="homePageFileName" value="index" class="formInput"> (any file extension will be ignored)
<BR><BR>

3. Choose a file extension of exported files:<BR>
<input type="Text" maxlength="25" size="10" name="exportFileExtension" value="htm" class="formInput"> 
<BR><BR>

4. Enter the directory in which to deploy the prototype, relative to the server:<br>
<input type="text" size="75" value="#GetDirectoryFromPath(GetCurrentTemplatePath())##lcase(wireframename)##platformSlash#html#platformSlash#" name="directory" class="formInput">
<br><br>

5. Choose a layout file to use for this prototype:<br>
<select name="layoutFile" class="formInput">
	<cfloop query="layoutFiles">
		<option value="#name#">#name#
	</cfloop>
</select>
<br><br>

<input type="Submit" value="generate &raquo;" onclick="submitForm()" name="submitBtn" class="formInput">



<br><br>
</TD>
	</TR>
	</form>
	</cfoutput>
	</TABLE>
	</TD>
</TR>
</TABLE>
</div>
