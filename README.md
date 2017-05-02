# Open Publishing Package

This is a stripped down version of a publishing package I created for the *Amsterdam University of Applied Sciences* (AUAS); that is used to make .epub, .html, .pdf publications out of .docx manuscripts. The aim of the workflow is to automate as much of the rudimentary tasks as possible whilst leaving enough space for creative freedom and customisation. It is developed for UNIX based operating systems, works via the terminal, and requires:

- [Make]('https://www.gnu.org/software/make/')
- [Pandoc]('http://pandoc.org/)
- [Wkhtmltoimage]('https://wkhtmltopdf.org/')
- [Pngquant]('https://pngquant.org/')

In the resources you will find all files that are part of the workflow. Some, such as the InDesign template files, have been replaced by .txt files explaining their purpose in order to not overload this repository unnecessarily. A .docx and cover image file have also been added to the main directory for a quick demonstration of the workflow. Once everything all dependencies have been installed, running any of the make commands listed below should work.

At the core of this workflow is the .docx file format. The reason that .docx has been chosen is the same as described in a [workshop on creating a digital publishing workflow]('https://github.com/dylandegeling/CDPW-Workshop') I gave at *PublishingLab*, Amsterdam:

> Office Open XML files can represent word processing documents (.docx), presentations (.pptx), and spreadsheets (.xlsx). Every Office Open XML file consists of a .zip compressed package that contains specific XML files + embedded files such as images and other media. In theory, it is possible to embed any file type into the package. Another benefit of the package is that its compression allows Office Open XML files to stay relatively small.
> Since almost everyone has access to making Office Open XML files through an office suite (*Microsoft Office*, *Google Docs*) - it makes for a powerful file format to use as the starting point of our workflow.

## Resources
A description of what can be found in the resources directory and what the purpose of each of the files or folders is. The files are separated in directories that name the format they apply to.

### docx
#### how\_to\_structure\_a.docx
A manual for structuring .docx file for use with the *Open Publishing Package*.

#### manuscript\_template.docx
Template for .docx manuscripts.

### epub
#### fonts
Directory that contains the fonts that are going to be embedded into the .epub file. Make sure that the license of the font allows it to be embedded into .epub files. The fonts should be named as such: `NameOfFont-Style`, and be in the .ttf file format. For example the files of *Open Sans* would be: `OpenSans-Regular.ttf`, `OpenSans-Italic.ttf` and `OpenSans-SemiBold.ttf`.

#### style.css
Stylesheet used in the .epub file.

#### table.css
Tables and .epub publications don't go that well together. Therefore a solution had to be build that allowed the reader to view a table without it being distorted by the way .epub reading software handles `<tables>`—therefore it was decided to convert them to images. This stylesheet determines how these images look.

### html
#### style.css
Stylesheet used add styling.

#### script.js
Javascript file used to add interactivity.

#### after_body.html
HTML code that is inserted directly before the closing `</body>` tag.

#### before_body.html
HTML code that is inserted directly after the opening `<body>` tag.

#### in_header.html
HTML code that is inserted into the `<header>` tag.

### pdf
#### cover_image.indt
*Adobe InDesign* template file for creating cover images for .pdf and .epub publications.

#### pdf_template.indt
*Adobe InDesign* template file for creating .pdf publications.

## Make commands
These are all the commands that the makefile supports.

### make all
Converts all .docx manuscripts in the main directory to .epub and .html publications, and creates an .icml files for use in *Adobe InDesign*.

### make yml
Creates a .yml file with metadata for all .docx manuscripts in the main directory.

### make epub
Converts all .docx manuscripts in the main directory to .epub publications.

### make html
Converts all .docx manuscripts in the main directory to .html publications.

### make icml
Converts all .docx manuscripts in the main directory to .icml files for use in *Adobe InDesign*.

### make docx
Stores the .docx file in the publications directory.

### make update
Updates all publications with the latests resources.

### make reset
Returns all .docx files to the main directory and removes the publications directory.

### make readme
Outputs the README.md in the terminal.

### make license
Outputs the LICENSE.txt in the terminal.

## Important notices
Most information, or warnings, are given by the terminal itself and can be troubleshooted from there. These are just some things to keep into account when making use of this package:

- Use underscores (`_`) instead of spaces (` `) in file names.
- Nothing happens unless there is a .docx manuscript in the main directory.
- To convert a .docx manuscript to other formats through commands other than `make all` a .yml metadata file has to be created first by running `make yml`. Once a .yml file has been created for a manuscript it can be freely converted from there on out.
- A cover image (.png) with the same name as the .docx manuscript needs to be in the main directory to convert to .epub.
- Don't worry about the `csplit: <table>: no match` message when converting to .epub.
- The workflow does not convert to .pdf directly. Instead it converts to .icml and therefore requires *Adobe InDesign* to create .pdf publications. This is done because directly editing .pdf's is . For the AUAS an InDesign template file (.indt) has been created that automatically applies the correct styling when the .icml is placed in the InDesign file.
- It is recommended to use images in the .png format since .png compression has been build into the workflow. This was mainly done for the conversion from tables to images, for the conversion to .epub, but it is also applied to all other .png images embedded in the .docx file.