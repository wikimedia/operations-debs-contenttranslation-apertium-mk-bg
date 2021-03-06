#!/bin/bash

TESTTYPE="$1_tests"
SRCLANG=$2
TRGLANG=$3

# Mac mktemp has no default template, this works on both
SRCLIST=`mktemp -t tmp_$1.XXXXXXXXXX`;
TRGLIST=`mktemp -t tmp_$1.XXXXXXXXXX`;
TSTLIST=`mktemp -t tmp_$1.XXXXXXXXXX`;

basedir=`pwd`;
mode="$SRCLANG-$TRGLANG"

SED=sed
if test x$(uname -s) = xDarwin; then 
	ECHOE="builtin echo"
	SED=gsed
fi

cleansrc () {
    grep "<li> ($SRCLANG)" | $SED 's/<.*li>//g' | $SED 's/ /_/g' | cut -f2 -d')' | $SED 's/<i>//g' | $SED 's/<\/i>//g' | cut -f2 -d'*' | $SED 's/→/!/g'  | sed 's/::/!/g' | cut -f1 -d'!' | $SED 's/(note:/!/g' | $SED 's/_/ /g' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/$/./g'
}
cleantrg () {
    grep "<li> ($SRCLANG)" | $SED 's/<.*li>//g' | $SED 's/ /_/g' | $SED 's/(\w\w)//g' | $SED 's/<i>//g' | cut -f2 -d'*' | $SED 's/<\/i>_→/!/g' | sed 's/::/!/g' | cut -f2 -d'!' | $SED 's/_/ /g' | $SED 's/^ *//g' | $SED 's/ *$//g' | $SED 's/$/./g'
}
wget -O - -q http://wiki.apertium.org/wiki/Macedonian_and_Bulgarian/$TESTTYPE | cleansrc > $SRCLIST;
wget -O - -q http://wiki.apertium.org/wiki/Macedonian_and_Bulgarian/$TESTTYPE | cleantrg > $TRGLIST;

apertium -d . $mode < $SRCLIST > $TSTLIST;

cat $SRCLIST | sed 's/\.$//g' > $SRCLIST.n; mv $SRCLIST.n $SRCLIST;
cat $TRGLIST | sed 's/\.$//g' > $TRGLIST.n; mv $TRGLIST.n $TRGLIST;
# 2nd sed removes tab characters, Mac sed doesn't recognize \t
cat $TSTLIST | sed 's/\.$//g' | sed 's/	/ /g' > $TSTLIST.n; mv $TSTLIST.n $TSTLIST;

TOTAL=0
CORRECT=0
# sed with tab again
for LINE in `paste $SRCLIST $TRGLIST $TSTLIST | sed 's/ /%_%/g' | sed 's/	/!/g'`; do
#	echo $LINE;

	SRC=`echo $LINE | sed 's/%_%/ /g' | cut -f1 -d'!' | sed 's/^ *//g' | sed 's/ *$//g' | sed 's/  / /g'`;
	TRG=`echo $LINE | sed 's/%_%/ /g' | cut -f2 -d'!' | sed 's/^ *//g' | sed 's/ *$//g' | sed 's/  / /g'`;
	TST=`echo $LINE | sed 's/%_%/ /g' | cut -f3 -d'!' | sed 's/^ *//g' | sed 's/ *$//g' | sed 's/  / /g'`;

	
	echo $TRG | grep "^$TST$" > /dev/null;	
	if [ $? -eq 1 ]; then
		echo -e $mode"\t  "$SRC"\n*\t- $TRG\n\t+ "$TST"\n";
	else
		echo -e $mode"\t  "$SRC"\nWORKS\t  $TST\n";
		CORRECT=`expr $CORRECT + 1`;
	fi
	TOTAL=`expr $TOTAL + 1`;
done

CALC=
WORKING=
if [ -x /usr/bin/calc ]; then
    CALC="/usr/bin/calc"
elif [ -x /opt/local/bin/calc ]; then
    CALC="/opt/local/bin/calc"
fi
if [ -n $CALC ]; then
	WORKING=`$CALC $CORRECT" / "$TOTAL" * 100" | head -c 7`;
	WORKING=", "$WORKING"%";
fi
echo $CORRECT" / "$TOTAL$WORKING;

rm $TRGLIST $TSTLIST;
# rm $SRCLIST
