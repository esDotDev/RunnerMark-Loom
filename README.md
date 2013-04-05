RunnerMark
==========

A performance benchmark in the style of an Endless Runner game.

Runner Mark is designed to compare 2d rendering performance various cross-platform solutions.

* <a href="http://vimeo.com/41065357" target="_blank">Watch a video of it in action...</a>

Runner Mark aims to simulate multiple types of simultaneous load, similar to what you would see in a typical game.

Specifically, RunnerMark includes the following elements:

* 1 Main character with a run animation
* Enemies with a “Chomp” animation
* 1 stationary background image (sky)
* 2 Parallax scrolling backgrounds
* Scrolling Ground Tiles
* Scrolling Platforms
* ~50 small dust sprites as your character runs, to simulate some level of a particles
* Rudimentary AI and hit detection for all characters

Scoring System
==============
RunnerMark awards 580pts for rendering the basic scene at a solid 58 FPS. 
Then 1 additional point for each animated Enemy added to the scene. 

As an example, a score of 650 would indicate the basic scene @ 58fps + 70 animated Enemies. A score of 400, indicates the basic scene was only able to render at 40fps, and no Enemy's were added at all. 