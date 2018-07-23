<cffile action="delete" file="#wireframedatadirectory##lcase(attributes.oldtitle)#.wir">
<cfmodule template="index.cfm" fuseaction="rebar.addPage" pageData="#attributes.pageData#">