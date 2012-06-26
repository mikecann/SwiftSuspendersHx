package ;

import haxe.Log;
import haxe.unit.TestRunner;
import org.swiftsuspenders.ChildInjectorTests;
import org.swiftsuspenders.DependencyProviderTests;
import org.swiftsuspenders.InjectionResultTests;
import org.swiftsuspenders.InjectorTests;
import org.swiftsuspenders.ReflectorBaseTests;

/**
 * ...
 * @author Mike Cann
 */

class Main {
    
    static function main() {

        var r = new TestRunner();
        r.add(new InjectorTests());
        r.add(new ChildInjectorTests());
        r.add(new DependencyProviderTests());
        r.add(new InjectionResultTests());
		//r.add(new ReflectorBaseTests());
        r.run();
    }
}