<cfset skeleton = "[HOME]

;Enter the page description here

link = target

Embeded Page Goes Here
---------------------------------------------------------">


<cffile action="WRITE" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##lcase(attributes.dir)#/home.wir" output="#skeleton#" nameconflict="SKIP">
