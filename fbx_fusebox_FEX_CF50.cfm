<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cftry>
<!------------------------------------------------------------------------------------------
Although it appears that this file is absurdly large to be run on every page request, approxiamtely 132 lines are comments and approximately 221 lines are devoted to error handling and rarely get run because they are wrapped in <cfif></cfif>.
This file is broken into sixteen sections. 
Section 1 is the Fusedoc for the file.
Section 2 contains the public "API-style" variables that are used in the Fusebox framework.
Section 3 established the private structure "fb_".
Section 4 is the former formURL2attributes Custom Tag.
Section 5 includes the fbx_circuits.cfm file.
Section 6 creates a mirror of the fusebox.circuits structure for reverse look-ups.
Section 7 includes the root fbx_settings.cfm file.
Section 8 massages attributes.fuseaction and begins the aliased lookup process.
Section 9 attempts to create the path to the root fbx_settings.cfm.
Section 10 includes nested fbx_settings.cfm files top-to-bottom.
Section 11 handles errors thrown during the process of including the fbx_settings.cfm files in section nine.
Section 12 includes the target circuit fbx_switch file, which processes the requested fuseaction.
Section 13 is a sub-section of section eleven above. It processes FEX_errorCatch.cfm.
Section 14 includes fbx_layouts.cfm and layoutFiles, in bottom-to-top order to allow layouts to be nested. 
Section 15 handles errors thrown during the process of including the fbx_layouts.cfm and layoutFiles in section thirteen.
Section 16 performs the catching for the core errors. It also outputs the final display of the page.
------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------
SECTION 1
For more information about Fusedocs and how to read them, visit fusebox.org and halhelms.com. The ending HTML comment after the opening CFML comment prevents CFStudio from comment-coloring the Fusedoc. It has no effect on ColdFusion's rendering of the comments section.
------------------------------------------------------------------------------------------->
<!--- -->
<fusedoc fuse="fbx_fusebox_FEX_CF50.cfm" specification="2.0">
	<responsibilities>
		FROM THE ORIGINAL CORE FILE:
		****************************
		I am the code behind Fusebox 3.0 that handles nesting, layouts - oh, a bunch of stuff, really. PLEASE BE VERY CAREFUL ABOUT MAKING ANY CHANGES TO THIS FILE, AS IT WILL RENDER IT NON-COMPLIANT WITH THE STANDARD NOTED ABOVE. There is no need to modify this file for any settings. All settings can occur in fbx_settings.cfm.	Because this file requires a tag introduced in CF5 (cfsavecontent), it can only be run on CF5+.
		****************************

		This core file (fbx_fusebox_FEX_CF50.cfm) is released by Fusium, as an extension to the existing Fusebox 3.0 API and framework. Although it contains a few bug fixes, its main benefit is FEX Integrated Error Handling. Please see the accompanying FEX whitepaper available from http://fusium.com/go/fex/.
		
	</responsibilities>
	<properties>
		<property name="version" value="1.0" />
		<property name="build" value="3b" />
		<history author="John Quarto-vonTivadar" date="27 Sep 2001" email="jcq@mindspring.com"></history>
		<history author="Nat Papovich" date="Oct 2001" email="mcnattyp@yahoo.com" type="Update">Converted to cfscripting, bug fixes for final release.</history>
		<history author="Nat Papovich" date="Nov 2001" email="mcnattyp@yahoo.com" type="Update" />
		<history author="Nat Papovich" date="Jan-May 2002" email="nat@fusium.com" type="Update">Added integrated error handling.</history>
		<history author="Nat Papovich" date="May 12 2002" email="nat@fusium.com" type="Update" />
		<note>Portions of code contributed by Hal Helms, Patrick McElhaney, Steve Nelson, Nat Papovich, Jeff Peters, John Quarto-vonTivadar, Gabe Roffman, Fred Sanders, Bill Wheatley, John Beynon, Bert Dawson and Stan Cox.</note>
	</properties>
	<io>
		<out>
			<structure name="fusebox" scope="variables" comments="this is the public API of variables that should be treated as read-only">
				<boolean name="isCustomTag" default="FALSE" />
				<boolean name="isHomeCircuit" default="FALSE" />
				<boolean name="isTargetCircuit" default="FALSE" />
				<string name="fuseaction" />
				<string name="circuit" />
				<string name="homeCircuit" />
				<string name="targetCircuit" />
				<string name="thisCircuit" />
				<string name="thisLayoutPath" />
				<boolean name="suppressErrors" default="FALSE" />
				<boolean name="useErrorCatch" default="FALSE" />
				<boolean name="rethrowError" default="TRUE" />
				<structure name="circuits" />
				<string name="currentPath" />
				<string name="rootPath" />
				<structure name="cfcatch" />
				<string name="defaultFuseactionString" />
			</structure>
			<structure name="FB_" comments="Internal use only. Please treat the FB_ as a reserved structure, not to be touched." />
		</out>
	</io>
</fusedoc> 
--->
<cfscript>
/*******************************************************************************************
SECTION 2
The fusebox structure below is a structure encompassing the public Fusebox API. We recommend making no changes to this structure (unless otherwise noted) as it will render your application non-compliant to the Fusebox 3.0 standard.
	fusebox.isCustomTag:
The boolean variable is set by the Fusebox framework which will automatically determine if it is being called as a custom tag. Currently, Fusebox offers no expanded support for applications being called as Custom Tags. But you can programatically alter your application if it's being called as Custom Tag by checking the value of this variable. This can be helpful for changing (or removing altogether) layout files in fbx_layouts.cfm.
	fusebox.isHomeCircuit:
This boolean variable is set and re-set as the Fusebox framework does its business pulling in fbx_settings.cfm files and the fbx_switch.cfm file and fbx_layouts.cfm files (and associated layout files). It is TRUE only when the currently accessed circuit is the home circuit running this application.
	fusebox.isTargetCircuit:
Like isHomeCircuit above, this boolean variable is used during the process of cfincluding files. It is TRUE only when the currently accessed circuit is the target circuit running specified by circuit.fuseaction.
	fusebox.circuit:
This is the first part of the compound fuseaction that gets passed as attributes.fuseaction.
	fusebox.fuseaction:
This is the second part of a compound fuseaction that gets passed as attributes.fuseaction. fusebox.fuseaction is the variable expression evaluated in fbx_switch.cfm.
	fusebox.homeCircuit:
This variable is set to the root-level circuit as defined in fusebox.circuits strucure.
	fusebox.targetCircuit:
This is the circuit the requested fuseaction is to run in. The difference between this variable and fusebox.circuit above, is that this variable is the circuit alias that was found in the fusebox.circuits file as opposed to the circuit that is being attempted to be found. In all non-error situations fusebox.TargetCircuit and fusebox.Circuit will be the same.
	fusebox.thisCircuit:
Like IsTargetCircuit and IsHomeCircuit above, this variable is set and re-set during the process of running the fbx_settings.cfm files and the fbx_switch.cfm file, and refers to the circuit alias of the circuit from which files are currently being accessed.
	fusebox.thisLayoutPath:
This is the directory path that the layout file being used is called from. This variable changes as the layouts are nested one inside another, building the overall page layout.
	fusebox.circuits:
This variable is a structure whose aliases are the circuit names created in fbx_circuits.cfm and whose values are the directory paths to those circuits.
	fusebox.currentPath:
This variable takes you from the root circuit to any location it is called. If you use images in directories beneath individual circuits, this variable will point to that circuit like "directory/directory/".
	fusebox.rootPath:
This variable takes you from the circuit it is being called from, back to the root. This is helpful to determine your location relative to the root application.
	fusebox.suppressErrors:
A boolean variable, which defaults to FALSE. If TRUE, the Fusebox framework will attempt to give you "smarter" errors that may occur from within its own code as it applies to the Framework itself. If FALSE (default), you will receive the native CF error messages. During development you may want to turn this to TRUE and FALSE alternately to ensure you've got your framework set up properly. Set this to TRUE in a production enviroment, since at that point errors that occur will not be Fusebox framework errors but rather errors in your fuseactions and fuses. If you mark "fusebox.useErrorCatch" to TRUE, then this variable is ignored and all errors created by the core are handled by the root FEX_errorCatch.cfm.
	fusebox.useErrorCatch:
Available only in Fusium's FEX core, this variable enables the use of nested FEX_errorCatch.cfm files, which allows developers to perform custom error throws and catches in conjunction with the core, along with custom handling errors throw by the Fusebox core. If this variable is set to TRUE, the FEX core ignores the variable "fusebox.suppressErrors" and instead throws all errors to the FEX_errorCatch.cfm in the target circuit.
	fusebox.rethrowError:
This variable works in tandem with the FEX Integrated Error Handling. If fusebox.useErrorCatch.cfm is set to TRUE, any errors caught in a circuit are available to be processed in the FEX_errorCatch.cfm file for that circuit. If fusebox.rethrowError is set to TRUE in the FEX_errorCatch.cfm file, then the same error is available to the parent circuit. Errors can be rethrown by children all the way back to the root by setting this variable to TRUE in each FEX_errorCatch.cfm.
	fusebox.cfcatch:
This variable is a structure mirroring the value of the ColdFusion native "cfcatch" reserved structure. By copying the values, we can write to this structure, which is something that ColdFusion does not allow. This structure should be referenced in FEX_errorCatch.cfm, not "cfcatch". The keys in this structure are as follows:
		- fusebox.cfcatch.type: "fusebox" or whatever type is throw
		- fusebox.cfcatch.errorcode: If type is "fusebox", errorcode identifies the section of the core file where the error occured. Otherwise, it is a copy of the errorcode produced by the original error.
		- fusebox.cfcatch.detail: If type is "fusebox", detail usually contains the name of the file where the error occured, if possible. Otherwise, it is a copy of the detail produced by the original error.
		- fusebox.cfcatch.message: If type is "fusebox", message is an error created by the core designed to help pinpoint the error. Otherwise, it is a copy of the message produced by the original error.
		- fusebox.cfcatch.extendedinfo: If type is "fusebox", extendedinfo may contain the original wddx-encoded cfcatch structure. Otherwise, it is a copy of the extendedinfo produced by the original error, if any.
	fusebox.defaultFuseactionString:
This variable contains the string that the core file will set fusebox.fuseaction to if no fuseaction is specified. This variable defaults to "fusebox.defaultfuseaction". This an extended API variable, available only in this FEX core.
*******************************************************************************************/
fusebox = structNew();
if (findNoCase("cf_", "," & getBaseTagList()))
	fusebox.isCustomTag=TRUE;
else fusebox.isCustomTag=FALSE;
fusebox.isHomeCircuit=FALSE;
fusebox.isTargetCircuit=FALSE;
fusebox.fuseaction="";
fusebox.circuit="";
fusebox.homeCircuit="";
fusebox.targetCircuit="";
fusebox.thisCircuit="";
fusebox.thislayoutpath="";
fusebox.suppressErrors=FALSE;
fusebox.circuits=structNew();
fusebox.currentPath="";
fusebox.rootPath="";

//These are the new FEX-based API extensions...
fusebox.useErrorCatch=TRUE;
fusebox.rethrowError=TRUE; //used to "prime" the error catching so target circuit catching runs
fusebox.cfcatch=structNew();
fusebox.defaultFuseactionString="fusebox.defaultFuseaction";

/*******************************************************************************************
SECTION 3
FB_ is a structure encompassing "private" variables used by the underlying Fusebox framework. Make no changes to it without a full understanding of the ramifications of those changes. 
*******************************************************************************************/
FB_=structNew();

/*******************************************************************************************
SECTION 4
This code used to be in a Custom Tag called formURL2attributes.cfm. It copies all incoming FORM and URL variables to ATTRIBUTES scope.
*******************************************************************************************/
if (NOT fusebox.isCustomTag) {
	if (NOT isDefined("attributes")) {
	    attributes=structNew();
	}//end if
	structAppend(attributes, url, "no");
	structAppend(attributes, form, "no");
}//end if
</cfscript>

<!------------------------------------------------------------------------------------------
SECTION 5
Attempt to include the root fbx_circuits.cfm file, which should be in the same directory as this file.
------------------------------------------------------------------------------------------->
<cftry>
	<cfinclude template="fbx_circuits.cfm"> 
	<!--- Note that requesting the core to suppress errors will only suppress ColdFusion's native error, not all errors encountered in this section. In this section, errors of any type are serious errors, requiring the Fusebox framework to halt processing. --->
	<cfcatch type="MissingInclude">
		<cfif fusebox.useErrorCatch>
			<cfwddx action="CFML2WDDX" input="#cfcatch#" output="FB_.cfcatch">
			<cfthrow type="fusebox" errorcode="5" detail="#GetFileFromPath(GetCurrentTemplatePath())#" message="The Fusebox core file encountered an error in the file <pre>fbx_circuits.cfm</pre><p>If you think this error is incorrect, turn off the Fusebox error catch flag and suppress error messages flag by setting fusebox.useErrorCatch to FALSE and fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's ""normal"" error output." extendedinfo="#FB_.cfcatch#">
		<cfelse>
			<cfoutput>The Fusebox core file encountered an error. It was unable to find the file <pre>fbx_circuits.cfm</pre> If you think this error is incorrect, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.</cfoutput><cfif not fusebox.suppressErrors><cfrethrow></cfif>
		</cfif>
	</cfcatch>
	<cfcatch type="Any">
		<cfif fusebox.useErrorCatch>
			<cfrethrow>
		<cfelse>
			<cfoutput>The Fusebox core file encountered an error in the file <pre>fbx_circuits.cfm</pre><p>If you think this error is incorrect, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.</cfoutput><cfif not fusebox.suppressErrors><cfrethrow></cfif>
		</cfif>
	</cfcatch>
</cftry>

<!------------------------------------------------------------------------------------------
SECTION 6
Create a reverse path look-up of the fusebox.Circuits structure which can be used later to conveniently look up the circuit alias of whichever circuit is being accessed at that moment, particularly when determining fusebox.thisCircuit. This structure is used in later sections.
------------------------------------------------------------------------------------------->
<cftry>
	<cfif structIsEmpty(fusebox.circuits)><cfthrow></cfif>
	<cfscript>
	FB_.reverseCircuitPath=structNew();
	for (aCircuitName in fusebox.circuits){
		FB_.reverseCircuitPath[fusebox.circuits[aCircuitName]]=aCircuitName;
		if (listLen(fusebox.circuits[aCircuitName], "/") EQ 1){
			fusebox.homeCircuit=aCircuitName;
			fusebox.isHomeCircuit=TRUE;
		}//end if
	}//end for
	</cfscript>
	<cfcatch>
		<cfif fusebox.useErrorCatch>
			<cfscript>
			FB_.temp=structNew();
			FB_.temp.type="N/A";
			FB_.temp.message="N/A";
			FB_.temp.detail="N/A";
			FB_.temp.tagContext=ArrayNew(1);
			</cfscript>
			<cfwddx action="CFML2WDDX" input="#FB_.temp#" output="FB_.cfcatch">
			<cfthrow type="fusebox" errorcode="6" detail="#GetFileFromPath(GetCurrentTemplatePath())#" message="The Fusebox core file encountered an error. The circuits structure does not exist or there has been an error processing it.<p>The most likely cause of this error is that the circuits structure has not been created. It must be defined in the Fusebox application's root fbx_circuits.cfm file.<p>A sample fusebox circuits structure takes the following form <pre>&lt;!--- fbx_circuits.cfm ---&gt;#chr(10)#&lt;cfset fusebox.circuits.home=""home""&gt;#chr(10)#&lt;cfset fusebox.circuits.child=""home/child""&gt;#chr(10)#...</pre>If you think this error is incorrect, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's ""normal"" error output." extendedinfo="#FB_.cfcatch#">
		<cfelse>
			<cfoutput>The Fusebox core file encountered an error. The circuits structure does not exist or there has been an error processing it.<p>The most likely cause of this error is that the circuits structure has not been created. It must be defined in the Fusebox application's root fbx_circuits.cfm file.<p>A sample fusebox circuits structure takes the following form <pre>&lt;!--- fbx_circuits.cfm ---&gt; 
&lt;cfset fusebox.circuits.home="home"&gt;
&lt;cfset fusebox.circuits.child="home/child"&gt;
...</pre>If you think this error is incorrect, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.</cfoutput><cfif not fusebox.suppressErrors><cfrethrow></cfif>
		</cfif>
	</cfcatch>
</cftry>

<!------------------------------------------------------------------------------------------
SECTION 7
Attempt to include the fbx_settings.cfm file from the root directory, the same directory that this file is being run from.
------------------------------------------------------------------------------------------->
<cftry>
	<cfoutput><cfinclude template="fbx_settings.cfm"></cfoutput>
	<cfcatch type="MissingInclude">
		<cfif fusebox.useErrorCatch>
			<cfwddx action="CFML2WDDX" input="#cfcatch#" output="FB_.cfcatch">
			<cfif cfcatch.missingfilename is "fbx_settings.cfm">
				<cfthrow type="fusebox" errorcode="7" detail="#GetFileFromPath(GetCurrentTemplatePath())#" message="The Fusebox core file encountered an error. It could not find the root fbx_settings.cfm file OR a file included from there. If you think this error is incorrect, turn off the Fusebox error catch flag and suppress error messages flag by setting fusebox.useErrorCatch to FALSE and fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's ""normal"" error output." extendedinfo="#FB_.cfcatch#">
			<cfelse>
				<cfthrow type="fusebox" errorcode="7" detail="#GetDirectoryFromPath(GetCurrentTemplatePath())#FBX_SETTINGS.CFM" message="The Fusebox core file encountered an error. It could not find the file <pre>#cfcatch.missingfileName#</pre> from the root fbx_settngs.cfm. If you think this error is incorrect, turn off the Fusebox error catch flag and suppress error messages flag by setting fusebox.useErrorCatch to FALSE and fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's ""normal"" error output." extendedinfo="#FB_.cfcatch#">
			</cfif>
		<cfelse>
			<cfoutput>The Fusebox core file encountered an error. It could not find the file fbx_settings.cfm. If you think this error is incorrect, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.</cfoutput><cfif not fusebox.suppressErrors><cfrethrow></cfif>
		</cfif>
	</cfcatch>
	<cfcatch type="Any">
		<cfif fusebox.useErrorCatch>
			<cfrethrow>
		<cfelse>
			<cfoutput>The Fusebox core file encountered an error in the root fbx_settings.cfm file. If you think this error is incorrect, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.</cfoutput><cfif not fusebox.suppressErrors><cfrethrow></cfif>
		</cfif>
	</cfcatch>
</cftry>

<!------------------------------------------------------------------------------------------
SECTION 8
Dissect attributes.fuseaction (available in the attributes scope either from being converted in the formURL2attributes section or via the above included fbx_settings.cfm file in the root directory). If attributes.fuseaction is not a compound fuseaction (i.e. it only includes the circuit in the form of "?fuseaction=circuit."), then set the fuseaction as the string declared above (defaulted to "fusebox.defaultFuseaction", which the target circuit's CFDEFAULTCASE tag will pick up. Now look up the target circuit in the fusebox.circuit structure for the full path to the circuit.
------------------------------------------------------------------------------------------->
<cftry>
	<cfscript>
	FB_.rawFA = attributes.fuseaction; //preserve the original fuseaction
	if (listLen(FB_.rawFA, '.') is 1 and right(FB_.rawFA,1) is '.')
		//circuit only specified, no fuseaction such as "fuseaction=circuit."
		//special! You can declare your own defaultfuseaction string by modifying the core file setting the var "fusebox.defaultFuseactionString"
		fusebox.fuseaction=fusebox.defaultFuseactionString;
	else
		//circuit.fuseaction specified, so set fusebox.fuseaction and fusebox.circuit to matching values
		fusebox.fuseaction=listGetAt(FB_.rawFA,2,'.');
	fusebox.circuit=listGetAt(FB_.rawFA,1,'.');
	fusebox.targetCircuit=fusebox.circuit; //preserve for later
	</cfscript>
	<cfcatch>
		<cfif fusebox.useErrorCatch>
			<cfwddx action="CFML2WDDX" input="#cfcatch#" output="FB_.cfcatch">		
			<cfthrow type="fusebox" errorcode="8" detail="#GetFileFromPath(GetCurrentTemplatePath())#" message="The Fusebox core file encountered an error. The variable <pre>attributes.fuseaction</pre> is not defined or is defined incorrectly. It should be in the form <pre>circuit.fuseaction</pre> where ""circuit"" is the name of the target circuit and ""fuseaction"" is the fuseaction to proces in that target circuit. The most likely cause of this error is that attributes.fuseaction is not available. attributes.fuseaction can be set as a form, url, or attributes variable and should be defaulted via <cfparam> in the root fbx_settings.cfm file.<p>If you think this error is incorrect, turn off the Fusebox error catch flag and suppress error messages flag by setting fusebox.useErrorCatch to FALSE and fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's ""normal"" error output." extendedinfo="#FB_.cfcatch#">
		<cfelse>
			<cfoutput>The Fusebox core file encountered an error. The variable <pre>attributes.fuseaction</pre> is not defined or is defined incorrectly. It should be in the form <pre>circuit.fuseaction</pre> where "circuit" is the name of the target circuit and "fuseaction" is the fuseaction to proces in that target circuit. The most likely cause of this error is that attributes.fuseaction is not available. attributes.fuseaction can be set as a form, url, or attributes variable and should be defaulted via &lt;cfparam&gt; in the root fbx_settings.cfm file.<p>If you think this error is incorrect, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.</cfoutput><cfif not fusebox.suppressErrors><cfrethrow></cfif><cfabort>
		</cfif>
	</cfcatch>
</cftry>

<!------------------------------------------------------------------------------------------
SECTION 9
Attempt to create the path to the root fbx_settings.cfm.
------------------------------------------------------------------------------------------->
<cftry>
	<cfscript>
	FB_.fullPath=listRest(fusebox.circuits[fusebox.targetCircuit], "/"); //make a variable to hold the full path down to the target, excluding the root
	FB_.Corepath=""; //initialize
	fusebox.thisCircuit=fusebox.HomeCircuit; //current circuit, set to root now
	</cfscript>
	<cfcatch type="Any">
		<cfif fusebox.useErrorCatch>
			<cfwddx action="CFML2WDDX" input="#cfcatch#" output="FB_.cfcatch">			
			<cfthrow type="fusebox" errorcode="9" detail="#GetFileFromPath(GetCurrentTemplatePath())#" message="The Fusebox core file encountered an error. The circuit <pre>#fusebox.targetCircuit#</pre> is not defined or is defined incorrectly. It should be set in the fbx_circuits.cfm file in the form <pre>&lt;cfset fusebox.circuits.baby=""pathToBaby""&gt;</pre> where ""pathToBaby"" is the path, from the root circuit to that circuit, like ""home/child""<p>If you think this error is incorrect, turn off the Fusebox error catch flag and suppress error messages flag by setting fusebox.useErrorCatch to FALSE and fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's ""normal"" error output." extendedinfo="#FB_.cfcatch#">
		<cfelse>
			<cfoutput>The Fusebox core file encountered an error. The circuit <pre>#fusebox.targetCircuit#</pre> is not defined or is defined incorrectly. It should be set in the fbx_circuits.cfm file in the form <pre>&lt;cfset fusebox.circuits.baby="pathToBaby"&gt;</pre> where "pathToBaby" is the path, from the root circuit to that circuit, like "home/child/baby"<p>If you think this error is incorrect, turn off the Fusebox error catch flag and suppress error messages flag by setting fusebox.useErrorCatch to FALSE and fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.</cfoutput><cfif not fusebox.suppressErrors><cfrethrow></cfif><cfabort>
		</cfif>
	</cfcatch>
</cftry>

<!------------------------------------------------------------------------------------------
SECTION 10
Attempt to include any nested fbx_Settings.cfm files, in top-to-bottom order so that variables set in children fbx_settings.cfm files can overwrite variables set in higher fbx_settings.cfm files. To prevent children fbx_settings.cfm files from overwriting variables, use CFPARAM rather than CFSET. Alternately, any child fbx_settings.cfm can CFSET a variable and lower fbx_settings.cfm files cannot overwrite it unless they use CFSET. If any fbx_settings.cfm file or directory alias cannot be found, continue on.
------------------------------------------------------------------------------------------->
<cfloop list="#FB_.fullpath#" index="aPath" delimiters="/">
	<cfscript>
	FB_.corePath=listAppend(FB_.corePath, aPath, "/"); //add the current circuit with / as delim
	fusebox.isHomeCircuit=FALSE; //fbx_settings.cfm files included in this loop are not the home circuit because the home circuit's fbx_Settings is needed much earlier in the process
	fusebox.currentPath=FB_.corePath & "/";
	fusebox.rootPath=repeatString("../", listLen(fusebox.currentPath, '/'));
	</cfscript>
	<cftry>
		<cfif structKeyExists(FB_.reverseCircuitPath, fusebox.circuits[fusebox.homeCircuit] & "/" & FB_.corePath)>
			<cfset fusebox.thisCircuit=FB_.reverseCircuitPath[fusebox.circuits[fusebox.homeCircuit] & "/" & FB_.corePath]> 
			<cfif fusebox.thisCircuit EQ fusebox.targetCircuit>
				<cfset fusebox.isTargetCircuit=TRUE>
			<cfelse>
				<cfset fusebox.isTargetCircuit=FALSE>
			</cfif>
			<cfoutput><cfinclude template="#fusebox.currentPath#fbx_settings.cfm"></cfoutput><!---include the actual file--->
		</cfif>
		<cfcatch type="MissingInclude"><!--- suppressed error: children fbx_settings not required ---></cfcatch>		

<!------------------------------------------------------------------------------------------
SECTION 11
This code is run inside a <cftry> tag. Catch any and all errors that are thrown by any fbx_settings.cfm or any fuse included from the fbx_settings.cfm. You can still have individual fuses try, throw and catch their own errors without being caught again in this section. This is only for unexpected errors or custom throw errors. The FEX_errorCatch.cfm file is a <cfswitch expression="#fusebox.cfcatch.type#"></cfswitch> where you can make custom handlers for any error type. This functionality can include "bubbling" in that errors that are thrown by a child can be caught by the child and by the parent, if desired. To rethrow an error from a child FEX_errorCatch.cfm to a parent FEX_errorCatch.cfm, set the variable "fusebox.rethrowError" to TRUE in the child FEX_errorCatch.cfm. If the fusebox.useErrorCatch flag is set to FALSE, then this whole section gets skipped, for backwards compatability and to allow applications to skip this functionality if they don't want it.
------------------------------------------------------------------------------------------->
	 	<cfcatch type="Any">
			<cftry>
	 		<cfif fusebox.useErrorCatch>
				<cfscript>
				fusebox.cfcatch=cfcatch; 
				fusebox.rethrowError=TRUE; //prime the catching
				FB_.circuitAlias=fusebox.circuits[fusebox.thisCircuit];
				FB_.errorPath=fusebox.circuits[fusebox.thisCircuit];
				</cfscript>
				<cfloop condition="len(FB_.errorPath) GT 0"> <!--- as long as error path has more circuits --->
					<cfif fusebox.rethrowError>
						<cfif StructKeyExists(FB_.reverseCircuitPath, FB_.circuitAlias)>
							<cftry>
								<cfset fusebox.thisCircuit = FB_.reverseCircuitPath[FB_.circuitAlias]>
								<cfcatch>
									<cfset fusebox.thisCircuit="">
								</cfcatch>
							</cftry>
							<cfscript>
							fusebox.rethrowError=FALSE;
							if (fusebox.thisCircuit EQ fusebox.targetcircuit) fusebox.isTargetCircuit=TRUE;
								else fusebox.isTargetCircuit=FALSE;
							if (fusebox.thisCircuit EQ fusebox.homeCircuit)	fusebox.isHomeCircuit=TRUE;
								else fusebox.isHomeCircuit=FALSE;
							fusebox.currentPath=listRest(FB_.errorPath,"/");
							if (len(fusebox.currentPath)) fusebox.currentPath=fusebox.currentPath & "/";
							fusebox.rootPath=repeatString("../", listLen(fusebox.currentPath, '/'));
							</cfscript>
							<cftry>
							<cfoutput><cfinclude template="#fusebox.currentPath#FEX_errorCatch.cfm"></cfoutput>
							<cfcatch type="MissingInclude">
								<cfset fusebox.rethrowError=TRUE></cfcatch>
							<cfcatch type="Any">
								<cfset fusebox.cfcatch=cfcatch><cfset fusebox.rethrowError=TRUE></cfcatch>
							</cftry>
						</cfif>
					<cfelse>
						<cfbreak>
					</cfif>
					<cfset FB_.errorPath=listDeleteAt(FB_.errorPath,listLen(FB_.errorPath,"/"),"/")>
					<cfset FB_.circuitAlias=listDeleteAt(FB_.circuitAlias,listLen(FB_.circuitAlias,"/"),"/")>
				</cfloop>
			<cfelse>
				<cfoutput>
				<hr>The Fusebox core file encountered an error. There is an error in the file
	<pre>#fusebox.currentPath#fbx_settings.cfm</pre> in the the circuit <pre>#fusebox.thisCircuit#</pre> or in a file included from that fbx_settings.cfm.<p>If you think this error is incorrect or would like more information, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.<cfif not fusebox.suppressErrors><cfrethrow></cfif></cfoutput><cfabort>
			</cfif>
			<cfcatch type="Any"><cfrethrow><cfabort></cfcatch>
			</cftry>
		</cfcatch>
	</cftry>
</cfloop>

<!------------------------------------------------------------------------------------------
SECTION 12
Now "reach down" and include the fbx_switch.cfm in the target circuit, executing fusebox.fuseaction. Store the contents of the output into a variable called fusebox.layout.
------------------------------------------------------------------------------------------->
<cfscript>
fusebox.thisCircuit=fusebox.targetCircuit;
fusebox.isTargetCircuit= TRUE;
FB_.fuseboxPath=FB_.fullPath; //make directory path to the target circuit
if (len(FB_.fuseboxPath)){
	//if the target circuit is NOT the root circuit
	FB_.fuseboxPath=FB_.fuseboxPath & "/";
	fusebox.isHomeCircuit = FALSE;}
else
	fusebox.isHomeCircuit = TRUE;
fusebox.currentPath=FB_.fuseboxPath;
fusebox.rootPath=repeatString("../", listLen(FB_.fuseboxPath, '/'));
</cfscript>

<cfsavecontent variable="fusebox.layout">
<cftry>
	<cfoutput><cfinclude template="#FB_.fuseboxPath#fbx_switch.cfm"></cfoutput><!---include target fbx_switch.cfm--->

<!------------------------------------------------------------------------------------------
SECTION 13
Catch any and all errors that are thrown by any fbx_switch or any fuse included from the fbx_switch. You can still have individual fuses try, throw and catch their own errors without being caught again in this section. This is only for unexpected errors or custom throw errors. If the fusebox.useErrorCatch flag is set to FALSE, then this whole section gets skipped, for backwards compatability and to allow applications to skip this functionality if they don't want it.
------------------------------------------------------------------------------------------->
 	<cfcatch type="Any">
		<cftry>
	 		<cfif fusebox.useErrorCatch>
				<cfscript>
				fusebox.cfcatch=cfcatch; 
				fusebox.rethrowError=TRUE; //prime the catching
				FB_.circuitAlias=fusebox.circuits[fusebox.thisCircuit];
				FB_.errorPath=fusebox.circuits[fusebox.thisCircuit];
				</cfscript>
				<cfloop condition="len(FB_.errorPath) GT 0"> <!--- as long as error path has more circuits --->
					<cfif fusebox.rethrowError>
						<cfif StructKeyExists(FB_.reverseCircuitPath, FB_.circuitAlias)>
							<cftry>
								<cfset fusebox.thisCircuit = FB_.reverseCircuitPath[FB_.circuitAlias]>
								<cfcatch>
									<cfset fusebox.thisCircuit="">
								</cfcatch>
							</cftry>
							<cfscript>
							fusebox.rethrowError=FALSE;//don't rethrow errors unless specified in this FEX_errorCatch
							if (fusebox.thisCircuit EQ fusebox.targetcircuit) fusebox.isTargetCircuit=TRUE;
								else fusebox.isTargetCircuit=FALSE;
							if (fusebox.thisCircuit EQ fusebox.homeCircuit)	fusebox.isHomeCircuit=TRUE;
								else fusebox.isHomeCircuit=FALSE;
							fusebox.currentPath=listRest(FB_.errorPath,"/");
							if (len(fusebox.currentPath)) fusebox.currentPath=fusebox.currentPath & "/";
							fusebox.rootPath=repeatString("../", listLen(fusebox.currentPath, '/'));
							</cfscript>
							<cftry><cfoutput><cfinclude template="#fusebox.currentPath#FEX_errorCatch.cfm"></cfoutput>
							<cfcatch type="MissingInclude"><!--- every circuit doesn't need it --->
								<cfset fusebox.rethrowError=TRUE></cfcatch>
							<cfcatch type="Any"><!--- Any errors generated in FEX_errorCatch.cfm overwrite the current error --->
								<cfset fusebox.cfcatch=cfcatch><cfset fusebox.rethrowError=TRUE></cfcatch>
							</cftry>
						</cfif>
					<cfelse>
						<cfbreak>
					</cfif>
					<cfset FB_.errorPath=listDeleteAt(FB_.errorPath,listLen(FB_.errorPath,"/"),"/")>
					<cfset FB_.circuitAlias=listDeleteAt(FB_.circuitAlias,listLen(FB_.circuitAlias,"/"),"/")>
				</cfloop>
		<cfelse>
			<cfoutput>
			<cfif cfcatch.type is "MissingInclude"><hr>The Fusebox core file encountered an error. It was unable to find the file
<pre>#FB_.fuseboxpath#fbx_switch.cfm</pre> or an included file from that fbx_switch.cfm in the the circuit <pre>#fusebox.circuit#</pre><cfif not fusebox.suppressErrors><cfrethrow></cfif>
			<cfelse><hr>The Fusebox core file encountered an error. There is an error in the file
<pre>#FB_.fuseboxpath#fbx_switch.cfm</pre> in the the circuit <pre>#fusebox.circuit#</pre> or in a file included from that fbx_switch.cfm. The most likely cause of this is an error in an included fuse.<p>If you think this error is incorrect or would like more information, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.<cfif not fusebox.suppressErrors><cfrethrow></cfif>
			</cfif>
			</cfoutput><cfabort>
		</cfif>
		<cfcatch type="Any"><cfrethrow><cfabort></cfcatch>
		</cftry>
	</cfcatch>

</cftry> 
</cfsavecontent>	

<!------------------------------------------------------------------------------------------
SECTION 14
Now handle the layouts, resolving them in bottom-to-top order to nest the circuits, if needed. Also set fusebox.thisCircuit equal to the circuit name of the current circuit the code is passing through, which will let any layout files in circuits know where they are. If attempting to include any layout file throws an error, then do nothing and continue on. This ENTIRE section and functionality of nesting layouts and controlling layouts via layout files is optional. If you do not have any layout files (fbx_layout.cfm), or only have a layout file in your root directory, everything will still work.
------------------------------------------------------------------------------------------->
<cfset FB_.circuitAlias = fusebox.circuits[fusebox.targetCircuit] >
<cfset FB_.layoutPath = fusebox.circuits[fusebox.targetCircuit] >
<cfloop condition="len(FB_.layoutpath) GT 0"> <!---loop as long as the layout path has more circuits to run--->
<cftry>
	<cfif structKeyExists(FB_.reverseCircuitPath, FB_.circuitAlias)>
		<cftry>
			<cfset fusebox.thisCircuit = FB_.reverseCircuitPath[FB_.circuitAlias] >
			<cfcatch>
				<cfset fusebox.thisCircuit = "">
			</cfcatch>
		</cftry>
		<cfscript>
		if (fusebox.thisCircuit EQ fusebox.targetcircuit) fusebox.isTargetCircuit=TRUE;
			else fusebox.isTargetCircuit=FALSE;
		if (fusebox.thisCircuit EQ fusebox.homeCircuit)	fusebox.isHomeCircuit=TRUE;
			else fusebox.isHomeCircuit=FALSE;
		fusebox.thisLayoutPath=listRest(FB_.layoutpath,"/");
		if (len(fusebox.thisLayoutPath)) fusebox.thisLayoutPath=fusebox.thisLayoutPath & "/";
		fusebox.currentPath=fusebox.thisLayoutPath;
		fusebox.rootPath=repeatString("../", listLen(fusebox.thisLayoutPath, '/'));
		</cfscript>
	 	<cftry> 
			<!--- include the fbx_layouts.cfm file for this circuit which decides which layout file to use--->
			<cfinclude template="#fusebox.thisLayoutPath#fbx_layouts.cfm">
			<cfparam name="fusebox.layoutDir" default=""><!--- deprecated in favor of directory pathing in fusebox.layoutFile --->
	 		<cfcatch type="MissingInclude">
				<cfset fusebox.layoutfile = "">
			</cfcatch>
			<cfcatch type="Any"><cfrethrow></cfcatch>
	 	</cftry>
		<cftry>
			<!--- attempt to include the actual layout file which was set by fbx_Layouts.cfm --->
			<cfif len(fusebox.layoutfile)>
			 	<cfset fusebox.layoutFile="#fusebox.layoutDir##fusebox.layoutFile#">
				<cfsavecontent variable="fusebox.layout">
					<cfif left(fusebox.layoutFile,1) IS "/">
						<cfset fusebox.currentPath=fusebox.layoutDir>
						<cfset fusebox.rootPath=repeatString("../", listLen(fusebox.layoutDir, '/'))>
						<cfoutput><cfinclude template="#fusebox.layoutFile#"></cfoutput>
					<cfelse>
						<cfset fusebox.currentPath=fusebox.thisLayoutPath&fusebox.layoutDir>
						<cfset fusebox.rootPath=repeatString("../", listLen(fusebox.currentPath, '/'))>						
						<cfoutput><cfinclude template="#fusebox.thisLayoutPath##fusebox.layoutFile#"></cfoutput>
					</cfif>
				</cfsavecontent>
			</cfif>
	 		<cfcatch type="MissingInclude">
			<cfwddx action="CFML2WDDX" input="#cfcatch#" output="FB_.cfcatch">	
			<cfthrow type="fusebox" errorcode="14" detail="#fusebox.thislayoutpath##fusebox.layoutdir##fusebox.layoutfile#" message="The Fusebox core file encountered an error. It could not find the file <pre>#fusebox.thislayoutpath##fusebox.layoutdir##fusebox.layoutfile#</pre>This file was identified as the layoutFile to use in fbx_layouts.cfm.<p>If you think this error is incorrect, turn off the Fusebox error catch flag and suppress error messages flag by setting fusebox.useErrorCatch to FALSE and fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's ""normal"" error output." extendedinfo="#FB_.cfcatch#"></cfcatch>			
			<cfcatch type="Any"><cfrethrow></cfcatch>
		</cftry>
	</cfif>
	<cfset FB_.layoutPath = listDeleteAt(FB_.layoutPath, listLen(FB_.layoutPath, "/"), "/")> <!---remove one level of the path--->
	<cfset FB_.circuitAlias = listDeleteAt(FB_.circuitAlias, listLen(FB_.circuitAlias, "/"), "/")>

<!-------------------------------------------------------------------------------------------
SECTION 15
Handle errors thrown during the process of including the fbx_layouts.cfm and layoutFiles above.
------------------------------------------------------------------------------------------->
<cfcatch type="Any">
	<cftry>
 		<cfif fusebox.useErrorCatch>
			<cfscript>
			fusebox.cfcatch=cfcatch; 
			fusebox.rethrowError=TRUE; //prime the catching
			FB_.circuitAlias=fusebox.circuits[fusebox.thisCircuit];
			FB_.errorPath=fusebox.circuits[fusebox.thisCircuit];
			</cfscript>
			<cfloop condition="len(FB_.errorPath) GT 0"> <!--- as long as error path has more circuits --->
					<cfif fusebox.rethrowError>
						<cfif StructKeyExists(FB_.reverseCircuitPath, FB_.circuitAlias)>
							<cftry>
								<cfset fusebox.thisCircuit = FB_.reverseCircuitPath[FB_.circuitAlias]>
								<cfcatch>
									<cfset fusebox.thisCircuit="">
								</cfcatch>
							</cftry>
							<cfscript>
							fusebox.rethrowError=FALSE;//don't rethrow errors unless specified in this FEX_errorCatch
							if (fusebox.thisCircuit EQ fusebox.targetcircuit) fusebox.isTargetCircuit=TRUE;
								else fusebox.isTargetCircuit=FALSE;
							if (fusebox.thisCircuit EQ fusebox.homeCircuit)	fusebox.isHomeCircuit=TRUE;
								else fusebox.isHomeCircuit=FALSE;
							fusebox.currentPath=listRest(FB_.errorPath,"/");
							if (len(fusebox.currentPath)) fusebox.currentPath=fusebox.currentPath & "/";
							fusebox.rootPath=repeatString("../", listLen(fusebox.currentPath, '/'));
							</cfscript>
							<cftry>
							<cfoutput><cfinclude template="#fusebox.currentPath#FEX_errorCatch.cfm"></cfoutput>
							<cfcatch type="MissingInclude"><!--- every circuit doesn't need it --->
								<cfset fusebox.rethrowError=TRUE></cfcatch>
							<cfcatch type="Any"><!--- Any errors generated in FEX_errorCatch.cfm overwrite the current error --->
								<cfset fusebox.cfcatch=cfcatch><cfset fusebox.rethrowError=TRUE></cfcatch>
							</cftry>
						</cfif>
					<cfelse>
						<cfbreak>
					</cfif>
				<cfset FB_.errorPath=listDeleteAt(FB_.errorPath,listLen(FB_.errorPath,"/"),"/")>
				<cfset FB_.circuitAlias=listDeleteAt(FB_.circuitAlias,listLen(FB_.circuitAlias,"/"),"/")>
			</cfloop>
 		<cfelse>
			<cfoutput>
			<cfif cfcatch.type is "MissingInclude"><hr>The Fusebox core file encountered an error. It was unable to find the file <pre>#fusebox.thislayoutpath##fusebox.layoutdir##fusebox.layoutfile#</pre> or an included file from that fbx_switch.cfm in the the circuit <pre>#fusebox.circuit#</pre><cfif not fusebox.suppressErrors><cfrethrow></cfif>
			<cfelse><hr>The Fusebox core file encountered an error. There is an error in the file
		<pre>#FB_.fuseboxpath#fbx_switch.cfm</pre> in the the circuit <pre>#fusebox.circuit#</pre> or in a file included from that fbx_switch.cfm. The most likely cause of this is an error in an included fuse.<p>If you think this error is incorrect or would like more information, turn off the Fusebox suppress error messages flag by setting fusebox.SuppressErrors to FALSE, and you will receive ColdFusion's "normal" error output.<cfif not fusebox.suppressErrors><cfrethrow></cfif>
			</cfif>
			</cfoutput><cfabort>
		</cfif>
	<cfcatch type="Any"><cfrethrow></cfcatch>
	</cftry>
	<cfbreak>
</cfcatch>
</cftry>	
</cfloop>

<!------------------------------------------------------------------------------------------
SECTION 16
If any errors were thrown at any point during the processing of this core file, catch them here.
------------------------------------------------------------------------------------------->
<cfcatch type="any">
	<!--- Use the built-in error handling --->
	<cfif fusebox.useErrorCatch>
	<cfset fusebox.cfcatch=cfcatch>
	<cfset FB_.useLayout="0">
		<cftry>
			<!--- Handle any errors of type "fusebox" --->
			<cfoutput><cfinclude template="FEX_errorCatch.cfm"></cfoutput>
			<cfcatch type="Any"><cfrethrow></cfcatch>
		</cftry>
	<!--- Don't use the built-in error handling - just rethrow it plainly --->
	<cfelse>
		<cfrethrow>
	</cfif>
</cfcatch>
</cftry>

<!--- Finally, output the totally-nested layout --->
<cfparam name="FB_.useLayout" default="1">
<cfif FB_.useLayout>
	<cfoutput>#trim(fusebox.layout)#</cfoutput>
</cfif>

</cfprocessingdirective><cfsetting enablecfoutputonly="no">