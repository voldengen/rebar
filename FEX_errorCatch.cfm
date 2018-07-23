<!--- -->
<xmp>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fusedoc SYSTEM "http://fusebox.org/fd4.dtd">
<fusedoc fuse="FEX_errorCatch.cfm" language="ColdFusion" specification="2.0">
	<responsibilities></responsibilities>
	<properties>
		<history author="Nat Papovich" date="05/03/2002" email="nat@fusium.com" role="Architect" type="Create"/>
	</properties>
	<io>
		<in>
			<structure name="fusebox.cfcatch" format="CFML" Scope="variables">
				<string name="type" comments="Error type, either a ColdFusion standard error type, a custom-thrown type or 'fusebox'" />
				<number name="errorCode" comments="For type='fusebox', this value is the section in the core file where the error occured." />
				
			</structure>
		</in>
		<out>
		</out>
		<passthrough>
			<string scope="request" name="urltoken" comments="pass on all urls and form actions"/>
		</passthrough>
	</io>
</fusedoc>
</xmp>
--->

<cfswitch expression="#fusebox.cfcatch.type#">
	
	<cfcase value="fusebox">
		<cfswitch expression="#fusebox.cfcatch.errorCode#">
			<!--- Error Codes:
			5: Error in or missing fbx_circuits.cfm
			6: Invalid circuits structure or none created
			7: Missing root fbx_settings.cfm
			8: Invalid or missing Fuseaction variable
			9: An incorrect or unregistered circuit has been requested
			13: Unable to find the layoutfile specified
			 --->
			<!--- You can create your own <cfcase></cfcase> blocks here to handle individual Fusebox errors, like these examples: --->

			<cfcase value="8">
				<cfoutput>Attention! You have requested an invalidly-formatted fuseaction. The fuseaction <pre>#attributes.fuseaction#</pre> is not correct.<p><b>Core message:</b> #fusebox.cfcatch.message#<p></cfoutput>
			</cfcase>

			<cfcase value="9">
				<cfoutput>
				<strong>This message and action is modifiable via the root FEX_errorCatch.cfm.<p></strong>
				Attention! You have requested an incorrect circuit. The circuit name <pre>#fusebox.circuit#</pre> is not available.<p><b>Core message:</b> #fusebox.cfcatch.message#<p></cfoutput>
			</cfcase>

			<cfdefaultcase>
				<hr><br><table border="2"><tr><td>
				<cfoutput>
				<h3>The Fusebox framework has encountered an error</h3>
				<b>Section:</b> #fusebox.cfcatch.errorCode#<p>
				<b>Dealing with file:</b> #fusebox.cfcatch.detail#<p>
				<b>Core message:</b> #fusebox.cfcatch.message#<p>
				<cfwddx action="WDDX2CFML" input="#fusebox.cfcatch.extendedinfo#" output="thisError">
				<b>ColdFusion native error:</b><p>#thisError.detail#<p>#thisError.message#
				</cfoutput>
				</td></tr></table><br><hr>
			</cfdefaultcase>
		</cfswitch>
	</cfcase>

	<cfcase value="MissingInclude">
		<hr><br><table border="2"><tr><td>
		<cfset lastTag=arrayLen(fusebox.cfcatch.tagcontext)>
		<cfoutput>
		<b>Type:</b> #fusebox.CFCATCH.type#<p>
		<b>Message:</b> #fusebox.cfcatch.message#<p>
		<strong>Missing File Name:</strong> #fusebox.cfcatch.missingFileName#<p>
		#fusebox.cfcatch.detail# The error occurred while processing an element with a general identifier of
		(#fusebox.cfcatch.tagcontext[lastTag].ID#), occupying document position
		(#fusebox.cfcatch.tagcontext[lastTag].line#:#fusebox.cfcatch.tagcontext[lastTag].column#) in the template file 
		#fusebox.cfcatch.tagcontext[lastTag].template#.<p>
		<b>The specific sequence of files included or processed is:</b><p>
		<code>
		<cfset indent="">
		<cfloop from="1" to="#lastTag#" index="count">
			<cfif ListFind("CFINCLUDE,CFMODULE",fusebox.cfcatch.tagcontext[count].ID)>
				<cfif count is arrayLen(fusebox.cfcatch.tagcontext)>
					<strong>#indent##fusebox.cfcatch.tagcontext[count].template# #fusebox.cfcatch.tagcontext[count].ID#</strong>
				<cfelse>
					#indent##fusebox.cfcatch.tagcontext[count].template# #fusebox.cfcatch.tagcontext[count].ID#
				</cfif>
				<br><cfset indent=indent & "&nbsp;&nbsp;">
			</cfif>
		</cfloop>
		</code>		
		</cfoutput>
		</td></tr></table><br><hr>
	</cfcase>

	<cfdefaultcase>
		<hr><br><table border="2"><tr>
	<td>I am the root circuit catching an error.</td>
</tr><tr><td>
		<cfoutput>
		<hr>
		<b>Type:</b> #fusebox.CFCATCH.type#<p>
		<b>Message:</b> #fusebox.cfcatch.message#<p>
		<b>Detail:</b> <p>#fusebox.cfcatch.detail#
		</td></tr></table><br><hr>
		</cfoutput>
	</cfdefaultcase>
</cfswitch>

