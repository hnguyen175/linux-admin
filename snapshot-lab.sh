#!/usr/bin/env bash

# Use English output so the state check can match "shut off".
export LC_ALL=C

# Store the base command and VM names in Bash arrays.
virsh_cmd=(virsh -c qemu:///system)
vms=(jump lst1 lst2)

# $1 is the first argument. Use "lab" if no argument is provided.
label="${1:-lab}"
snapshot="${label}-$(date +%Y%m%d-%H%M%S)"

# Check all three VMs BEFORE creating any snapshots.
for vm in "${vms[@]}"; do
    if ! state=$("${virsh_cmd[@]}" domstate "$vm"); then
        printf 'Could not check VM %s. No snapshots created.\n' "$vm" >&2
        exit 1
    fi

    if [[ "$state" != "shut off" ]]; then
        printf '%s is %s. Shut it down cleanly and retry.\n' "$vm" "$state" >&2
        exit 1
    fi
done

# Try each VM and report whether any failed.
failed=0
for vm in "${vms[@]}"; do
    if "${virsh_cmd[@]}" snapshot-create-as "$vm" "$snapshot"; then
        printf 'OK: %s → %s\n' "$vm" "$snapshot"
    else
        printf 'FAILED: %s\n' "$vm" >&2
        failed=1
    fi
done

exit "$failed"
