<div align="center">
<TABLE BORDER="0" cellpadding="0" cellspacing="0" style="border: 1pt solid Black;" WIDTH="80%">
<TR VALIGN="TOP"><TD ALIGN="CENTER">

<TABLE BORDER="0" cellpadding="5" cellspacing="0" WIDTH="100%">

<TR VALIGN="TOP">
	<TD ALIGN="CENTER" COLSPAN="3" CLASS="pageHeader">Rebar Help</TD>
</TR>
<TR>
	<TD CLASS="pageBody">
Have you ever bought a new car? Recently, our friend Stan did just that. He spent a long time researching the different models in his price range that met his baseline criteria. He spent hours poring over consumer review web sites deciphering all the details of each model - engine size, available option packages, safety ratings, and maintenance reports. He went to the bookstore night after night and read the latest reports of new cars, trying to crop the list. Eventually, he had narrowed the field from hundreds of models to a small handful. Finally, he test-drove the candidates. The winner was determined based on those test drives. After spending a little time behind the wheel of each one, Stan knew which one was right. Not until he saw the car in action did he know whether it was the right one.
<br><br>
The process that Stan went through to buy a car is similar to the process of developing successful applications. Our clients never know what they want until they get it, just as Stan didn't know what car he wanted until he test-drove them all. Rather than complaining, "Why didn't you tell us you wanted this before we started?" we use Rebar to deliver the application to clients before writing a single line of code.
<br><br>
A Rebar wireframe is a page-by-page, plain-text representation of what a finished application will do. Devoid of techno-babble such as UML, flowcharts, or data models, the wireframe is extremely fast to develop, is readable by everyone, and answers the oft-overlooked question of what the application needs to do. As soon as a client begins identifying her requirements, it is quite tempting to open up a new Access file and begin the preliminary database schema. Let's face it - we are all geeks, so writing code and thinking in application systems is what we do best.
<br><br>
However, if we are lulled into thinking about architectural subsystems before we fully understand what the finished system is supposed to do, then it is likely that we will subconsciously rearrange the requirements into something that is easily coded. This is dangerous because by giving the client what we think she wants, we almost never give her what she actually wants. Until the Rebar wireframe is done, we do not know anything about her requirements.
<br><br>
	</TD>
</TR>

<TR>
	<TD CLASS="pageSubHeader" ALIGN="CENTER">&lt; Using The Admin &gt;</TD>
</TR>
<TR VALIGN="TOP">
	<TD CLASS="pageBody">
	Take a look at the links at the top of the page. They appear in Figure 1, below.<br><br>
	<div align="center"><cfoutput><img src="#fusebox.currentPath#help_1.jpg" alt="" border="1"></cfoutput></div><br>
	Those links are available on every page, and provide access to the most common tools in Rebar. The "Add New Page" link does just that. For more information on adding pages, look down to the section titled "Creating New Pages". The "Map" link shows the map of the current Rebar wireframe, which is helpful to manage larger wireframes. The "Help" link takes you to this page. Finally, the "Admin" link takes you to the Rebar admin.
<br><br>
	The Rebar admin provides three options, along with the familiar universal navigation. At the top, you can choose an existing wireframe to edit. Rebar comes with a sample wireframe, but if no wireframes are available, this option will not be available. You can choose a wireframe to work with by selecting it in the drop-down and clicking "edit".
<br><br>
	Another option that appears when there are existing wireframes is the third option - "export to HTML". This powerful feature allows you to take a wireframe built in Rebar and generate a starter prototype. Going from wireframe to prototype follows the Fusebox Lifecycle Process (FLiP). More information on generating starter prototypes can be found below, in the section titled "Generating Starter Prototypes".
<br><br>
	The final option in the Rebar admin is for creating a new wireframe. By entering a wireframe name consisting of numbers and letters, then clicking "create new", Rebar will create the wireframe for you, along with a sample home page. After you create a wireframe, you immediately begin editing the first page. The newly-created wireframe name will also appear in the drop-down in the Rebar admin so you can easily edit it next time.
<br><br>
	</TD>
</TR>

<TR>
	<TD CLASS="pageSubHeader" ALIGN="CENTER">&lt; Browsing Your Wireframe &gt;</TD>
</TR>
<TR VALIGN="TOP">
	<TD CLASS="pageBody">
	The first way you see a newly-created wireframe is via the map. The map provides a quick synopsis of the entire wireframe. It shows all the page titles, a little bit of the page content, all the links (including nested pages - more on that in a bit), along with handy links for editing pages. A sample map page looks like Figure 2, below.<br><br>
<div align="center"><cfoutput><img src="#fusebox.currentPath#help_2.jpg" width="497" height="205" alt="" border="1"></cfoutput></div><br>
Clicking a page title takes you to the view of that page, while clicking the "Edit Page" link below it takes you to the edit screen for that page. On the right side, you can see linked pages and a nested page. Nested pages aren't clickable from the map, but they are clickable from the page view. Nested pages allow wireframe creators to identify certain pages to be included within other pages. This is especially helpful for universal navigation. More on nested pages is below.
	<br><br>
	</TD>
</TR>

<TR>
	<TD CLASS="pageSubHeader" ALIGN="CENTER">&lt; Creating &amp; Editing Pages &gt;</TD>
</TR>
<TR VALIGN="TOP">
	<TD CLASS="pageBody">
		Upon clicking the "Add New Page" link, you can add a new page. The form is divided into five sections. At the top, the "Page Title" entry is where you name the new page. As you could guess, this is the title of the page. It serves two purposes - what name to display at the top of the page and how to reference this page when linking. Remember: The goal of wireframing is to create a text-based representation of the web site consisting of page responsibilities and links - nothing more. When rendered by Rebar's viewer, the text entered here becomes the page title. By default, the word "title" appears in the text box. Change it to anything you like, as long as it is letters, numbers, and spaces. Figure 3 shows the Page Title entry.<br><br>
<div align="center"><cfoutput><img src="#fusebox.currentPath#help_3.jpg" width="250" height="70" alt="" border="1"></cfoutput></div><br>
		The second section, "Page Content", is where you enter information about the page. When wireframing, we are striving to determine what the application does and what each page does, not how it goes about accomplishing its task. You might have ideas about how to word the content of each page, and that is fine. Hold onto those ideas, and do not waste time getting them right in the wireframe. The wireframing process is fast and furious, so keep the content of each page to a minimum. Figure 4, below, shows the Page Content entry section.<br><br>
<div align="center"><cfoutput><img src="#fusebox.currentPath#help_4.jpg" width="336" height="103" alt="" border="1"></cfoutput></div><br>
		The third section, "Linked Pages", allows you to quickly link one page to another. On the left side of the equal sign is the link that will be displayed on the page. The text on the right side of the equal sign is the page where the link goes. If you know HTML, we will tell you now that this line translates into something like this:
<xmp><a href="target">link</a></xmp>
Figure 5, below, shows the Linked Pages entry.<br><br>
<div align="center"><cfoutput><img src="#fusebox.currentPath#help_5.jpg" width="298" height="98" alt="" border="1"></cfoutput></div><br>
		The fourth section, at the bottom of the page, is the "Nested Pages" section. This is similar to the Linked Pages section, but the syntax is different. Instead of name=value pairs, we just enter the name of the page, on a line by itself, to nest in. This is most often used in global navigation menus, available on any page. Because a wireframe page is supposed to show every link that the finished application page does, we need to represent those global links. Of course, we could type every global link on every page, but then if we needed to add one new link to the global navigation, we would be forced to duplicate that link on every page, which is not in the best interest of the lazy programmer. By typing just the value of a page without a corresponding name, we can nest a page in another page, similar to &lt;cfinclude&gt;. Figure 6, below, shows the Nested Pages entry and the example syntax.<br><br>
<div align="center"><cfoutput><img src="#fusebox.currentPath#help_6.jpg" width="264" height="96" alt="" border="1"></cfoutput></div><br>
	The fifth and final section is on the right-hand side next to the Linked Pages and Nested Pages sections. This panel shows all currently created wireframe pages. At the top of the section are two radio buttons. By selecting "Linked" and then clicking any wireframe page below, that wireframe page is automatically added as a linked page, and it appears in the Linked Pages section. Likewise, by selecting "Nested" and then clicking any page, that page is automatically added as a nested page, and it appears in the Nested Pages section. This functionality allows you to quickly add nested and linked pages without worrying about syntax or getting the spelling right. Figure 7, below, shows the existing page panel.<br><br>
<div align="center"><cfoutput><img src="#fusebox.currentPath#help_7.jpg" width="184" height="142" alt="" border="1"></cfoutput></div>
	<br><br>
	After making any changes you want, press either "save" button (one below the Linked Pages section and one below the Nested Pages section) to save the page. Once saved, you are taken to the page's view.<br><br>
	To delete existing pages, click the "delete" button in the bottom right-hand corner of this edit page. Beware though, there is no confirmation before the page is deleted. For that reason, the button is somewhat hidden.<br><br>
	</TD>
</TR>

<TR>
	<TD CLASS="pageSubHeader" ALIGN="CENTER">&lt; Cross-Wireframe Linking &gt;</TD>
</TR>
<TR VALIGN="TOP">
	<TD CLASS="pageBody">
	After a certain size, wireframes can get unwieldy to manage. Rebar provides some advantages to handling many-paged wireframes including the quick linking panel and individual wireframe page editing, but the best feature is cross-wireframe linking.<br><br>
	Normal wireframe page links look like this:
	<pre>link name=target wireframe page</pre>
	The "link name" is what will appear on the wireframe page as the link, and the "target wireframe page" is the wireframe page that will be displayed when that link it clicked. But my prepending the name of a different wireframe before the target wireframe page, you can create a link to a page in a completely different wireframe.<br><br>
	Take for example, the following link:
	<pre>8 ball = 8 ball.question</pre>
	When placed in the "photo album" wireframe, this link provides a way to get over to the "8 ball" wireframe's "question" page. It's as simple as that!<br><br>
	One good way to implement this functionality is to break larger wireframes into smaller ones, with each smaller wireframe representing one "part" of the site. For example, an intranet might have a number of areas including email, file sharing, team collaboration, and company news. Each section might be its own wireframe, and they are all linked together via one global navigation.
	<br><br>
	</TD>
</TR>

<TR>
	<TD CLASS="pageSubHeader" ALIGN="CENTER">&lt; Generating Starter Prototypes &gt;</TD>
</TR>
<TR VALIGN="TOP">
	<TD CLASS="pageBody">	
	Included in the Rebar admin is the ability to generate static, HTML-based versions of a wireframe. There are two major reasons to create static versions of a wireframe - to control client access to wireframes and ease distribution of evolving wireframes, and to transition from a wireframe to a prototype, following the steps in the Fusebox Lifecycle Process.<br><br>
	Because the goal of wireframes is to create a plain-text version of many (if not all) of the finished application's pages, it is crucial to get the wireframe into the hands of your client or customer as early and as often as possible. If you get quality face time with your client, working on the wireframe is a great way to spend that time. But often, we are stuck with review periods, where you start the wireframe, your client reviews it and gives feedback, you incorporate that feedback into the wireframe, then your client views it again, providing more feedback. This cycle can continue on for quite some time, depending on how you like to structure your development phases. But to get adequate feedback from your client, you need to give her a copy of the wireframe, ideally without the ability to modify the wireframe. She shouldn't be modifying pages willy-nilly. She also should have a way to record her feedback about each page, <em>on each page</em>. That's where generating starter prototypes comes in.<br><br>
	Whenever it makes sense to get client feedback, you can run Rebar's prototype generator and Rebar will crank out static versions of each page, with all the links between pages intact. This allows HTML pages to be emailed, placed on a shared server, or easily transported to the client.<br><br>
	But what if you use a DevNotes-type tool to gather feedback from your client? That's where Rebar's non-encrypted fbx_layouts.cfm and lay_noNav.cfm files come into play. By editing those files, you can modify the code that is generated by Rebar. The fbx_layouts.cfm file looks like this:
<pre>
&lt;cfparam name="attributes.includeNav" default="1"&gt;
&lt;cfif attributes.includeNav&gt;
   &lt;cfset fusebox.layoutFile = "lay_defaultLayout.cfm"&gt;
&lt;cfelse&gt;
   &lt;cfparam name="attributes.layoutFile" default="lay_noNav.cfm"&gt;
   &lt;cfset fusebox.layoutFile="#fusebox.rootpath#_layouts/#attributes.layoutFile#"&gt;
&lt;/cfif&gt;
</pre>
The variable "attributes.includeNav" is the switch to tell you as a developer if this request is being run by the starter prototype generator, or is simply being called by Rebar. The layout file lay_noNav.cfm can be modified to include whatever code you want included, or to change the layout of the page entirely. Included in Rebar's distribution is an alternate layout file, lay_noNav2.cfm, which you can choose to be the layout file, during the generation of the prototype.<br><br>
	For example, check out Figure 8, below. It shows some of the options to choose when building a starter prototype from a Rebar wireframe.<br><br>
<div align="center"><cfoutput><img src="#fusebox.currentPath#help_8.jpg" alt="" border="1"></cfoutput></div><br>
You can create your own layout files, using lay_noNav.cfm as a template, and simply by dropping them into the /rebar/_layouts/ folder, alongside the other layout files, the Rebar admin will pick them up and make them available for use in creating prototypes. Use the sample lay_noNav2.cfm to try out this functionality.<br><br>
	Along with creating and using new layout files, the Rebar starter prototype generator allows you to choose which existing wireframe page should be the "home" page (number 1, in Figure 8, above), which you can enter in the second text box (number 2). Usually, the default filename is index.htm, index.cfm, or default.htm, but you can enter any page that your webserver uses as the default. You can also choose what the file extension should be of the generated pages. If you use a DevNotes tool, you may want to create all the pages as ".cfm", via text box number 3. The fourth textbox in Figure 8 lets you decide where Rebar should create the starter prototype. This can be any location relative to the server, not your client. By default, the prototype directory is "/HTML", off of the wireframe directory. Finally, the last drop-down box lets you choose which layout file to apply to the generated pages.
	<br><br>
	</TD>
</TR>


<TR>
	<TD CLASS="pageSubHeader" ALIGN="CENTER">&lt; Customizing Rebar &gt;</TD>
</TR>
<TR VALIGN="TOP">
	<TD CLASS="pageBody">Although Rebar is encrypted, some aspects of Rebar are customizable: the layout files and fbx_layouts.cfm, the style sheet, and the settings.conf file.<br><br>
	Because Rebar is a fully-compliant Fusebox 3 application, it can be added to any existing Fusebox 3 application. To do this, copy and paste the entire "rebar" folder from it's default installation location into the directory path of your master Fusebox application, and update the fusebox.circuits structure to reflect the addition of the "rebar" circuit. You can now modify Rebar's fbx_layouts.cfm and lay_defaultLayout.cfm to reflect the integration of Rebar to your application.<br><br>
	Rebar uses a cascading style sheet to handle much of the layout, fonts and colors. You are free to modify this file, or replace it with your own. The style names are very self-explanatory, and any further discovery is easily made by viewing the source of generated pages. The file is named "rebar.css".<br><br>
	Rebar uses a configuration file, named settings.conf, which allows some modifications to the Rebar environment to be made. The explanation of the settings is included inline with the configuration file. One particularly powerful configuration is made by setting "attributes.multiPartForm". By default, this varaiable is set to "1", which means that Rebar will display the multi-part wireframe editing and creating page, which is the page that is described in this Help page. By setting this variable to "0", Rebar uses the traditional wireframe page entry system.<br><br>	
	</TD>
</TR>

<TR>
	<TD CLASS="pageSubHeader" ALIGN="CENTER">&lt; Special Notes Regarding Rebar In Multi-Developer Environment &gt;</TD>
</TR>
<TR VALIGN="TOP">
	<TD CLASS="pageBody">Rebar is lightweight and configure-free. There are no databases to set up, no DSNs to create and manage, and no mappings to worry about. But with this portability comes a tradeoff in handling multiple developers/editors at once. Because Rebar uses the server's file system to store the wireframe in the form of multiple .wir files, concurrent read/write access to any single file can cause problems.<br><br>
	Multiple developers can certainly be working on one wireframe at a time, but if one editor switches to work on another wireframe, the second editor may receive errors, or be forced to edit the newly-chosen wireframe. In effect, Rebar is single-threaded for all users. In order to accomodate multiple editors, they all must be in communication regarding changes and Rebar use. If two people are editing a single page at the same time, each person's submittal writes over the existing wireframe page. The last person to push submit effectively has his or her changes saved while the others are lost. But this is not unique to Rebar, nor to file system access. There is just no "locking" built into the page edit process in Rebar.<br><br>
	However, because Rebar is so lightweight and easy to set up and configure, you can have multiple copies of it running, say, once per project. This allows many people to be using Rebar as the same time, even though each person is running his or her own copy of Rebar.<br><br>
	</TD>
</TR>


</TABLE>


</TD></TR>
</TABLE>
</div>
