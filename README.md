
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

$ ./src/scan_video_file.sh test/fixtures/synth-a-modeler.mp4 tmp.sam.vfr
D: Scan video file: tmp.sam.vfr <- test/fixtures/synth-a-modeler.mp4
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
