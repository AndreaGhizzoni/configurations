### Configuration File for i3wm
Files form *desktop* and *laptop* folder are design ONLY for desktop and laptop.
Files in *common* can be used in both situation.

## Restoring i3 for laptop:
```bash
cp laptop/config ~/.config/i3
cp laptop/i3status* ~/.config/i3
cp laptop/*.bash ~/.config/i3
cp common/*.sh ~/.config/i3
cp common/.Xmodmap ~
``` 

## Restoring i3 for desktop
```bash
cp desktop/config ~/.config/i3
cp desktop/i3status* ~/.config/i3
cp common/*.sh ~/.config/i3
cp common/.Xmodmap ~
``` 

## Restoring multiple monitor configuration [desktop]
**TODO** need to change this with arandr script.

.xprofile -> ~

## Guide
Complete guide [here](http://gist.github.com/AndreaGhizzoni/1e339ab4b7470438b875)
