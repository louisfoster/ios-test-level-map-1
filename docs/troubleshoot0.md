### Troubleshooting, round one

As it turns out, the issue wasn't huge. I haven't been able to find out why exactly the way I imagined the coordinate system to be is different to how it appears, but what I have works for now.

What I needed to create first was a simple representation of the world coordinates by illustrating the 3 coordinate vectors. A common method is to first establish a visible point at the world origin (or origin of the item you are analysing), which is always (0, 0, 0).

Then, we create 3 points to represent the 3 vectors: x, y, z. These are: (1, 0, 0), (0, 1, 0) and (0, 0, 0), respectively. This is how it looks:
```swift
let origin = SCNVector3(0, 0, 0)
let xVector = SCNVector3(1, 0, 0)
let yVector = SCNVector3(0, 1, 0)
let zVector = SCNVector3(0, 0, 1)
```
It is then just a matter of exploiting the box node helper function we created earlier to build a tiny cube at each of these points with appropriate colours (white for origin and rgb for xyz, respectively).

At our usual camera position at some point on y looking at the world origin, what we see is this:
![gimbal0]({{ "./assets/gimbal0.png" | absolute_url }})

As assumed, and indicated in the image, the x axis moves from top to bottom and the z axis moves from right to left. This is fine, I just need to adjust our perception of the coordinates. Although we could continue with the negative and inverted placement of the map index loop to our world, I tend to prefer keeping the numbers positive without requiring and funky conversions. So, we can say that the positive x takes the positive row value and the positive z takes the positive column value.

What we end up with is something that looks like this:
![adjustedworld]({{ "./assets/adjustedworld.png" | absolute_url }})


#### Refactoring

I removed the tile creation code from the Map class so that in the Map class we are dealing purely with the Map object itself. The creation of the tiles based on the data in the Map object's map property is passed to the Tile class such that it can decide what kind of tile it wants to be and how it should appear, as well as storing this piece of data associated with the particular tile node. This required a little refactoring of the box/plane creation helper functions.

Later, the map property will need to be turned into some kind of data structure so that we can pass a variety of details to the Tile object to dictate more than just whether it is a box or a plane.


#### Moving on...

The reason for storing particular data about the tiles is that we want to be able to use a hit test to extract some information particular nodes in the case of certain events. One particular event is the touch gesture, which may dictate that a player wants their avatar to move to a certain coordinate. This means we need to decide if it possible for the character to move to that particular tile, and if so, which tiles it can traffic along the way (if at all).

To start with, we simply want to move the camera to the touched tile as a proof of concept.

In order to implement these two things we need some kind input component that can notify the tile that it has received a "hit" (ie nothing above it was tapped), and a gesture recogniser to manage the various gestures and actions associated with them in order to feed into the input.

[Home](./)