import flash.display.Sprite;
import org.flexunit.internals.TraceListener;
import org.flexunit.listeners.CIListener;
import org.flexunit.runner.FlexUnitCore;
import org.swiftsuspenders.suites.SwiftSuspendersTestSuite;

class SwiftSuspendersTestRunner extends Sprite {

	public function new() {
		var core : FlexUnitCore = new FlexUnitCore();
		core.addListener(new CIListener());
		core.addListener(new TraceListener());
		core.run(SwiftSuspendersTestSuite);
	}

}

