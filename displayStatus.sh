#!/bin/bash

# Set the core home directory and the file containing mentee details
core_home="/home/cpvbox/Sysad/Core"
mentee_details_file="/home/cpvbox/Sysad/menteeDetails.txt"

# Declare associative arrays for task counts and submitted mentees
declare -A task_counts
declare -A submitted_mentees

# Initialize task counts and submitted mentees arrays
for task in task1 task2 task3; do
    task_counts[$task]=0
    submitted_mentees[$task]=()
done

# Initialize the total mentees count
total_mentees=0

# Read the mentee details file line by line
while IFS=: read -r mentee username roll; do
    # Increment the total mentees count
    ((total_mentees++))
    # Check for each task submission
    for task in task1 task2 task3; do
        mentee_task_file="$core_home/mentees/$username/task_submitted.txt"
        # Check if the mentee task file exists
        if [ -f "$mentee_task_file" ]; then
            # Check if the task is listed in the mentee's task file
            if grep -q "$task" "$mentee_task_file"; then
                ((task_counts[$task]++))
                submitted_mentees[$task]+="$username "
            fi
        else
            # Warn if the mentee task file cannot be read
            echo "Warning: Unable to read $mentee_task_file" >&2
        fi
    done
done < "$mentee_details_file"

# Print the submission status
echo "Submission status:"
for task in task1 task2 task3; do
    if [ $total_mentees -gt 0 ]; then
        # Calculate the percentage of submissions for each task
        percent=$((100 * task_counts[$task] / total_mentees))
    else
        percent=0
    fi
    echo "$task: $percent% submitted"
    # List the mentees who submitted the task
    echo "Mentees who submitted $task: ${submitted_mentees[$task]}"
done

