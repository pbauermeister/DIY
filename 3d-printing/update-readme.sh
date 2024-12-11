#!/bin/sh
#
# 
set -e


purge() {
    (
	sed -n '/^<!-* auto-generated --> *$/q;p' README.md
	echo "<!-- auto-generated -->"
    ) > README.md.new
    mv README.md.new README.md
}


mk_header() {
    (
	cat <<EOF
| Summary | Preview | STL | Folder | See also |
| ------- | ------- | --- | ------ | -------- |
EOF
    ) >> README.md
}

collect_summaries() {
    urlbase="https://github.com/pbauermeister/DIY/raw/master/3d-printing"
    for f in */README.md; do
	d=$(dirname $f)

	# must have a summary text, and image or STL
	grep -q "^Summary:" $f || continue
	test -f $d/_summary.png -o -f $d/_summary.stl || continue

	# text
	summary=$(grep "^Summary:" $f | sed 's/Summary: *//g')
	echo -n "| $summary "

	# image
	if [ -f $d/_summary.png ]; then
	    echo -n "| <img src='$urlbase/$d/_summary.png?raw=true' width='200'> "
	else
	    echo -n "| "
	fi

	# STL
	if [ -f $d/_summary.stl ]; then
	    if [ -L $d/_summary.stl ]; then
		orig=$(ls -l $d/_summary.stl | sed 's@.*-> @@g')
		echo -n "| [$d/$orig]($d/$orig) "
	    else
		echo -n "| [$d/_summary.stl]($d/_summary.stl) "
	    fi
	else
	    echo -n "| "
	fi

	# folder
	echo -n "| [$d]($d) "

	# see also
	if grep -q "^See also:" $f; then
	    link=$(grep "^See also:" $f | sed 's/See also: *//g')
	    echo -n "| [Tutorial]($link) "
	else
	    echo -n "| "
	fi

	# end
	echo "|"

    done >> README.md
}


purge
mk_header
collect_summaries
