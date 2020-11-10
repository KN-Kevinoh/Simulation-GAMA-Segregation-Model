/***
* Name: segregate1
* Author: kevin
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model segregate1

/* Insert your model definition here */

//Environnment also agent
global {
	int distance_neighbor <- 10;
	float tolerance_rate <- 0.4;
	int nb_people <- 2000;
	// Instances agent
	init{
		create people number:nb_people;
	}
	
	//stop simulation when each agent is satisfied, mean they do not move again
	//reflex stopSimulation when: people count( not(each.is_happy)) = 0
	reflex stopSimulation when: people count(each.is_happy) = nb_people{
		do pause;
	}
	
}

//create species class people
species people {
	//rgb color <- #yellow;// HTag
	rgb color <- (flip(0.5))?#yellow : #red;
	bool is_happy <- false;

	//agent is happy if he get neighbor, update at each step automaticaly
	list<people> neighbors <- [] update: people at_distance(distance_neighbor);
	 
	 //behavior of agent, it execute at each step # compute happiness
	 reflex compute_happiness{
	 	//number of agents arround
	 	int nb_neighbors <- length(neighbors);
	 	if(nb_neighbors != 0){
	 		//check neighbor with same color
		 	int nb_neighbors_similar <- neighbors count( each.color = color );
		 	is_happy <- (nb_neighbors_similar / nb_neighbors) > tolerance_rate;
	 	}else{
	 		// write in console which agent is learning
			write "Agent: " + self + " *Division by zero: mean agent is alone!";
	 	}
	 	
	 }
	 
	// move agent, mean change location
	//move randomly in agent environnment where agent is found
	// use facet when
	 reflex move when: not(is_happy) {
	 		//location <- any_location_in(world.shape);
	 		do mov;
	 }
	 
	 action mov{
	 	location <- any_location_in(world.shape);
	 }
	
	//way agent looks
	aspect circle{
		draw circle(2) color: color border: #black;
	}
	
	aspect sphere{
		draw sphere(2) at: {location.x/2, location.y/2, (is_happy)? 100:0} color: color ;
	}
	
	//display depend state
	aspect fake{
		if(color = #red){
			draw circle(2) at: {location.x/2, location.y/2} color: color border: #black;
		}else{
			draw circle(2) at: {location.x/2 + world.shape.height/2, location.y/2 + world.shape.height/2} color: color border: #black;
		}
		
	}
}

// display agent
experiment my_exp type:gui{
	//add parameter which you want to change valiour
	parameter "Tolerance rate" var: tolerance_rate min:0.0 max: 1.0;
	parameter "Distance" var: distance_neighbor;
	
	output{
		display map {
			species people aspect: circle;
		}
		
		display map2 type: opengl{
			species people aspect: sphere;
		}
		
		display nberHappyPeople{
			//diagramme: display data as a series, pie, Histogram, XY chart
			chart "Happy" type: series{
				data "not happy poeple" value: people count(not(each.is_happy)) color:#red;
				data "happy poeple" value: people count(each.is_happy) color:#blue;
			}
		}
		
		// add monitor 
		monitor "not happy" value: people count(not(each.is_happy)) color:#red;
		monitor "happy" value: people count(each.is_happy) color:#blue;
	}
	
}

