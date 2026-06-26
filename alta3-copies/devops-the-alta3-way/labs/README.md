# Directory Structure

Within this **labs** directory, each course added will have its own directory with the shortcode for the name of the course.

Example: dsp = (Docker, Microservices, and Reverse Proxies)

Furthermore, inside of this new course we are adding, there will be additional
folders that refer to specific types of files such as, but not limited to:
config, html, shell scripts, yaml.

Make the directory structure based on the file types and formats the course you
are adding actually uses. If you have a C++ course, there may be no need for
a python directory inside because there may not be python scripts in that
course.

Within github.com/alta3/labs/<course-name>/SUMMARY.md, you will see either
local files or files referenced to the content symlink. It is within these
files found in SUMMARY.md in each course that you will copy any code and
place the code as an actual file HERE in the appropriate file type directory.

Example: 

*lab-network-intro.md* in the tcp-ip course has a script called full-setup.sh
that is 271 lines long. To put that in the markdown file as a code block will
put eyes in the back of the head. Instead of doing that, we make it clean and
more visually appealling by having a shortened number of lines show up on the
screen in that code's colorscheme, adding a scrollbar they can look through if
so desired. Here is an exmple of what that looks like:

```
<iframe
src="https://batcat.alta3.com/alta3/devops-the-alta3-way/main/labs/tcpip/scripts/full-setup.sh"
frameborder="0" style="width: 100%; height: 40em"></iframe>
```

Now there is one place to edit this file, so if the file gets used again, just copy the
above line into the appropriate spot. If you want another version with some
edits, just make this file_v2.filetype

Current **dsp** structure:

```
labs/dsp
├── config
│   └── README.md
├── docker-compose
│   └── README.md
├── dockerfiles
│   └── README.md
├── sql
│   └── README.md
└── yaml
    └── README.md


```





**Only create the directories you need within your course**, or you may be saying
to yourself, 'did I miss a file in this course? Now I have to go all the way
back through the course to check'.
