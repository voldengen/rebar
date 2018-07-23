<cfparam name="wireframename" default="">
<cfparam name="attributes.multiPartForms" default="1">

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Fusium's Rebar editing #wireframename#: #fusebox.fuseaction#</title>
	<LINK href="#fusebox.currentPath#rebar.css" rel=stylesheet type=text/css>
</head>

<body bgcolor="##FFFFFF" >
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td align="left">
<b>[</b>  <a href="index.cfm?fuseaction=rebar.newPage<cfif attributes.multiPartForm>2</cfif>">Add New Page</a>&nbsp;&nbsp;&nbsp;<a href="index.cfm?fuseaction=rebar.map">Map</a>&nbsp;&nbsp;&nbsp;<a href="index.cfm?fuseaction=rebar.admin">Admin</a>&nbsp;&nbsp;&nbsp;<a href="index.cfm?fuseaction=rebar.help&topic=page">Help</a>  <b>]</b>
	</td>
	<td align="right">
	<a href="http://www.fusium.com/go/rebar/"><img src="#fusebox.currentPath#rebar.jpg" alt="" border="0" width="70" height="36"></a>
	</td>
</tr>
</table><br>
#fusebox.layout#

<div class="disclaimer" align="center"><br>Rebar is property of Fusium, Inc. Do not redistribute modified or original copies of Rebar, alone or embedded in other applications.<a href="##" onclick="javascript:window.open('#fusebox.currentPath#credits.htm','','WIDTH=400,HEIGHT=200,scrollbars=1,resizable=yes,screenX=90,screenY=150,top=150,left=90')">Credits &amp; Thanks</a></div>
</TD></TR>
</TABLE>

</body>
</html>
</cfoutput>
