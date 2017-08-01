(( DEBUG )) && echo "Invoking $THIS with args = $@"

echo "**** $(date) ****" | tee "$LOG"
eval "${1} ${2}1" & wait_progress "${THIS} ($1)"
