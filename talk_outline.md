# Proprietary silicon ICs and dubious marketing claims? Let's fight those with a microscope!


1. What are we talking about today?
   1. Silicon chips!
   2. They power a lot of electronics: computers, washing machines, cars, video games, musical instruments
   3. Sometimes they can be completely documented/open source
      1. Example: RP2040
   4. Other times info can be harder to get
      1. Example: PS1
   5. Other times it's custom/undocumented and no luck getting info about it
      1. Example: Arcade games, Roland ESP
2. Why working on this stuff?
   1. Electronics die, preservation is important
   2. We can learn a lot of cool things: algorithms, tricks they used
   3. Sometimes companies make marketing claims that turn out to not be true
3. Disclaimer: I'm a software engineer and self taught
4. How does it work?
   1. Principle: you can learn a lot by just looking at it
   2. Decapping and microscoping (cool, but won't get into)
   3. Determine chip type/areas
      1. ROM
      2. RAM
      3. I/O pins
      4. CMOS transistors
      5. Gate arrays
      6. Standard Cells
      7. Different manufacturers/series
      8. NOT/NAND gates
      9. Multipliers
      10. Big cells (adders, counters, flip flops)
   4. By just looking qualitatively at those components, you can narrow down a lot what the chip does
   5. What about when it's not enough?
      1. Tracing!
5. My situation
   1. Roland MKS-20, how the hell did it work?
   2. People online have no idea
   3. Absurd claims
   4. I'm no engineer, but nerd sniped
   5. Nukeykt did it for the SC-55, why can't I?
   6. Bought a board
   7. Sent it to InfoSecDJ and Furrtek
   8. Pictures!
6. Fujitsu GA
   1. Find pinout
   2. Cells ident
      1. Find boundaries
      2. Use script to divide them by height, then group them by hand
      3. Count input and outputs
      4. Fujitsu databook
      5. Previously done RE
      6. Guess from components
      7. Spreadsheet
   3. Trace the chip
   4. Reconstruct Verilog
   5. Refactor verilog
      1. Name things backwards
      2. Find cycle counter
      3. Find what value in RAM mean
7. The answer
   1. It's a sample player
   2. Just that the address lines are scrambled
   3. Log encoding to avoid multiplication!
8. Learnings
   1. What worked
      1. Automated svg->verilog
      2. Inkscape
      3. MAME
   2. What didn't work
      1. KiCAD converter
      2. Verilog simulation
      3. Computer vision
9. Next steps
   1.  Fujitsu standard cell! (D-70)
   2.  Namco N163 chip



1. Why
   1. Digital chips can be perfectly replicated
      1. They implement logic functions that can be accurately emulated with a cpu
      2. Rarely they use analog logic
      3. Example: show ic, then schematic, then code
   2. Soon a lot of them will die, and people will not be able to use them anymore?
   3. Why do we still want to use them?
      1. Learning how stuff worked (cool algorithms that get forgotten)
      2. Emulation (games, effects, synths)
      3. Repair
2. How did I start
   1. I'm a software engineer, I have no idea what I'm doing
   2. But I'm a musician and I love synths, there is one specifically that no one has any idea how it works and that was bothering me so much
   3. In particular, people were saying confusing things about how it worked
   4. In short: I got severely nerd sniped
3. SiliconPr0n and decapping
   1. Microscope pics
   2. Why: quote on why it works
   3. Sometimes you need more deprocessing
4. What are chips made of (CMOS especially)
   1. P/N parts
   2. Polysilicon
   3. Metal
   4. Oxide (SiO2, passivation)
5. In short: CMOS works with two transistors, and they work as switches
   1. You want to find where they are and what they connect to (3 wires)
   2. Example with code
6. Let's look at some chips!
   1. By looking at it at a high level you can already figure out stuff
   2. Modern chips: extremely difficult
   3. Older chips: very possible
   4. RAM
   5. ROM
      1. Metal VS implant
   6. Gate array
   7. Standard cell
   8. Multipliers
   9. Sometimes analog parts (DAC)
7.  How I reverse engineered them
   1. Find pinout
   2. Isolate cells
   3. Build cell library
   4. Trace wires
   5. Process
8.  Automation!
   1. Auto cell finding (doesn't work too well)
   2. Auto wiring (neither)
   3. SVG to Verilog (works well!)
      1. Load with JS
      2. Identify the cells
      3. Find for each cell the wire id that goes to each port
      4. Auto convert logic ports to code
      5. Export Verilog
9.  Understand verilog
   1.  Go backwards, give name to things
   2.  Identify cycles and counters
   3.  Group things together
10. What I found
    1.  My mysterious synth is actually just a sample player lol
    2.  Scrambling on the address/data lines



# Sources
- https://en.wikipedia.org/wiki/LGA_775#/media/File:Intel_CPU_Pentium_4_640_Prescott_bottom.jpg
- https://commons.wikimedia.org/wiki/File:Yamaha_YMF262_audio_IC_decapsulated.jpg (PD)
- InfosecDJ
- Caps0ff
- Zeptobars
- SiliconPr0n
- McMaster
