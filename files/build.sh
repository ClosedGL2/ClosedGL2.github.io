#!/bin/sh

# check if in same directory as build-templates
if ls build-templates >& /dev/null
then
	echo "build-templates is here. Proceeding"
else
	echo "Please make sure the current directory is the root directory of the site source." > /dev/stderr
	exit 1
fi

# check if build already exists
if ls build >& /dev/null
then
	echo "\"build\" directory already exists. Quitting" > /dev/stderr
	exit 1
fi

# list markdown files
echo "Listing markdown files..."
find sitesrc -iname "*.md" > /tmp/mdfiles

# get final file paths
sed "s/sitesrc\//build\//" < /tmp/mdfiles | sed 's/.md/.html/' > /tmp/buildfiles

# copy files to build directory
echo "Copying site files to build directory..."
cp -r sitesrc build >& /dev/null

# convert each markdown file
echo "Converting markdown files to HTML..."
for (( i=1; i<=$(wc -l < /tmp/mdfiles); i++ )); do
	infile=$(sed -n $i"p" /tmp/mdfiles)
	outfile=$(sed -n $i"p" /tmp/buildfiles)

	echo $infile" -> "$outfile
	
	# count number of subdirectories
	subdirs=$(echo $infile | awk -F"/" "{print NF-2}")

	# top template to final file
	sed "s/%s/$(mdbuilder -ti $infile)/" < "build-templates/t"$subdirs"-top.html" > $outfile

	# md to final file
	mdbuilder -pi $infile | sed "s/^/\t\t\t/" >> $outfile

	# bottom template to final file
	cat "build-templates/t"$subdirs"-bottom.html" >> $outfile
done

# clean up
echo "Cleaning up..."
find build -iname "*.md" | xargs rm
rm /tmp/mdfiles
rm /tmp/buildfiles
