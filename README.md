# TOY ROBOT TEST
See instructins.txt for the specification. If run on OSX you can turn your speakers on to get more feedback from the robot. There is also a visual component to the REPORT command, which even though it wasn't required I left in anyway.

## INSTALLING

    git clone git://github.com/robert2d/rea-robot.git
    cd rea-robot
    gem install bundler
    bundle install

## USE

### Interactive:

    $ ./robot.rb
    PLACE 1,2,EAST
    MOVE
    MOVE
    LEFT
    MOVE
    REPORT

### Passing a file:

    $ ./robot.rb test_data.txt

## TESTS

    $ rspec
