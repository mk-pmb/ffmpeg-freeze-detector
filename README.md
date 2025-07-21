
<!--#echo json="package.json" key="name" underline="=" -->
ffmpeg-freeze-detector
======================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Research project for how to detect (semi-)freezes in videos.
<!--/#echo -->


Motivation
----------

* Detect when a streamer leaves to take a break and when they come back.
* Detect video editing accidents like prolonged black screen.



Strategy
--------

* Apply visual similarity detection that produces greyscale output based on
  how similar a frame is to the previous one.
  * Needs to be somewhat resistant against flickering introduced by the
    codec in what should have been solid color.
* Scale that video down to a single pixel for averaging.
* Now brightness should indicate similarity of consecutive frames.
* Detect start and end times of bright sections.



Usage
-----

```text
$ ./test/fixtures/download_fixtures.sh
D: fixture: synth-a-modeler.mp4: have.

$ VIDEO='test/fixtures/synth-a-modeler.mp4'

$ ./src/scan_video_file.sh "$VIDEO" tmp.sam.vfr
D: Scan video file: tmp.sam.vfr <- test/fixtures/synth-a-modeler.mp4 @ 25 fps
D: Done, took 8 seconds (00:00:08), 3441 bytes.

$ ./src/scan_video_file.sh --progress "$VIDEO" tmp.sam.vfr
D: Scan video file: tmp.sam.vfr <- test/fixtures/synth-a-modeler.mp4 @ 25 fps
1.49MiB 0:00:06 [ 247KiB/s] [============================================>] 100%
D: Done, took 8 seconds (00:00:08), 3441 bytes.

$ head -- tmp.sam.vfr
fmt:ffmpeg-freeze-detector
ver:250720.0
fps:25
enc:base64
:

AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAzAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAADBQgQGSAnKy0uLCghHBYRCQMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

$ <tmp.sam.vfr ./src/vfr_to_hhmmss_barchart.sh --durations | head
# timestamp     pixel_heat      thermometer     frames  duration
00:00:00.000    0       [____________________]  129     00:00:05.160
00:00:05.160    204     [####################]  1       00:00:00.040
00:00:05.200    0       [____________________]  61      00:00:02.440
00:00:07.640    3       [#:__________________]  1       00:00:00.040
00:00:07.680    5       [##:_________________]  1       00:00:00.040
00:00:07.720    8       [####________________]  1       00:00:00.040
00:00:07.760    16      [########____________]  1       00:00:00.040
00:00:07.800    25      [############:_______]  1       00:00:00.040
00:00:07.840    32      [################____]  1       00:00:00.040
```





Known issues
------------

* Needs more/better tests and docs.





<!--#toc stop="scan" -->

&nbsp;


License
-------
<!--#echo json="package.json" key="license" -->
ISC
<!--/#echo -->
