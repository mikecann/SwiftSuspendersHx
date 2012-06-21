package org.swiftsuspenders.haxe;

/**
 * ...
 * @author Mike Cann
 */

class Error 
{
	var message : Dynamic;
	var id : Dynamic;

	public function new(message : String = "", id : String = "") 
	{
		this.message = message;
		this.id = id;
	}
	
	public function toString() : String
	{
		return message + ", " + id;
	}
	
}