#!/bin/sh

t="ptenbrock/ici"
rc="ros-core"
s="shadow-fixed"
for r in ros ros-shadow-fixed; do
   s=${r#ros}
   docker tag $t:indigo-$rc-trusty$s $t:indigo-$rc$s
   docker tag $t:kinetic-$rc-xenial$s $t:kinetic-$rc$s
   docker tag $t:lunar-$rc-xenial$s $t:lunar-$rc$s
   docker tag $t:melodic-$rc-bionic$s $t:melodic-$rc$s
done
