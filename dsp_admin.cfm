
<div align="center">
<TABLE BORDER="0" cellpadding="0" cellspacing="0" style="border: 1pt solid Black;" WIDTH="80%">
<TR VALIGN="TOP">
	<TD ALIGN="CENTER">
	<TABLE BORDER="0" cellpadding="5" cellspacing="0" WIDTH="100%">
	
	<TR VALIGN="TOP">
		<TD ALIGN="CENTER" COLSPAN="3" CLASS="pageSubHeader"> &lt; Edit A Wireframe &gt; </TD>
	</TR>

	<!--- Edit wireframe chooser --->
	<TR>
		<TD CLASS="pageBody" align="center">
<cfif IsDefined("attributes.message")><br><span class="alert"><cfoutput>Alert: #attributes.message#</cfoutput></span><br></cfif>
<cfif IsDefined("attributes.generated")><br><span class="alert"><cfoutput>Prototype generated and all pages saved to #attributes.buildDir#.<cfif IsDefined("attributes.link")><br>Click <a href="#attributes.buildDir#" target="_blank">here</a> to view the finished prototype.</cfif></cfoutput></span><br></cfif>
		<br>
		<cfif wireframeDirs.recordcount>
		Choose a wireframe to edit below.<br><br>
			<table>									      
			<form action="index.cfm?fuseaction=rebar.setWireframeDir" method="post">
		   	<TR valign="top">
				<TD ALIGN="RIGHT">
			   	<select name="dir" class="formInput">
			   	<cfoutput query="wireframeDirs">
				<cfif wireframeDirs.name NEQ "reserved">
			   		<option value="#lcase(name)#">#lcase(name)#
			   	</cfif>
				</cfoutput>
			   	</select>&nbsp;
			   	</TD>
				<TD><input type="Submit" value="edit &raquo;" class="formButton"></TD>
		   	</TR>
			</form>
			</table>
		</cfif>
		<br>
		</TD>
	</TR>

	<TR>
		<TD CLASS="pageSubHeader" ALIGN="CENTER"> &lt; Create A Wireframe &gt; </TD>
	</TR>

	<TR VALIGN="TOP">
		<TD CLASS="pageBody" align="center"><br>
		Create a new wireframe by entering a name below.<br><br>
			<table>								      
			<form action="index.cfm?fuseaction=rebar.createWireframeDir" method="post">
			<TR valign="top">
		   		<TD ALIGN="RIGHT">Name: <input type="Text" maxlength="25" name="dir" class="formInput">&nbsp;</TD>
				<TD><input type="Submit" value="create new &raquo;" class="formButton"></TD>
			</TR>
			</form>
			</table>
		<br>
		</TD>
	</TR>

	<TR>
		<TD CLASS="pageSubHeader" ALIGN="CENTER"> &lt; Generate Prototype &gt; </TD>
	</TR>

	<TR VALIGN="TOP">
		<TD CLASS="pageBody" align="center"><br>
		<cfif wireframeDirs.recordcount>									      
		Generate a starter prototype from an existing wireframe.<br><br>
			<table>
			<form action="index.cfm?fuseaction=rebar.buildOne" method="post">
			<TR valign="top">
				<TD ALIGN="RIGHT">
				<select name="wireframeName" class="formInput">
				<cfoutput query="wireframeDirs">
					<cfif wireframeDirs.name NEQ "reserved">
				   	<option value="#lcase(name)#">#lcase(name)#
				   	</cfif>
				</cfoutput>
				</select>&nbsp;
				</TD>
				<TD><input type="Submit" value="export to HTML &raquo;" class="formButton"></TD>
			</TR>
			</form>
			</table>
			</cfif>
		<br>
		</TD>
	</TR>
	
	</TABLE>
	</TD>
</TR>
</TABLE>
</div>