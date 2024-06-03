#!/bin/bash

core_home="/home/cpvbox/Sysad/Core"
mentee_details_file="/home/cpvbox/Sysad/menteeDetails.txt"


declare -A task_counts
declare -A submitted_mentees

for task in task1 task2 task3; do
    task_counts[$task]=0
done

while IFS=: read -r mentee username roll; do
    for task in task1 task2 task3; do
        mentee_task_file="$core_home/mentees/$username/task_submitted.txt"
        if grep -q "$task" "$mentee_task_file" 2>/dev/null; then
    ((task_counts[$task]++))
    submitted_mentees[$task]+="$username "
       else
       echo "Warning: Unable to read $mentee_task_file" >&2
       fi
    done
done < "$mentee_details_file"

echo "Submission status:"
for task in task1 task2 task3; do
    total_mentees=$(wc -l < "$mentee_details_file")
    percent=$((100 * task_counts[$task] / total_mentees))
    echo "$task: $percent% submitted"
    echo "Mentees who submitted $task: ${submitted_mentees[$task]}"
done
