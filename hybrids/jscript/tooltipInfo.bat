@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

//gets an information that normally is acquired by right click-details 
// can get image dimensions , media file play time and etc.
 
////// 
FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var ARGS = WScript.Arguments;
if (ARGS.Length < 1 ) {
 WScript.Echo("No file passed");
 WScript.Echo("Usage:");
 WScript.Echo(" Item [magic_number]");
 WScript.Echo(" for number meanings open the script with text editor");
 WScript.Quit(1);
}
var filename=ARGS.Item(0);
var objShell=new ActiveXObject("Shell.Application");
var number=-1;
/////
try{
	if (ARGS.Length > 1) {
		number=parseInt(ARGS.Item(1));
	}
}catch(err){
	WScript.Echo(err.message);
	WScript.Echo("parsing failed");
	WScript.Quit(1);
}


if (number<-1 || number >288 ) {
	WScript.Echo("Out of range number [-1  -  288]");
	WScript.Quit(2);
}


//fso
ExistsItem = function (path) {
	return FSOObj.FolderExists(path)||FSOObj.FileExists(path);
}

getFullPath = function (path) {
    return FSOObj.GetAbsolutePathName(path);
}
//

//paths
getParent = function(path){
	var splitted=path.split("\\");
	var result="";
	for (var s=0;s<splitted.length-1;s++){
		if (s==0) {
			result=splitted[s];
		} else {
			result=result+"\\"+splitted[s];
		}
	}
	return result;
}


getName = function(path){
	var splitted=path.split("\\");
	return splitted[splitted.length-1];
}
//

function main(){
	if (!ExistsItem(filename)) {
		WScript.Echo(filename + " does not exist");
		WScript.Quit(2);
	}
	var fullFilename=getFullPath(filename);
	var namespace=getParent(fullFilename);
	var name=getName(fullFilename);
	var objFolder=objShell.NameSpace(namespace);
	var objItem=objFolder.ParseName(name);
	//https://msdn.microsoft.com/en-us/library/windows/desktop/bb787870(v=vs.85).aspx
	WScript.Echo(fullFilename + " : ");
	WScript.Echo(objFolder.GetDetailsOf(objItem,number));
	
}

main();

///
/*

0 Name: 
1 Size: 
2 Item type: 
3 Date modified: 
4 Date created: 
5 Date accessed: 
6 Attributes: 
7 Offline status: 
8 Offline availability: 
9 Perceived type: 
10 Owner: 
11 Kind: 
12 Date taken: 
13 Contributing artists: 
14 Album: 
15 Year: 
16 Genre: 
17 Conductors: 
18 Tags: 
19 Rating: Unrated
20 Authors: 
21 Title: 
22 Subject: 
23 Categories: 
24 Comments: 
25 Copyright: 
26 #: 
27 Length:
28 Bit rate: 
29 Protected: 
30 Camera model: 
31 Dimensions: 
32 Camera maker: 
33 Company: 
34 File description: 
35 Program name: 
36 Duration: 
37 Is online: 
38 Is recurring: 
39 Location: 
40 Optional attendee addresses: 
41 Optional attendees: 
42 Organizer address: 
43 Organizer name: 
44 Reminder time: 
45 Required attendee addresses: 
46 Required attendees: 
47 Resources: 
48 Meeting status: 
49 Free/busy status: 
50 Total size: 
51 Account name: 
52 Task status: 
53 Computer: 
54 Anniversary: 
55 Assistant's name: 
56 Assistant's phone: 
57 Birthday: 
58 Business address: 
59 Business city: 
60 Business country/region: 
61 Business P.O. box: 
62 Business postal code: 
63 Business state or province: 
64 Business street: 
65 Business fax: 
66 Business home page: 
67 Business phone: 
68 Callback number: 
69 Car phone: 
70 Children: 
71 Company main phone: 
72 Department: 
73 E-mail address: 
74 E-mail2: 
75 E-mail3: 
76 E-mail list: 
77 E-mail display name: 
78 File as: 
79 First name: 
80 Full name: 
81 Gender: 
82 Given name: 
83 Hobbies: 
84 Home address: 
85 Home city: 
86 Home country/region: 
87 Home P.O. box: 
88 Home postal code: 
89 Home state or province: 
90 Home street: 
91 Home fax: 
92 Home phone: 
93 IM addresses: 
94 Initials: 
95 Job title: 
96 Label: 
97 Last name: 
98 Mailing address: 
99 Middle name: 
100 Cell phone: 
101 Nickname: 
102 Office location: 
103 Other address: 
104 Other city: 
105 Other country/region: 
106 Other P.O. box: 
107 Other postal code: 
108 Other state or province: 
109 Other street: 
110 Pager: 
111 Personal title: 
112 City: 
113 Country/region: 
114 P.O. box: 
115 Postal code: 
116 State or province: 
117 Street: 
118 Primary e-mail: 
119 Primary phone: 
120 Profession: 
121 Spouse/Partner: 
122 Suffix: 
123 TTY/TTD phone: 
124 Telex: 
125 Webpage: 
126 Content status: 
127 Content type: 
128 Date acquired: 
129 Date archived: 
130 Date completed: 
131 Device category: 
132 Connected: 
133 Discovery method: 
134 Friendly name: 
135 Local computer: 
136 Manufacturer: 
137 Model: 
138 Paired: 
139 Classification: 
140 Status: 
141 Client ID: 
142 Contributors: 
143 Content created: 
144 Last printed: 
145 Date last saved: 
146 Division: 
147 Document ID: 
148 Pages: 
149 Slides: 
150 Total editing time: 
151 Word count: 
152 Due date: 
153 End date: 
154 File count: 
155 Filename:
156 File version: 
157 Flag color: 
158 Flag status: 
159 Space free: 
160 Bit depth: 
161 Horizontal resolution: 
162 Width: 
163 Vertical resolution: 
164 Height: 
165 Importance: 
166 Is attachment: 
167 Is deleted: 
168 Encryption status: 
169 Has flag: 
170 Is completed: 
171 Incomplete: 
172 Read status: 
173 Shared: No
174 Creators: 
175 Date: 
176 Folder name:
177 Folder path: 
178 Folder: 
179 Participants: 
180 Path: 
181 By location: 
182 Type: AVCHD Video
183 Contact names: 
184 Entry type: 
185 Language: 
186 Date visited: 
187 Description: 
188 Link status: 
189 Link target: 
190 URL: 
191 Media created: 
192 Date released: 
193 Encoded by: 
194 Producers: 
195 Publisher: 
196 Subtitle: 
197 User web URL: 
198 Writers: 
199 Attachments: 
200 Bcc addresses: 
201 Bcc: 
202 Cc addresses: 
203 Cc: 
204 Conversation ID: 
205 Date received: 
206 Date sent: 
207 From addresses: 
208 From: 
209 Has attachments: 
210 Sender address: 
211 Sender name: 
212 Store: 
213 To addresses: 
214 To do title: 
215 To: 
216 Mileage: 
217 Album artist: 
218 Album ID: 
219 Beats-per-minute: 
220 Composers: 
221 Initial key: 
222 Part of a compilation: 
223 Mood: 
224 Part of set: 
225 Period: 
226 Color: 
227 Parental rating: 
228 Parental rating reason: 
229 Space used: 
230 EXIF version: 
231 Event: 
232 Exposure bias: 
233 Exposure program: 
234 Exposure time: 
235 F-stop: 
236 Flash mode: 
237 Focal length: 
238 35mm focal length: 
239 ISO speed: 
240 Lens maker: 
241 Lens model: 
242 Light source: 
243 Max aperture: 
244 Metering mode: 
245 Orientation: 
246 People: 
247 Program mode: 
248 Saturation: 
249 Subject distance: 
250 White balance: 
251 Priority: 
252 Project: 
253 Channel number: 
254 Episode name: 
255 Closed captioning: 
256 Rerun: 
257 SAP: 
258 Broadcast date: 
259 Program description: 
260 Recording time: 
261 Station call sign: 
262 Station name: 
263 Summary: 
264 Snippets: 
265 Auto summary: 
266 Search ranking: 
267 Sensitivity: 
268 Shared with: 
269 Sharing status: 
270 Product name: 
271 Product version: 
272 Support link: 
273 Source: 
274 Start date: 
275 Billing information: 
276 Complete: 
277 Task owner: 
278 Total file size: 
279 Legal trademarks: 
280 Video compression: 
281 Directors: 
282 Data rate: 
283 Frame height:
284 Frame rate:
285 Frame width: 
286 Total bitrate: 
287 Masters Keywords (debug): 
288 Masters Keywords (debug): */
