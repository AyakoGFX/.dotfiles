#!/bin/sh

ffplay -window_title webcam -video_size 640x480 -framerate 30 -an /dev/video0
