/***
* Name: segregate0
* Author: kevin
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model segregate0

/* Insert your model definition here */

//Environnment
global {
	int distance_neighbor <- 10;
	float tolerance_rate <- 0.4;
	// Instances agent
	init{
		create people number:2000;
	}
	
}

//create species class people
species people {
	//rgb color <- #yellow;// HTag
	rgb color <- (flip(0.5))?#yellow : #red;
	bool is_happy <- true;

	//agent is happy if he get neighbor, update at each step automaticaly
	list<people> neighbors <- [] update: people at_distance(distance_neighbor);
	 
	 //behavior of agent, it execute at each step # compute happiness
	 reflex compute_happiness{
	 	//number of agents arround
	 	int nb_neighbors <- length(neighbors);
	 	//check neighbor with same color
	 	int nb_neighbors_similar <- neighbors count( each.color = color );
	 	is_happy <- (nb_neighbors_similar / nb_neighbors) > tolerance_rate;
	 	
	 	if(not(is_happy)){
	 		//move randomly in agent environnment where agent is found
	 		location <- any_location_in(world.shape);
	 	}
	 }
	
	//way agent looks
	aspect circle{
		draw circle(2) color: color border: #black;
	}
}

// display agent
experiment my_exp type:gui{
	
	output{
		display map{
			species people aspect: circle;
		}
	}
	
}