
Synth-A-Modeler example
=======================

Example video excerpt from the presentation
["Modal Synthesis using Synth-A-Modeler"][vid-descr-page]
by Pascal Kaap and Zak Berkowitz.

I chose this example video because it was the first freely licensed video
I could find on https://media.ccc.de/ that had a good mix of movement and
semi-freezes within the first few minutes.

* License: CC-BY-SA-4.0, according to comment in video metadata.
* [Video description][vid-descr-page]
* [Smallest MP4 download][video-mp4-smallest]

Since the original video is huge, I created a smaller version:
* Download the initial 7 MB of the [smallest MP4 download][video-mp4-smallest].
* Use only the initial 1m40s (+100 ms to work around a VLC bug).
* Scale down to 360p.
* Discard the audio track.

&rArr; `ffmpeg -i orig-sd.mp4 -to 00:01:40.100`
`-c:v libx264 -vf scale=-1:360 -an -crf 18 -movflags +faststart`
[`synth-a-modeler.mp4`][video-fixture-mirror]

  [vid-descr-page]: https://media.ccc.de/v/minilac16-modalsynthesis
  [video-mp4-smallest]: https://mirror.netcologne.de/CCC/events/lac/minilac16/h264-sd/minilac16-5-eng-Modal_Synthesis_using_Synth-A-Modeler_sd.mp4
  [video-fixture-mirror]: https://github.com/mk-pmb/ffmpeg-freeze-detector/releases/download/dummy/test-fixtures-mirror/synth-a-modeler.mp4


Video track events
------------------

<!-- :BEGIN: video track event transcript -->

```text
00:00:00	Title screen appears, title starts to fade out and move right.
00:00:05	Scene switches to presentation. A man exits stage left.
00:00:06	The man reconsiders and walks to his right instead.
00:00:08	The man exits stage right. Scene stable except for speaker's head.
00:00:21	Slide 2/14: Table of contents.
00:00:14	Slide 3/14 is mostly empty.
00:00:16	Speaker gestures and walks a step to his left.
00:00:18	Speaker turns right to look at the projected slide.
00:00:19	Slide 4/14 has one bullet point. Speaker turns back to audience.
00:00:20	Speaker looks at screen.
00:00:21	Slide 2/14 again: Table of contents. Fancy window movements.
00:00:22	Scene is mostly stable again. Speaker seems to configure something.
00:00:31	A man enters stage right, walks accross, exits stage left.
00:00:33	Major window manager churning, presentation takes full screen again.
00:00:34	Slide 2/14 again: Table of contents.
00:00:35	Slide 1/14: Title page.
00:00:36	Speaker turns right to look at the projected slide.
00:00:38	Speaker turns back to audience.
00:00:39	Speaker looks at audience, then at his screen.
00:00:40	Speaker looks at audience again, scans the room.
00:00:47	Speaker looks at his screen.
00:00:49	A man enters stage left, walks accross.
00:00:50	The man exits stage left.
00:00:57	Speaker gestures.
00:00:59	Speaker is done gesturing.
00:01:03	Video scene fades from stage camera to slideshow only.
00:01:19	Slide 2/14 again: Table of contents.
00:01:27	Slide 3/14 again: mostly empty.
00:01:28	Slide 4/14 again: The single bullet point.
00:01:35	Slide 4/14 still, but a 2nd bullet point appears!
00:01:36	Now stage camera joins as picture-in-picture in bottom left.
00:01:39	Slide 4/14 still, now with a 3rd bullet point.
```

<!-- :ENDOF: video track event transcript -->







