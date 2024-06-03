#!/bin/bash

# Set core user and base directory
core_user="/home/cpvbox/Sysad/Core"
base_dir="$core_user"

# Directories under Core's home directory
sudo mkdir -p "$base_dir/mentors"
sudo mkdir -p "$base_dir/mentees"

# Create directories for Webdev, Appdev, and Sysad under mentors
sudo mkdir -p "$base_dir/mentors/Webdev"
sudo mkdir -p "$base_dir/mentors/Appdev"
sudo mkdir -p "$base_dir/mentors/Sysad"

# Read mentor details and create mentor accounts and directories
while IFS= read -r line; do
    mentor_name=$(echo "$line" | cut -d' ' -f1)
    domain=$(echo "$line" | cut -d' ' -f2)

    mentor_dir="$base_dir/mentors/${domain}/$mentor_name"

    # Create user and home directory based on domain
    sudo useradd -m -d "$mentor_dir" "$mentor_name"
    echo "$mentor_name:Del24mentor$$" | sudo chpasswd  # Replace 'password' with the actual password

    # Create required files and directories in mentors' home directories
    sudo touch "$mentor_dir/allocatedMentees.txt"
    sudo mkdir -p "$mentor_dir/submittedTasks/task"{1,2,3}
done < mentorDetails.txt

# Read mentee details and create mentee accounts and directories
while IFS= read -r line; do
    mentee_name=$(echo "$line" | cut -d' ' -f1 | tr -d '\r')
    roll_no=$(echo "$line" | cut -d' ' -f2 | tr -d '\r')

    mentee_dir="$base_dir/mentees/$roll_no"

    # Create user and home directory
    sudo useradd -m -d "$mentee_dir" "$mentee_name"
    echo "$mentee_name:Del24mentee$$" | sudo chpasswd  # Replace 'password' with the actual password

    # Create required files in mentees' home directories
    sudo touch "$mentee_dir/domain_pref.txt"
    sudo touch "$mentee_dir/task_completed.txt"
    sudo touch "$mentee_dir/task_submitted.txt"
done < <(tr -d '\r' < menteeDetails.txt)

# Set permissions so Core can access everyone's home directories
sudo setfacl -R -m u:Core:rwx "$base_dir/mentees"
sudo setfacl -R -m u:Core:rwx "$base_dir/mentors"

# Ensure mentors cannot access other mentors' home directories
for dir in "$base_dir/mentors"/*; do
    for subdir in "$dir"/*; do
        sudo chmod 700 "$subdir"
    done
done

# Ensure mentees can only access their own home directory
for dir in "$base_dir/mentees"/*; do
    sudo chmod 700 "$dir"
done

# Create mentees_domain.txt in Core's home directory
mentees_domain_file="$base_dir/mentees_domain.txt"
sudo touch "$mentees_domain_file"
sudo chown Core:Core "$mentees_domain_file"
sudo chmod 222 "$mentees_domain_file"

echo "User Generation Completed"
