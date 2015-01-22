package
{
    import Array;
    
    import d3.arrays.ArrayTests;
    
    import flash.display.Sprite;
    
    import flexunit.flexui.FlexUnitTestRunnerUIAS;
    
    import org.flexunit.runner.Request;
    
    public class FlexUnitApplication extends Sprite
    {
        public function FlexUnitApplication()
        {
            onCreationComplete();
        }
        
        private function onCreationComplete():void
        {
            var testRunner:FlexUnitTestRunnerUIAS=new FlexUnitTestRunnerUIAS();
            testRunner.portNumber=8765; 
            this.addChild(testRunner); 
            testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "d3as");
        }
        
        public function currentRunTestSuite():Array
        {
            var testsToRun:Array = new Array();
            testsToRun.push(Request.methods(d3.arrays.ArrayTests,["ascendingTest",
                "descendingTest",
                "bisectTest",
                "deviationTest"]));
            
            return testsToRun;
        }
    }
}