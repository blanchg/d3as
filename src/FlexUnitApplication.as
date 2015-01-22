package
{
    import Array;
    
    import d3.arrays.ArrayTests;
    
    import flash.display.Sprite;
    
    import flexunit.flexui.FlexUnitTestRunnerUIAS;
    
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
            testsToRun.push(d3.arrays.ArrayTests);
            return testsToRun;
        }
    }
}