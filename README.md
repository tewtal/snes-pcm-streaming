# snes-pcm-streaming
Tools and code for streaming high quality PCM audio to the SNES through the controller ports.

### scripts/
Contains a script that takes raw 16-bit 32khz stereo PCM data on stdin, encodes it to the format expected by the SNES payload and then sends it to the replay device.

### smw_pcm/
Contains the code and build scripts to generate a replay input file for Super Mario World that will inject the PCM player payload using Arbitrary Code Execution and run it.

### snes_pcm/
Contains the code and build scripts to generate a standalone ROM of the PCM player that can be run on for example a flashcart.
