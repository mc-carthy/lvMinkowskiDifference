# MinkowskiDifference

A small project to demonstrate the use of the Minkowski Difference to resolve collisions

In this project, there are two boxes, 1 which is controlled using WASD, the other with the arrow keys.

You can toggle collision resolution with the space key.

By default, collisions are resolved as if the boxes are of equal mass. This can be changed in the code by changing the mass property of boxA or boxB.

If you want to simulate collisions where one of the boxes are static, simply set the mass of the other box to 0.

The minimum penetration vector is shown in the top-left corner. This is found by taking the minumum x & y offsets required to ensure the boxes don't overlap, then taking the minumum between those. Note: This is the minimum of the magnitude of the values (e.g. -2 is smaller than 4)
