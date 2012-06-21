package ;
import flash.Lib;
import haxe.Log;
import haxe.unit.TestRunner;
import org.swiftsuspenders.InjectorTests;

/**
 * ...
 * @author Mike Cann
 */

class Main {
    
    static function main() {

        var r = new TestRunner();
        r.add(new InjectorTests());
        // your can add others TestCase here

        // finally, run the tests
        r.run();
		
		//Lib.current.getChildAt(0).width = Lib.current.stage.stageWidth;
		//Lib.current.getChildAt(0).height = Lib.current.stage.stageHeight;
    }
}