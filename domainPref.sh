#!/usr/bin/env bash

# Base directory
base_dir="/home/cpvbox/Sysad"
core_home="$base_dir/Core"
mentees_dir="$core_home/mentees"

domain_pref() {
    mentee_name=$1
    domain_pref_file="$mentees_dir/$mentee_name/domain_pref.txt"
  
 # Check if mentee exists
    if [ ! -d "$MENTEES_DIR/$mentee_name" ]; then
        echo "Mentee $mentee_name does not exist."
        exit 1
    fi
    echo "Enter your roll number:"
    read roll_no
    echo "Enter your domain preferences (1-3, separated by space):"
    read -a domains
    for domain in "${domains[@]}"; do
     echo $domain >> $mentee_home/domain_pref.txt
     mkdir -p $mentee_dir/$domain
    done
echo "$USER:${domains[*]}" >> $core_home/mentees_domain.txt
echo "Domain preferences set for mentee $mentee_name $roll_no."

}
# Main script execution
current_user=$(whoami)
if [[ ! "$current_user" =~ ^[0-9]{8}$ ]]; then
    echo "Only mentees can set domain preferences."
    exit 1
fi
domain_pref "$current_user"
