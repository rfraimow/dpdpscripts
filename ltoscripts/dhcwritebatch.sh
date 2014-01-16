#!/bin/bash
# Write a specified numbered batch of DHC files to two tapes 

# Prompt user for batch number in 4 digit numerical string
printf "Please enter the batch id to be archived (e.g. 0099):\n"
read batch_id
if [[ "$batch_id" != [0-9][0-9][0-9][0-9] ]]; then
   printf "Invalid tape id."
   exit
fi
tape_id="DA$batch_id"
# Start up, ask for tape from pool A and mount
mkdir -p /mnt/$tape_id
printf "\nArchiving $batch_id...\n"
printf "Please insert tape $tape_id and press enter when it is available.\n"
read junk_catcher

printf "Mounting $tape_id...\n"
# On user acknowledgement attempt to mount tape, 
if ! ltfs -o devname=/dev/st0 /mnt/$tape_id; then
   printf "LTFS mount failed!"
   exit
fi
# done

# Tape loaded let's copy some files
  rsync -avv --progress /mnt/raid1/processed_SIPs/$batch_id/* /mnt/$tape_id/
  ls -1 /mnt/$tape_id/ > /mnt/$tape_id/$tape_id\_Contents.txt
  sleep 60
  umount /mnt/$tape_id
  sleep 30
  ltfs -o eject

# On to the second copy in Pool B
tape_id="DB$batch_id"
# Start up, ask for tape from pool A and mount
mkdir -p /mnt/$tape_id

while [[ $junk_catcher != "y" ]]
do
   printf "Please insert tape $tape_id, then type y and press enter when it is available.\n"
   read junk_catcher
done

printf "Mounting $tape_id...\n"
# On user acknowledgement attempt to mount tape, 
if ! ltfs -o devname=/dev/st0 /mnt/$tape_id; then
   printf "LTFS mount failed!"
   exit
fi
# done

# Tape loaded let's copy some files
  rsync -avv --progress /mnt/raid1/processed_SIPs/$batch_id/* /mnt/$tape_id/
  ls -1 /mnt/$tape_id/ > /mnt/$tape_id/$tape_id\_Contents.txt
  sleep 60
  umount /mnt/$tape_id
  sleep 30
  ltfs -o eject

printf "\n\nOperation complete.\n"
