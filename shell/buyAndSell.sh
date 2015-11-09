#!/bin/bash
id=$1
price=$2
share=$3
Date=$4
operation=$5

R -f r/buyAndSell.R --args $id $price $share $Date $operation
