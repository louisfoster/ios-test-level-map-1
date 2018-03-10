### General Setup

There is some fairly straight forward starting/setup info in the README of this project and also in the aforementioned earlier project. I will also extract some of the very basic setup stuff into a separate project, [here](https://github.com/louisfoster/edocxcode) such that it can be used to expand upon for other systems/components.


### Previously...

I've previously learned how to do this from a tile map, where there is a matrix and each item in the matrix corresponds to a particular tile, e.g.

A "tile map" list like this:
```swift
let map = [
        
    0, 1,
    0, 0

]
```
should correspond to 4 1x1 tiles. Imagine these tiles, like floor tiles, are laid out such that 0 corresponds to a blue tile and 1 corresponds to a red tile. Now, image when we look down at a flat surface, we have the positive x axis running from left to right and positive y axis running from bottom to top. 

If we add two more variables:
```swift
let mapWidth = 2
let mapHeight = 2
```
we can then have a loop nested within another loop where we iterate over the width (x axis) or "rows" of the matrix, and within that iterate over the height (y axis) or "columns" of the matrix. To get the correct matrix index, we take our current column value, say 0. We then take the current row value, say 1, times by the number of items per row, which is 2. The sum of these values is `0 + (1 * 2)`, 2, which is the third element in the map array `0`.

We can then fetch the appropriate object, a blue tile, and place it at the point of the first column, which is at the origin of the x axis, and 1 unit up the y axis. This is a very basic way to structure a tile map and display the result, and the clearest to understand. This kind of level construction can be then used to relate character and object positions and allow for selection of certain tiles in a map. It isn't also hard to imagine how this could translate into a rudimentary level building tool - which may come later in this project.


### 3D

Imagining flat coloured tiles is a little boring and I like 3D so the next step is translate these ideas over to 3D world. One of the cool things about this method of level building is that when we move our avatar around, or write path-finding algorithms for AI, we can allocate certain rules to each tile beyond how it should appear. If we were to say that each 0 represents a flat, trafficable tile, and each 1 represents a non-trafficable cube, then we can start imagining how this simple tile map can begin to translate into a real-world metaphor.

The key to the simplicity is to be consistent with the sizes of each tile. If have an avatar or objects/characters that are smaller than 1 tile, we can also introduce partially trafficable tiles as this may help with the shaping of barriers etc. Though for now we will keep it simple and manageable.

To implement the tiling of what we will call "floors" and "walls", once we have set up our map information (map matrix and map dimensions) we position our map world, in this case the centre of objects provided by SceneKit appeares to be the centre, and we want the bottom left corner (according to our camera position at `0, 5, 0` looking at `0, 0, 0`) to be in the centre of the view. This means bumping the tiles all by 0.5 or the entire world map by 0.5, up and to the right.

I can acheive this by doing: `let position = SCNVector3(x: 0.5, y: 0, z: -0.5)`. Now, this should make sense as in 3D coordinates, what we are looking down at it the positive x axis going left to right (starting at 0 in the centre of the screen) and the positive z axis going from top to bottom (also starting at 0 in the centre of the screen). Next, we start our tiling.


### Tiling

Because this is just a simple tiling, I have two different types of tiles to repesent our binary IDs. The trafficable tiles to represent the 0s are textured plane geometries rotated to be flat at the 0 point of the y axis (remember we are looking down at the origin from a point in the positive y area). The non-trafficable tiles to represent th 1s are coloured box geometries that are cubes, so they also have a height of 1 unit to indicate their effect as a barrier.

We iterate through the matrix, picking either the plane or box and adding our nodes as so:
```swift
for row in 0..<self.mapHeight {
            
    for column in 0..<self.mapWidth {
        
        let matrixPosition = column + (row * self.mapWidth)
            
        if self.map[matrixPosition] == 0 {
        
            self.addChildNode(self.createPlaneObject(x: Float(column), y: 0, z: Float(-row)))
        }
        else {
            
            self.addChildNode(self.createBoxObject(x: Float(column), y: 0.5, z: Float(-row)))
        }
    }
}
```
the functions creating the objects are relevant as they are basic node creation utilities. However one thing to note is the parameters we are passing to both functions are why they are slightly different.

The parameters are related to each individual tile node's position according to the map node. As the inner loop is iterating across each column of the matrix (left-to-right along the x axis) we pass this value to the node and also the negation of the row value (as we discussed earlier regarding the direction of the z axis). The value 0.5 passed to the y parameter of the box object function is because the 1 unit of height makes half the box appear under the 0 plane of the y axis, so we bump it up so the base is flush with the planes.

Now, in theory this should've looked the way I described, with the bottom left corner appearing at the origin we have centred and the map running off to the right and top leaving the top left, bottom left and bottom right of the screen empty. However, my assumptions about the axis seems to be incorrect: the tiles are appearing in the bottom right. By the ordering of the tiles this implies that what I am looking at is the iteration of x in positive direction from top to bottom and of z in the positive direction from right to left. Basically, what I expected to see rotated 90 degrees clockwise.


### Troubleshooting

In order to understand what is going on, I need to do 2 things. The first is to create a kind of universal "gimbal" that can be attached to any object at any given point and be told that if the point is it's origin, which direction are the x, y and z axes moving in. So, if we were to place it in the world origin, we should then see which way the world coordinate system is and relate that to our map.

The second thing is to create an even less complex map representation so we can get a better idea of how it is flowing and the coordinates of each tile.

The reason we want to get this correct, is that if we were to place a character or object in the world, we want to ensure that it's position can relate directly to the map coordinates so we can control a variety of factors and not have stuff "break." We would also want to be able to translate touching the screen to specific coordinates and tiles in the map in case we want to perform special actions upon a specfic tile (such as edit it in a map building tool or change the appearance based on gameplay).


[Home](./)