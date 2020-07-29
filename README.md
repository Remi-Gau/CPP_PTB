# CPP_PTB

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

This is List of Crossmodal Perception and Plasticity lab (CPP) PsychToolBox (PTB) toolbox.

Those functions are mostly wrappers around some PTB functions to facilitate their use and to have a codebase to facilitate their reuse.


## Requirements

Make sure that the following toolboxes are installed and added to the matlab / octave path.

For instructions see the following links:

| Requirements                                             | Used version |
|----------------------------------------------------------|--------------|
| [PsychToolBox](http://psychtoolbox.org/)  Duuuuhh        | >=3.0.14     |
| [Matlab](https://www.mathworks.com/products/matlab.html) | 201??        |
| or [octave](https://www.gnu.org/software/octave/)        | 4.?          |

The exact version required for this to work but it is known to work with:
-   matlab 2017a or octave 4.2.2 and PTB 3.0.16.

## Code guidestyle

We use the `camelCase` to more easily differentiates our functions from the ones from PTB that use a `PascalCase`.
We use the following regular expression for function names: `[a-z]+(([A-Z]|[0-9]){1}[a-z]+)*`.

We keep the McCabe complexity as reported by the [check_my_code function](https://github.com/Remi-Gau/check_my_code) below 15.

We use the [MISS_HIT linter](https://florianschanda.github.io/miss_hit/style_checker.html) to automatically fix some linting issues.

## How to install

### Use the matlab package manager

This repository can be added as a dependencies by listing it in a [mpm-requirements.txt file](.mpm-requirements.txt)
as follows:

    CPP_PTB -u https://github.com/cpp-lln-lab/CPP_PTB.git

You can then use the [matlab package manager](https://github.com/mobeets/mpm), to simply download the appropriate version of those dependencies and add them to your path by running a `getDependencies` function like the one below where you just need to replace `YOUR_EXPERIMENT_NAME` by the name of your experiment.

```matlab
  function getDependencies(action)
  % Will install on your computer the matlab dependencies specified in the mpm-requirements.txt
  %  and add them to the matlab path. The path is never saved so you need to run getDependencies() when
  %  you start matlab.
  %
  % getDependencies('update') will force the update and overwrite previous version of the dependencies.
  %
  % getDependencies() If you only already have the appropriate version but just want to add them to the matlab path.

  experimentName = YOUR_EXPERIMENT_NAME;

  if nargin<1
      action = '';
  end

  switch action
      case 'update'
          % install dependencies
          mpm install -i mpm-requirements.txt -f -c YOUR_EXPERIMENT_NAME
  end

  % adds them to the path
  mpm_folder = fileparts(which('mpm'));
  addpath(genpath(fullfile(mpm_folder, 'mpm-packages', 'mpm-collections', experimentName)));

  end
```

## Setting up keyboards

To select a specific keyboard to be used by the experimenter or the participant, you need to know
the value assigned by PTB to each keyboard device.

To know this copy-paste this on the command window:

``` matlab
[keyboardNumbers, keyboardNames] = GetKeyboardIndices;

disp(keyboardNumbers);
disp(keyboardNames);
```

You can then assign a specific device number to the main keyboard or the response box in the `cfg` structure

-   `cfg.keyboard.responseBox` would be the device number of the device used by the participant to give his/her
response: like the button box in the scanner or a separate keyboard for a behavioral experiment
-   `cfg.keyboard.keyboard` would be the device number of the keyboard on which the experimenter will type or
press the keys necessary to start or abort the experiment.

`cfg.keyboard.responseBox` and `cfg.keyboard.keyboard` can be different or the same.

Using empty vectors (ie `[]`) or a negative value for those means that you will let PTB find and use the default device.

## Structure

```matlab

cfg.testingDevice = 'pc';

% cfg.color
cfg.keyboard.keyboard = [];
cfg.keyboard.responseBox = [];
cfg.keyboard.responseKey = {};
cfg.keyboard.escapeKey = 'ESCAPE';

% cfg.debug
cfg.debug.do = true;
cfg.debug.transpWin = true;
cfg.debug.smallWin = true;

% cfg.text
cfg.text.font 
cfg.text.size 
cfg.text.style 

% cfg.color
cfg.color.background

% cfg.screen
cfg.screen.monitorWidth
cfg.screen.monitorDistance
cfg.screen.idx
cfg.screen.win 
cfg.screen.winRect 
cfg.screen.winWidth 
cfg.screen.winHeight 
cfg.screen.center 
cfg.screen.FOV
cfg.screen.ppd 
cfg.screen.ifi 
cfg.screen.monRefresh 

% cfg.audio
cfg.audio.do
cfg.audio.pahandle
cfg.audio.devIdx
cfg.audio.playbackMode
cfg.audio.requestedLatency
cfg.audio.fs
cfg.audio.channels
cfg.audio.initVolume
cfg.audio.pushSize  
cfg.audio.requestOffsetTime 
cfg.audio.reqsSampleOffset

% cfg.mri
cfg.mri.repetitionTime
cfg.mri.triggerNb
cfg.mri.triggerKey
```

## function details


### initPTB

This will initialize PsychToolBox

-   screen
-   the windon opened takes the whole screen by default
-   set in debug mode with window transparency if necessary
-   can skip synch test if you ask for it (nicely)
-   gets the flip interval
-   computes the pixel per degree of visual angle
-   set font details
-   keyboard
-   sound

### testKeyboards

Checks that the keyboards asked for properly connected.

If no key is pressed on the correct keyboard after the timeOut time this exits with an error.

### cleanUp

A wrapper function to close all windows, ports, show mouse cursor, close keyboard queues
and give access back to the keyboards.

### getResponse

It is wrapper function to use `KbQueue` which is definitely what you should use to collect responses.

You can easily collect responses while running some other code at the same time.

It will only take responses from one device which can simply be the "main keyboard" 
(the default device that PTB will find) or another keyboard connected to the computer 
or the response box that the participant is using.

You can use it in a way so that it only takes responses from certain keys and ignore others (like
the triggers from an MRI scanner).

If you want to know more on how to use it check its help section and the `CPP_getResponseDemo.m`.

In brief, there are several actions you can execute with this function.

-   init: initialize the buffer for key presses on a given device (you can also specify the keys of interest that should be listened to).
-   start: start listening to the key presses (carefully insert into your script - where do you want to start buffering the responses).
-   check: till that point, it will check the buffer for all key presses. 
    -   It only reports presses on the keys of interest mentioned at initialization.
    -   It **can** also check for presses on the escape key and abort if the escape key is part of the keys of interest.
-   flush: Empties the buffer of key presses in case you want to discard any previous key presses.
-   stop: Stops buffering key presses. You can still restart by calling "start" again.
-   release: Closes the buffer for good.



### deg2Pix

For a given field value in degrees of visual angle in the input `structure`,
this computes its value in pixel using the pixel per degree value of the `cfg` structure
and returns a structure with an additional field with Pix suffix holding that new value.

### drawFixationCross

Define the parameters of the fixation cross in `cfg` and `expParameters` and this does the rest.

### eyeTracker

This will handle the Eye Tracker (EyeLink set up) and can be called to initialize the connection and start the calibration, start/stop eye(s) movement recordings and save the `*.edf` file (named with BIDS specification from cpp-lln-lab/CPP_BIDS).  

### pressSpace4me

Use that to stop your script and only restart when the space bar is pressed.


### waitForTrigger

Counts a certain number of triggers coming from the mri/scanner before returning.
Requires number of triggers to wait for.


## Annexes

### Experiment template [ WIP ]

### devSandbox (stand-alone)

This script is a stand-alone function that can be useful as a sandbox to develop the PTB audio/visual stimulation of your experiment. No input/output required.

Here, a tutorial from https://peterscarfe.com/contrastgratingdemo.html is provided for illustrative purpose (notice that some variable names are updated to our code style). For your use, you will delete that part.

It is composed of two parts:
 - a fixed structure that will initialize and close PTB in 'debug mode'
    (`PsychDebugWindowConfiguration`, `SkipSyncTests`)
 - the actual sandbox where to set your dynamic variables (the stimulation
   parameters) and the 'playground' where to develop the stimulation code

 When you are happy with it, ideally you will move the vars in `setParameters.m` and the stimulation code in a separate function in `my-experiment-folder/subfun`. The code style and variable names are the same used in `cpp-lln-lab/CPP_PTB` github repo, therefore it should be easy to move everything in your experiment scripts (see the template that is annexed in `cpp-lln-lab/CPP_PTB`).

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://remi-gau.github.io/"><img src="https://avatars3.githubusercontent.com/u/6961185?v=4" width="100px;" alt=""/><br /><sub><b>Remi Gau</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_PTB/commits?author=Remi-Gau" title="Code">💻</a> <a href="#design-Remi-Gau" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_PTB/commits?author=Remi-Gau" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/marcobarilari"><img src="https://avatars3.githubusercontent.com/u/38101692?v=4" width="100px;" alt=""/><br /><sub><b>marcobarilari</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_PTB/commits?author=marcobarilari" title="Code">💻</a> <a href="#design-marcobarilari" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_PTB/commits?author=marcobarilari" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/CerenB"><img src="https://avatars1.githubusercontent.com/u/10451654?v=4" width="100px;" alt=""/><br /><sub><b>CerenB</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_PTB/commits?author=CerenB" title="Code">💻</a> <a href="#design-CerenB" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_PTB/commits?author=CerenB" title="Documentation">📖</a> <a href="https://github.com/cpp-lln-lab/CPP_PTB/pulls?q=is%3Apr+reviewed-by%3ACerenB" title="Reviewed Pull Requests">👀</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
