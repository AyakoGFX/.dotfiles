#!/usr/bin/env bash

 # if [ "* index: 0" == "$(pacmd list-sinks | grep "*" | sed 's/^ *//')" ];
 #    then pacmd set-default-sink 1 && notify-send "Mono";
 #    SINK=1;
 # else
 #    pacmd set-default-sink 0 && notify-send "Stereo";
 #    SINK=0;
 # fi;
 # pacmd list-sink-inputs | grep index | grep -o '[0-9]*' | while read -r line;
 #    do pacmd move-sink-input $line $SINK;
 # done;

 # pipwire
#!/usr/bin/env bash

# Get the current default sink
CURRENT_SINK=$(pactl info | grep "Default Sink:" | awk '{print $3}')

# Set the new default sink and notify
if [ "$CURRENT_SINK" == "alsa_output.pci-0000_07_00.6.HiFi__Headphones__sink.2" ]; then
    # Set the other sink as default if possible (assuming it's `sink:0`)
    NEW_DEFAULT_SINK="alsa_output.pci-0000_07_00.6.HiFi__Headphones__sink.1"  # Replace with actual other sink if exists
    pactl set-default-sink $NEW_DEFAULT_SINK
    notify-send "Mono"
    SINK="$NEW_DEFAULT_SINK"
else
    # Set the current sink as default if it was not previously default
    pactl set-default-sink "alsa_output.pci-0000_07_00.6.HiFi__Headphones__sink.2"
    notify-send "Stereo"
    SINK="alsa_output.pci-0000_07_00.6.HiFi__Headphones__sink.2"
fi

# Move all sink inputs to the new default sink
for INPUT in $(pactl list sink-inputs short | awk '{print $1}'); do
    pactl move-sink-input $INPUT $SINK
done
