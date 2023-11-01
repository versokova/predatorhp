#!/bin/bash

DIR="test"
OUT_DIR="_test"

status_update() {
	printf "\n%s...\n\n" "$*"
	tty >/dev/null && printf "\033]0;%s\a" "$*"
}

die() {
    printf "%s: %s\n" "$SELF" "$*" >&2
    exit 1
}

run_predatorhp() {
    SRC="$1"
    PRP="$2"
    echo "Running $SRC..."
    ./predatorHP.py --propertyfile "$DIR/properties/$PRP.prp" \
                    --witness "$OUT_DIR/${SRC%.c}.graphml" \
                    --compiler-options="-m32" \
                    "$DIR/$SRC"
}

status_update "Running PredatroHP"
[ -e "$OUT_DIR" ] || mkdir $OUT_DIR
echo "Running $src..."
run_predatorhp test01-valid-memsafety.c valid-memsafety
run_predatorhp test02-err-valid-deref.c valid-memsafety
run_predatorhp test03-err-valid-free.c valid-memsafety
run_predatorhp test04-err-valid-memtrack.c valid-memsafety
run_predatorhp test05-err-valid-memcleanup.c valid-memcleanup
run_predatorhp test06-assert.c unreach-call
run_predatorhp test07-err-assert.c unreach-call
